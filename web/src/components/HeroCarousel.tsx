'use client'

import { useRef, useState, useEffect } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import type { Movie } from '@/lib/types'

export default function HeroCarousel({ movies }: { movies: Movie[] }) {
  const scrollRef = useRef<HTMLDivElement>(null)
  const [active, setActive] = useState(0)

  useEffect(() => {
    const el = scrollRef.current
    if (!el) return
    const onScroll = () => {
      const idx = Math.round(el.scrollLeft / el.clientWidth)
      setActive(idx)
    }
    el.addEventListener('scroll', onScroll)
    return () => el.removeEventListener('scroll', onScroll)
  }, [])

  return (
    <div>
      <div
        ref={scrollRef}
        className="flex overflow-x-auto snap-x snap-mandatory scrollbar-none rounded-2xl"
      >
        {movies.map((movie) => (
          <Link
            key={movie._id}
            href={`/phim/${movie.slug}`}
            className="snap-start shrink-0 w-full relative h-[30vh] md:h-[40vh]"
          >
            {movie.poster_url || movie.thumb_url ? (
              <Image
                src={movie.poster_url || movie.thumb_url || ''}
                alt={movie.name}
                fill
                sizes="100vw"
                className="object-cover"
                priority
              />
            ) : (
              <div className="w-full h-full bg-bg-card flex items-center justify-center text-text-muted">
                No image
              </div>
            )}
            <div className="absolute inset-0 bg-gradient-to-t from-bg-dark via-bg-dark/10 to-transparent" />
            <div className="absolute bottom-5 left-5">
              <h2 className="text-white text-xl md:text-2xl font-bold drop-shadow-lg">
                {movie.name}
              </h2>
              {movie.year && (
                <p className="text-text-secondary text-xs md:text-sm mt-1 drop-shadow">
                  {movie.year}
                </p>
              )}
            </div>
          </Link>
        ))}
      </div>
      <div className="flex justify-center gap-2 mt-3">
        {movies.map((_, i) => (
          <button
            key={i}
            onClick={() => {
              scrollRef.current?.children[i]?.scrollIntoView({ behavior: 'smooth', inline: 'start' })
            }}
            className={`w-1.5 h-1.5 rounded-full transition-all duration-300 ${
              i === active
                ? 'bg-white/70 w-4'
                : 'bg-white/20 hover:bg-white/40'
            }`}
          />
        ))}
      </div>
    </div>
  )
}
