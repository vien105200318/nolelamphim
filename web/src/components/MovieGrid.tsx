'use client'

import { useState, useEffect, useRef } from 'react'
import MovieCard from './MovieCard'
import { normalizeMovieList } from '@/lib/api'
import type { Movie } from '@/lib/types'

const BASE_URL = 'https://vsmov.com/api'

export default function MovieGrid({
  initialItems,
  path,
}: {
  initialItems: Movie[]
  path: string
}) {
  const [page, setPage] = useState(1)
  const [items, setItems] = useState(initialItems)
  const [loading, setLoading] = useState(false)
  const loaded = useRef(false)

  useEffect(() => {
    if (!loaded.current) {
      loaded.current = true
      return
    }
    setLoading(true)
    fetch(`${BASE_URL}${path}?page=${page}`, {
      headers: { Accept: 'application/json' },
    })
      .then((r) => r.json())
      .then((data) => {
        if (data.status && data.items?.length > 0) {
          setItems(normalizeMovieList(data).items)
        }
      })
      .finally(() => setLoading(false))
  }, [page, path])

  const totalPages = 10
  const pages: (number | '...')[] = []
  for (let i = 1; i <= totalPages; i++) {
    if (i === 1 || i === totalPages || (i >= page - 1 && i <= page + 1)) {
      pages.push(i)
    } else if (pages[pages.length - 1] !== '...') {
      pages.push('...')
    }
  }

  return (
    <div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {items.map((movie) => (
          <MovieCard key={movie._id} movie={movie} dot="new" />
        ))}
      </div>

      <div className="flex items-center justify-center gap-1.5 mt-8">
        <button
          onClick={() => setPage((p) => Math.max(1, p - 1))}
          disabled={page <= 1}
          className="px-3 py-1.5 rounded-lg text-xs text-text-secondary hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
        >
          ◀
        </button>

        {pages.map((p, i) =>
          p === '...' ? (
            <span key={`dots-${i}`} className="px-2 text-text-muted text-xs">...</span>
          ) : (
            <button
              key={p}
              onClick={() => setPage(p)}
              className={`w-9 h-9 rounded-xl text-sm font-medium transition-all duration-200 ${
                p === page
                  ? 'bg-gradient-to-br from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] text-white shadow-lg shadow-[#C44BED]/25'
                  : 'glass-tile text-text-secondary hover:text-white'
              }`}
            >
              {p}
            </button>
          ),
        )}

        <button
          onClick={() => setPage((p) => p + 1)}
          disabled={items.length === 0}
          className="px-3 py-1.5 rounded-lg text-xs text-text-secondary hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
        >
          ▶
        </button>
      </div>

      {loading && (
        <div className="flex justify-center mt-4">
          <div className="w-5 h-5 rounded-full border-2 border-white/20 border-t-white/60 animate-spin" />
        </div>
      )}
    </div>
  )
}
