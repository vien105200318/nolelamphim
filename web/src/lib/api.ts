import type {
  Movie,
  Category,
  Country,
  DataListResponse,
  MovieDetailResponse,
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

type MovieList = { status: boolean; items: Movie[] }

export function getNewMovies(page = 1) {
  return fetchAPI<MovieList>('/danh-sach/phim-moi-cap-nhat', { page })
}

export function getSubteam(limit = 20) {
  return fetchAPI<MovieList>('/danh-sach/subteam', { limit }, { status: false, items: [] })
}

export function searchMovies(keyword: string, page = 1, limit = 20) {
  return fetchAPI<MovieList>('/tim-kiem', { keyword, page, limit })
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
  return fetchAPI<MovieList>(`/the-loai/${slug}`, params)
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
  return fetchAPI<MovieList>(`/quoc-gia/${slug}`, params)
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
  return fetchAPI<MovieList>(`/nam/${year}`, params)
}

export function getMovieDetail(slug: string) {
  return fetchAPI<MovieDetailResponse>(`/phim/${slug}`)
}
