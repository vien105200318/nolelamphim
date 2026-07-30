'use client'

import { useState } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import type { FavoriteItem } from '@/lib/hooks/useFavorites'

export default function FavoritesPage() {
  const [items] = useState<FavoriteItem[]>(() => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('favorites')
      return stored ? JSON.parse(stored) : []
    }
    return []
  })

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <h1 className="text-lg font-semibold text-text-primary mb-6">Phim yêu thích</h1>

      {items.length === 0 ? (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <div className="w-14 h-14 rounded-full bg-white/5 flex items-center justify-center mb-4">
            <svg className="w-7 h-7 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
            </svg>
          </div>
          <p className="text-text-secondary text-sm mb-4">Chưa có phim yêu thích</p>
          <Link href="/" className="px-5 py-2 rounded-xl glass-tile text-text-secondary text-xs">
            Khám phá phim
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
          {items.map((item) => (
            <Link key={item.id} href={`/phim/${item.slug}`} className="group block">
              <div className="aspect-[2/3] rounded-xl overflow-hidden bg-bg-card relative">
                {item.thumb ? (
                  <Image
                    src={item.thumb}
                    alt={item.name}
                    fill
                    sizes="(max-width: 640px) 50vw, (max-width: 768px) 33vw, (max-width: 1024px) 25vw, 20vw"
                    className="object-cover transition duration-500 group-hover:scale-105"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-text-muted">
                    <svg className="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18 3v2h-2V3H8v2H6V3H4v18h2v-2h2v2h8v-2h2v2h2V3h-2zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm10 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z" />
                    </svg>
                  </div>
                )}
              </div>
              <h3 className="mt-2 text-sm font-medium text-text-primary leading-snug line-clamp-2 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-[#FF6B9D] group-hover:to-[#4A9EFF] transition-all duration-300">
                {item.name}
              </h3>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
