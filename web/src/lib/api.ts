import type {
  Movie,
  Category,
  Country,
  EpisodeServer,
  DataListResponse,
  MovieDetailResponse,
  Pagination,
} from './types'

const BASE_URL = 'https://vsmov.com/api'

async function fetchAPI<T>(
  path: string,
  params?: Record<string, string | number>,
  fallback?: T,
): Promise<T> {
  const url = new URL(`${BASE_URL}${path}`)
  if (params) {
    Object.entries(params).forEach(([k, v]) =>
      url.searchParams.set(k, String(v)),
    )
  }
  const res = await fetch(url.toString(), {
    headers: { Accept: 'application/json' },
    cache: 'no-store',
  })
  if (!res.ok) {
    if (fallback !== undefined) return fallback
    throw new Error(`API error: ${res.status} for ${url.toString()}`)
  }
  const text = await res.text()
  try {
    return JSON.parse(text)
  } catch {
    if (fallback !== undefined) return fallback
    throw new Error(`Invalid JSON from ${url.toString()}`)
  }
}

type MovieList = { status: boolean; items: Movie[]; pagination?: Pagination }

const STRING_FIELDS = [
  'origin_name',
  'poster_url',
  'thumb_url',
  'quality',
  'lang',
  'time',
  'type',
  'status',
  'episode_current',
  'episode_total',
] as const

function normalizeMovie(movie: Movie): Movie {
  const record = movie as unknown as Record<string, unknown>
  for (const key of STRING_FIELDS) {
    const value = record[key]
    if (value != null && typeof value !== 'string') {
      record[key] = undefined
    }
  }
  return movie
}

export function normalizeMovieList(list: MovieList): MovieList {
  return {
    ...list,
    items: (list.items ?? []).map(normalizeMovie),
  }
}

export function getNewMovies(page = 1) {
  return fetchAPI<MovieList>('/danh-sach/phim-moi-cap-nhat', { page }).then(normalizeMovieList)
}

export function getSubteam(limit = 20) {
  return fetchAPI<MovieList>('/danh-sach/subteam', { limit }, { status: false, items: [] }).then(normalizeMovieList)
}

export function getMoviesByListPath(path: string, page = 1, limit = 24) {
  return fetchAPI<MovieList>(`/danh-sach/${path}`, { page, limit }, { status: false, items: [] }).then(normalizeMovieList)
}

export function searchMovies(keyword: string, page = 1, limit = 20) {
  return fetchAPI<MovieList>('/tim-kiem', { keyword, page, limit }).then(normalizeMovieList)
}

export function getCategories() {
  return fetchAPI<DataListResponse<Category>>('/the-loai')
}

export function getMoviesByCategory(
  slug: string,
  params?: {
    limit?: number
    page?: number
    year?: string
    country?: string
    type?: string
    status?: string
  },
) {
  return fetchAPI<MovieList>(`/the-loai/${slug}`, params).then(normalizeMovieList)
}

export function getCountries() {
  return fetchAPI<DataListResponse<Country>>('/quoc-gia')
}

export function getMoviesByCountry(
  slug: string,
  params?: {
    limit?: number
    page?: number
    year?: string
    type?: string
    status?: string
  },
) {
  return fetchAPI<MovieList>(`/quoc-gia/${slug}`, params).then(normalizeMovieList)
}

export function getYears() {
  return fetchAPI<DataListResponse<Category>>('/nam')
}

export function getMoviesByYear(
  year: string,
  params?: {
    limit?: number
    page?: number
    type?: string
    status?: string
  },
) {
  return fetchAPI<MovieList>(`/nam/${year}`, params).then(normalizeMovieList)
}

export function getMovieDetail(slug: string) {
  return fetchAPI<MovieDetailResponse>(`/phim/${slug}`, undefined, { status: false, movie: null })
}

export async function getMovieEpisodes(
  slug: string,
): Promise<{ status: boolean; episodes: EpisodeServer[] }> {
  try {
    const res = await fetch(`https://vsmov.com/phim/${slug}`, {
      headers: { 'User-Agent': 'Mozilla/5.0' },
    })
    const html = await res.text()

    const start = html.indexOf('[{"server_name"')
    if (start < 0) return { status: false, episodes: [] }

    let depth = 0
    let inStr = false
    let end = start
    for (let i = start; i < html.length; i++) {
      const ch = html[i]
      if (ch === '\\' && inStr) continue
      if (ch === '"') { inStr = !inStr; continue }
      if (inStr) continue
      if (ch === '[') depth++
      if (ch === ']') { depth--; if (depth === 0) { end = i + 1; break } }
    }

    let raw = html.slice(start, end)
    raw = raw.replace(/[\x00-\x1f\x7f]/g, '')
    raw = raw.replace(/\\\//g, '/')
    raw = raw.replace(/\\"/g, '"')
    raw = raw.replace(/\\n/g, '')
    raw = raw.replace(/\\r/g, '')

    const episodes: EpisodeServer[] = JSON.parse(raw)
    return { status: true, episodes }
  } catch {
    return { status: false, episodes: [] }
  }
}
