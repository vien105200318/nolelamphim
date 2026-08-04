export interface RecentItem {
  id: number
  slug: string
  name: string
  thumb: string
  episode?: string
  episodeSlug?: string
  watchedAt: number
}

export interface FavoriteItem {
  id: number
  name: string
  slug: string
  thumb: string
}

export function readJSON<T>(key: string, fallback: T): T {
  try {
    const raw = localStorage.getItem(key)
    return raw ? (JSON.parse(raw) as T) : fallback
  } catch {
    return fallback
  }
}

export function writeJSON(key: string, value: unknown) {
  localStorage.setItem(key, JSON.stringify(value))
}

export function getRecent(): RecentItem[] {
  return readJSON<RecentItem[]>('recent', [])
}

export function addRecent(item: Omit<RecentItem, 'watchedAt'>) {
  const next = [
    { ...item, watchedAt: Date.now() },
    ...getRecent().filter((r) => r.slug !== item.slug),
  ].slice(0, 20)
  writeJSON('recent', next)
}

export function removeRecent(slug: string) {
  writeJSON('recent', getRecent().filter((r) => r.slug !== slug))
}

export function getFavorites(): FavoriteItem[] {
  return readJSON<FavoriteItem[]>('favorites', [])
}

export function isFavorite(id: number) {
  return getFavorites().some((f) => f.id === id)
}

export function toggleFavorite(item: FavoriteItem): boolean {
  const favs = getFavorites()
  const exists = favs.some((f) => f.id === item.id)
  const next = exists ? favs.filter((f) => f.id !== item.id) : [...favs, item]
  writeJSON('favorites', next)
  return !exists
}

export function getRatings(): Record<string, number> {
  return readJSON<Record<string, number>>('ratings', {})
}

export function saveRating(slug: string, value: number) {
  const next = { ...getRatings(), [slug]: value }
  writeJSON('ratings', next)
}

export function getRecentSearches(): string[] {
  return readJSON<string[]>('recent-searches', [])
}

export function saveRecentSearches(arr: string[]) {
  writeJSON('recent-searches', arr.slice(0, 8))
}
