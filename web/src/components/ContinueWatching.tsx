'use client'

import Link from 'next/link'
import Image from 'next/image'
import { useRecent } from '@/lib/hooks/useRecent'

export default function ContinueWatching() {
  const { recent, remove } = useRecent()

  const watched = recent.filter((r) => r.episodeSlug)

  if (watched.length === 0) return null

  return (
    <section className="mt-10">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-sm font-semibold text-text-primary">Tiếp tục xem</h2>
        <span className="text-[11px] text-text-muted">{watched.length} phim</span>
      </div>
      <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none snap-x snap-mandatory">
        {watched.slice(0, 10).map((item) => (
          <div key={item.slug} className="snap-start shrink-0 w-[150px] relative group">
            <Link
              href={`/xem/${item.slug}/${item.episodeSlug}`}
              className="block relative aspect-[2/3] rounded-xl overflow-hidden bg-bg-card"
            >
              {item.thumb ? (
                <Image
                  src={item.thumb}
                  alt={item.name}
                  fill
                  sizes="150px"
                  className="object-cover transition-transform duration-500 group-hover:scale-105"
                />
              ) : (
                <div className="w-full h-full bg-bg-card" />
              )}
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
              <span className="absolute top-2 left-2 px-2 py-0.5 rounded-full bg-[#FF6B9D] text-white text-[10px] font-semibold">
                {item.episode}
              </span>
              <span className="absolute inset-x-0 bottom-0 px-2.5 py-2 flex items-center gap-1.5 text-white text-[11px] font-medium">
                <svg className="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M8 5v14l11-7z" />
                </svg>
                Tiếp tục
              </span>
            </Link>
            <button
              onClick={() => remove(item.slug)}
              aria-label="Xoá khỏi lịch sử xem"
              className="absolute -top-1.5 -right-1.5 z-10 w-5 h-5 rounded-full bg-black/60 border border-white/15 text-white/80 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity hover:bg-black/80"
            >
              <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" />
              </svg>
            </button>
          </div>
        ))}
      </div>
    </section>
  )
}
