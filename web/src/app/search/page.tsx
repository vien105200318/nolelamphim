'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import {
  searchMovies,
  getCategories,
  getCountries,
  getYears,
  getMoviesByCategory,
  getMoviesByCountry,
  getMoviesByYear,
  getNewMovies,
} from '@/lib/api'
import type { Movie, Category, Country } from '@/lib/types'
import MovieCard from '@/components/MovieCard'

type FilterType = 'category' | 'country' | 'year'

interface ActiveFilter {
  type: FilterType
  label: string
  value: string
}

const filterConfig = [
  { key: 'category' as const, label: 'Thể loại' },
  { key: 'country' as const, label: 'Quốc gia' },
  { key: 'year' as const, label: 'Năm' },
]

export default function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<Movie[]>([])
  const [loading, setLoading] = useState(false)
  const [initialLoading, setInitialLoading] = useState(true)

  const [categories, setCategories] = useState<Category[]>([])
  const [countries, setCountries] = useState<Country[]>([])
  const [years, setYears] = useState<Category[]>([])
  const [openDropdown, setOpenDropdown] = useState<FilterType | null>(null)

  const [activeFilter, setActiveFilter] = useState<ActiveFilter | null>(null)
  const [filterLabel, setFilterLabel] = useState('')
  const [sortBy, setSortBy] = useState<'name' | 'year' | null>(null)

  const fetchByFilter = useCallback(async (filter: ActiveFilter | null) => {
    setLoading(true)
    try {
      let data: { status: boolean; items: Movie[] }
      if (!filter) {
        data = await getNewMovies(1)
        setFilterLabel('Phim mới nhất')
      } else if (filter.type === 'category') {
        data = await getMoviesByCategory(filter.value, { limit: 40 })
        setFilterLabel(`Thể loại: ${filter.label}`)
      } else if (filter.type === 'country') {
        data = await getMoviesByCountry(filter.value, { limit: 40 })
        setFilterLabel(`Quốc gia: ${filter.label}`)
      } else {
        data = await getMoviesByYear(filter.value, { limit: 40 })
        setFilterLabel(`Năm: ${filter.label}`)
      }
      setResults(data.items)
      setInitialLoading(false)
    } catch {
      setResults([])
      setInitialLoading(false)
    } finally {
      setLoading(false)
    }
  }, [])

  const sorted = sortBy
    ? [...results].sort((a, b) => {
        if (sortBy === 'name') return a.name.localeCompare(b.name)
        return (b.year || 0) - (a.year || 0)
      })
    : results

  useEffect(() => {
    Promise.all([
      getCategories().then((res) => {
        if (res.status === 'success') setCategories(res.data.items)
      }).catch(() => {}),
      getCountries().then((res) => {
        if (res.status === 'success') setCountries(res.data.items)
      }).catch(() => {}),
      getYears().then((res) => {
        if (res.status === 'success') setYears(res.data.items)
      }).catch(() => {}),
    ])
  }, [])

  const searchTimeoutRef = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)
  const activeFilterRef = useRef<ActiveFilter | null>(null)

  useEffect(() => {
    if (!query.trim()) {
      if (!activeFilter) {
        const t = setTimeout(() => fetchByFilter(null))
        return () => clearTimeout(t)
      }
      return
    }
    setTimeout(() => setOpenDropdown(null))
    searchTimeoutRef.current = setTimeout(async () => {
      const q = query.trim()
      if (!q) return
      setLoading(true)
      try {
        const data = await searchMovies(q)
        setResults(data.items)
        setFilterLabel(`Kết quả cho "${q}"`)
        setInitialLoading(false)
      } catch {
        setResults([])
        setInitialLoading(false)
      } finally {
        setLoading(false)
      }
    }, 400)
    return () => clearTimeout(searchTimeoutRef.current)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [query])

  useEffect(() => {
    activeFilterRef.current = activeFilter
  }, [activeFilter])

  useEffect(() => {
    if (!activeFilterRef.current || query.trim()) return
    const t = setTimeout(() => {
      setOpenDropdown(null)
      fetchByFilter(activeFilterRef.current)
    })
    return () => clearTimeout(t)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeFilter])

  const selectFilter = (type: FilterType, label: string, value: string) => {
    setOpenDropdown(null)
    setQuery('')
    setActiveFilter({ type, label, value })
  }

  const clearFilter = () => {
    setActiveFilter(null)
    setFilterLabel('')
    fetchByFilter(null)
  }

  const isLoading = loading || initialLoading

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      {/* Search bar */}
      <div className="glass-tile rounded-2xl px-5 py-3.5 flex items-center gap-3 mb-5">
        <svg className="w-5 h-5 shrink-0 text-text-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Tìm kiếm phim..."
          className="flex-1 bg-transparent text-text-primary outline-none placeholder:text-text-muted text-sm"
          autoFocus
        />
        {query && (
          <button
            onClick={() => setQuery('')}
            className="text-text-muted hover:text-white transition-colors"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" />
            </svg>
          </button>
        )}
      </div>

      {/* Filter chips */}
      <div className="flex items-center gap-2 mb-6">
        {filterConfig.map(({ key, label }) => (
          <div key={key} className="relative">
            <button
              onClick={() => setOpenDropdown(openDropdown === key ? null : key)}
              className={`px-4 py-2 rounded-xl text-xs font-medium transition-all duration-200 ${
                activeFilter?.type === key
                  ? 'glass-tile-active text-white'
                  : 'glass-tile text-text-secondary'
              }`}
            >
              <span className="flex items-center gap-1">
                {activeFilter?.type === key ? activeFilter.label : label}
                <svg className={`w-3 h-3 transition-transform duration-200 ${openDropdown === key ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7 10l5 5 5-5z" />
                </svg>
              </span>
            </button>
            {openDropdown === key && (
              <div className="absolute top-full left-0 mt-1 z-20 w-52 max-h-60 overflow-y-auto rounded-xl glass-tile py-1 shadow-2xl">
                {(key === 'category' ? categories : key === 'country' ? countries : years).length === 0 ? (
                  <div className="p-4 text-sm text-text-muted text-center">Đang tải...</div>
                ) : (
                  (key === 'category' ? categories : key === 'country' ? countries : years).map((item: { name: string; slug: string }) => (
                    <button
                      key={item.slug}
                      onClick={() => selectFilter(key, item.name, item.slug)}
                      className="w-full text-left px-4 py-2 text-sm text-text-secondary hover:text-white hover:bg-white/5 transition-colors"
                    >
                      {item.name}
                    </button>
                  ))
                )}
              </div>
            )}
          </div>
        ))}

        {activeFilter && (
          <button
            onClick={clearFilter}
            className="px-3 py-2 rounded-xl text-[11px] font-medium text-text-muted hover:text-white glass-tile"
          >
            ✕ Xoá
          </button>
        )}

        {results.length > 0 && !loading && (
          <div className="flex items-center gap-1.5 ml-auto">
            <span className="text-[10px] text-text-muted mr-1">Sắp xếp:</span>
            {(['name', 'year'] as const).map((s) => (
              <button
                key={s}
                onClick={() => setSortBy(sortBy === s ? null : s)}
                className={`px-2.5 py-1 rounded-lg text-[10px] font-medium transition-all ${
                  sortBy === s
                    ? 'bg-white/12 text-white'
                    : 'text-text-muted hover:text-white'
                }`}
              >
                {s === 'name' ? 'Tên' : 'Năm'}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Results */}
      {filterLabel && !isLoading && sorted.length > 0 && (
        <p className="text-xs text-text-muted mb-4">{filterLabel}</p>
      )}

      {isLoading ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {Array.from({ length: 10 }).map((_, i) => (
            <div key={i}>
              <div className="aspect-[2/3] rounded-xl shimmer" />
              <div className="mt-2.5 h-3 shimmer rounded w-3/4" />
              <div className="mt-1.5 h-2.5 shimmer rounded w-1/2" />
            </div>
          ))}
        </div>
      ) : sorted.length === 0 ? (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <div className="w-14 h-14 rounded-full bg-white/5 flex items-center justify-center mb-4">
            <svg className="w-7 h-7 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
              <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
            </svg>
          </div>
          <p className="text-text-secondary text-sm">
            {query.trim() ? 'Không tìm thấy kết quả' : 'Chọn thể loại hoặc tìm kiếm phim'}
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {sorted.map((movie) => (
            <MovieCard key={movie._id} movie={movie} />
          ))}
        </div>
      )}
    </div>
  )
}
