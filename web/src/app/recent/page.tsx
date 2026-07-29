'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import type { RecentItem } from '@/lib/hooks/useRecent'

export default function RecentPage() {
  const [items, setItems] = useState<RecentItem[]>([])

  useEffect(() => {
    const stored = localStorage.getItem('recent')
    if (stored) setItems(JSON.parse(stored))
  }, [])

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <h1 className="text-lg font-semibold text-text-primary mb-6">Xem gần đây</h1>

      {items.length === 0 ? (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <div className="w-14 h-14 rounded-full bg-white/5 flex items-center justify-center mb-4">
            <svg className="w-7 h-7 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
            </svg>
          </div>
          <p className="text-text-secondary text-sm mb-4">Chưa có lịch sử xem</p>
          <Link href="/" className="px-5 py-2 rounded-xl glass-tile text-text-secondary text-xs">
            Khám phá phim
          </Link>
        </div>
      ) : (
        <div className="space-y-2">
          {items.map((item) => (
            <Link
              key={`${item.slug}-${item.watchedAt}`}
              href={`/xem/${item.slug}/${item.episode ? `tap-${item.episode.replace('Tập ', '')}` : 'tap-1'}`}
              className="flex items-center gap-4 px-4 py-3 rounded-xl glass-tile hover:text-white transition-all"
            >
              <div className="w-14 h-20 rounded-lg overflow-hidden bg-bg-card shrink-0">
                {item.thumb ? (
                  <img src={item.thumb} alt="" className="w-full h-full object-cover" />
                ) : (
                  <div className="w-full h-full bg-bg-card" />
                )}
              </div>
              <div className="min-w-0">
                <p className="text-sm font-medium text-text-primary truncate">{item.name}</p>
                {item.episode && (
                  <p className="text-xs text-text-muted mt-0.5">{item.episode}</p>
                )}
                <p className="text-[10px] text-text-muted mt-1">
                  {new Date(item.watchedAt).toLocaleDateString('vi-VN')}
                </p>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
