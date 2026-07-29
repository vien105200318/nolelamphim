'use client'

import { useState } from 'react'
import Link from 'next/link'
import type { EpisodeServer } from '@/lib/types'

const PER_PAGE = 24

export default function EpisodeList({
  slug,
  servers,
}: {
  slug: string
  servers: EpisodeServer[]
}) {
  const [serverIdx, setServerIdx] = useState(0)
  const current = servers[serverIdx]
  const totalPages = Math.ceil((current?.list.length ?? 0) / PER_PAGE)
  const [page, setPage] = useState(1)

  if (!current) return null

  const start = (page - 1) * PER_PAGE
  const visible = current.list.slice(start, start + PER_PAGE)

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
      <div className="flex items-center gap-2 mb-3 flex-wrap">
        {servers.length > 1 &&
          servers.map((s, i) => (
            <button
              key={i}
              onClick={() => { setServerIdx(i); setPage(1) }}
              className={`px-3 py-1.5 rounded-xl text-xs font-medium transition-all ${
                i === serverIdx
                  ? 'glass-tile-active text-white'
                  : 'glass-tile text-text-secondary'
              }`}
            >
              {s.server_name.trim()}
            </button>
          ))}
        {totalPages > 1 && (
          <span className="text-[11px] text-text-muted ml-auto">
            {current.list.length} tập
          </span>
        )}
      </div>

      <div className="content-card px-5 py-4">
        <div className="flex flex-wrap gap-2">
          {visible.map((ep) => (
            <Link
              key={ep.slug}
              href={`/xem/${slug}/${ep.slug}`}
              className="w-14 h-14 rounded-xl glass-tile text-text-secondary text-xs flex items-center justify-center hover:text-white transition-all"
            >
              {ep.name}
            </Link>
          ))}
        </div>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-1.5 mt-3">
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
            disabled={page >= totalPages}
            className="px-3 py-1.5 rounded-lg text-xs text-text-secondary hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
          >
            ▶
          </button>
        </div>
      )}
    </div>
  )
}
