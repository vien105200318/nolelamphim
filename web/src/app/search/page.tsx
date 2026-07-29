'use client'

import { useState, useEffect, useRef } from 'react'
import { searchMovies, getCategories, getCountries, getYears } from '@/lib/api'
import type { Movie } from '@/lib/types'
import MovieCard from '@/components/MovieCard'

interface FilterItem {
  label: string
  value: string
}

export default function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<Movie[]>([])
  const [loading, setLoading] = useState(false)
  const [searched, setSearched] = useState(false)

  const [categories, setCategories] = useState<FilterItem[]>([])
  const [countries, setCountries] = useState<FilterItem[]>([])
  const [years, setYears] = useState<FilterItem[]>([])
  const [openDropdown, setOpenDropdown] = useState<string | null>(null)

  const debounceRef = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)

  useEffect(() => {
    getCategories().then((res) => {
      if (res.status === 'success') {
        setCategories(res.data.items.map((c) => ({ label: c.name, value: c.slug })))
      }
    }).catch(() => {})
    getCountries().then((res) => {
      if (res.status === 'success') {
        setCountries(res.data.items.map((c) => ({ label: c.name, value: c.slug })))
      }
    }).catch(() => {})
    getYears().then((res) => {
      if (res.status === 'success') {
        setYears(res.data.items.map((y) => ({ label: y.name, value: y.name })))
      }
    }).catch(() => {})
  }, [])

  useEffect(() => {
    debounceRef.current = setTimeout(async () => {
      const q = query.trim()
      if (!q) {
        setResults([])
        setSearched(false)
        return
      }
      setLoading(true)
      try {
        const data = await searchMovies(q)
        setResults(data.items)
      } catch {
        setResults([])
      } finally {
        setLoading(false)
        setSearched(true)
      }
    }, 400)
    return () => clearTimeout(debounceRef.current)
  }, [query])

  return (
    <main className="max-w-7xl mx-auto px-4 py-4">
      <header className="py-4 mb-2">
        <h1 className="text-xl font-bold text-text-primary">Tìm kiếm</h1>
      </header>

      <div className="relative mb-4">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Tìm kiếm phim..."
          className="w-full bg-bg-surface text-text-primary rounded-xl px-4 py-3 pl-11 outline-none placeholder:text-text-muted text-sm"
          autoFocus
        />
        <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-text-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        {query && (
          <button
            onClick={() => setQuery('')}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text-primary"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" />
            </svg>
          </button>
        )}
      </div>

      <div className="flex gap-2 mb-6 flex-wrap">
        <DropdownFilter
          label="Thể loại"
          open={openDropdown === 'category'}
          onToggle={() => setOpenDropdown(openDropdown === 'category' ? null : 'category')}
          items={categories}
        />
        <DropdownFilter
          label="Quốc gia"
          open={openDropdown === 'country'}
          onToggle={() => setOpenDropdown(openDropdown === 'country' ? null : 'country')}
          items={countries}
        />
        <DropdownFilter
          label="Năm"
          open={openDropdown === 'year'}
          onToggle={() => setOpenDropdown(openDropdown === 'year' ? null : 'year')}
          items={years}
        />
      </div>

      <section>
        {loading ? (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-3 md:gap-4">
            {Array.from({ length: 12 }).map((_, i) => (
              <div key={i} className="animate-pulse">
                <div className="aspect-[2/3] rounded-lg bg-bg-card" />
                <div className="mt-2 h-4 bg-bg-card rounded w-3/4" />
                <div className="mt-1 h-3 bg-bg-card rounded w-1/2" />
              </div>
            ))}
          </div>
        ) : !searched ? (
          <div className="flex flex-col items-center justify-center py-20 text-text-muted">
            <svg className="w-16 h-16 mb-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
            </svg>
            <p className="text-text-secondary">Nhập tên phim để tìm kiếm</p>
          </div>
        ) : results.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-20 text-text-muted">
            <svg className="w-12 h-12 mb-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H5.17L4 17.17V4h16v12z" />
            </svg>
            <p className="text-text-secondary">Không tìm thấy kết quả</p>
          </div>
        ) : (
          <>
            <p className="text-sm text-text-muted mb-4">
              {results.length} kết quả cho &ldquo;{query}&rdquo;
            </p>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-3 md:gap-4">
              {results.map((movie) => (
                <MovieCard key={movie._id} movie={movie} />
              ))}
            </div>
          </>
        )}
      </section>
    </main>
  )
}

function DropdownFilter({
  label,
  open,
  onToggle,
  items,
}: {
  label: string
  open: boolean
  onToggle: () => void
  items: FilterItem[]
}) {
  return (
    <div className="relative">
      <button
        onClick={onToggle}
        className="flex items-center gap-1 px-4 py-2 rounded-full text-sm font-medium bg-bg-card text-text-secondary hover:bg-bg-surface transition-colors"
      >
        {label}
        <svg className={`w-4 h-4 transition-transform ${open ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 24 24">
          <path d="M7 10l5 5 5-5z" />
        </svg>
      </button>
      {open && (
        <>
          <div className="fixed inset-0 z-10" onClick={onToggle} />
          <div className="absolute top-full left-0 mt-1 z-20 w-48 max-h-60 overflow-y-auto rounded-lg bg-bg-surface border border-bg-card shadow-xl">
            {items.length === 0 ? (
              <div className="p-3 text-sm text-text-muted">Đang tải...</div>
            ) : (
              items.map((item) => (
                <button
                  key={item.value}
                  onClick={() => {
                    onToggle()
                  }}
                  className="w-full text-left px-4 py-2.5 text-sm text-text-primary hover:bg-bg-card transition-colors"
                >
                  {item.label}
                </button>
              ))
            )}
          </div>
        </>
      )}
    </div>
  )
}
