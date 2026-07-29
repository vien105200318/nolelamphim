const BASE_URL = 'https://vsmov.com/api'
const DEFAULT_REVALIDATE = 60 // 1 phút cache

async function fetchAPI<T>(path: string, params?: Record<string, string | number>): Promise<T> {
  const url = new URL(`${BASE_URL}${path}`)
  if (params) {
    Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, String(v)))
  }
  const res = await fetch(url.toString(), {
    next: { revalidate: DEFAULT_REVALIDATE },
  })
  if (!res.ok) throw new Error(`API error: ${res.status}`)
  return res.json()
}

// --- Home ---
export function getNewMovies(page = 1) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(
    '/danh-sach/phim-moi-cap-nhat',
    { page }
  )
}

export function getSubteam(limit = 20) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(
    '/danh-sach/subteam',
    { limit }
  )
}

// --- Search ---
export function searchMovies(keyword: string, page = 1, limit = 20) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(
    '/tim-kiem',
    { keyword, page, limit }
  )
}

// --- Categories ---
export function getCategories() {
  return fetchAPI<import('./types').DataListResponse<import('./types').Category>>('/the-loai')
}

export function getMoviesByCategory(
  slug: string,
  params?: { limit?: number; page?: number; year?: string; country?: string; type?: string; status?: string }
) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(`/the-loai/${slug}`, params)
}

// --- Countries ---
export function getCountries() {
  return fetchAPI<import('./types').DataListResponse<import('./types').Country>>('/quoc-gia')
}

export function getMoviesByCountry(
  slug: string,
  params?: { limit?: number; page?: number; year?: string; type?: string; status?: string }
) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(`/quoc-gia/${slug}`, params)
}

// --- Years ---
export function getYears() {
  return fetchAPI<import('./types').DataListResponse<import('./types').Category>>('/nam')
}

export function getMoviesByYear(
  year: string,
  params?: { limit?: number; page?: number; type?: string; status?: string }
) {
  return fetchAPI<{ status: boolean; items: import('./types').Movie[] }>(`/nam/${year}`, params)
}

// --- Movie Detail ---
export function getMovieDetail(slug: string) {
  return fetchAPI<import('./types').MovieDetailResponse>(`/phim/${slug}`)
}
