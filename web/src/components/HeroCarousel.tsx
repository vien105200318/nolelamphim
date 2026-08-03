'use client'

import { useCallback, useEffect, useRef, useState } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import { motion, useScroll, useTransform } from 'motion/react'
import type { Movie } from '@/lib/types'

const AUTOPLAY_MS = 6000

export default function HeroCarousel({ movies }: { movies: Movie[] }) {
  const [active, setActive] = useState(0)
  const [paused, setPaused] = useState(false)
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const heroRef = useRef<HTMLDivElement>(null)

  const { scrollYProgress } = useScroll({
    target: heroRef,
    offset: ['start start', 'end start'],
  })
  const parallaxY = useTransform(scrollYProgress, [0, 1], [0, 60])

  const go = useCallback(
    (dir: 1 | -1) => {
      setActive((a) => (a + dir + movies.length) % movies.length)
    },
    [movies.length],
  )

  const next = useCallback(() => go(1), [go])

  useEffect(() => {
    if (paused || movies.length <= 1) return
    timerRef.current = setInterval(next, AUTOPLAY_MS)
    return () => {
      if (timerRef.current) clearInterval(timerRef.current)
    }
  }, [paused, next, movies.length])

  if (movies.length === 0) return null

  const current = movies[active]
  const counter = String(active + 1).padStart(2, '0')

  return (
    <div
      ref={heroRef}
      className="relative group/hero"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
    >
      <div className="relative overflow-hidden rounded-2xl aspect-[16/10] md:aspect-[21/9] bg-bg-card">
        {/* Subtle static gradient backdrop */}
        <div
          className="absolute inset-0 z-0"
          aria-hidden
          style={{
            background:
              'radial-gradient(60% 80% at 20% 20%, rgba(196,75,237,0.14) 0%, transparent 55%), radial-gradient(60% 80% at 80% 30%, rgba(74,158,255,0.12) 0%, transparent 55%)',
          }}
        />

        {/* Slides with parallax */}
        <motion.div style={{ y: parallaxY }} className="absolute inset-0">
          {movies.map((movie, i) => {
            const isActive = i === active
            const image = movie.poster_url || movie.thumb_url
            return (
              <Link
                key={movie._id}
                href={`/phim/${movie.slug}`}
                aria-hidden={!isActive}
                tabIndex={isActive ? 0 : -1}
                className={`absolute inset-0 block transition-opacity duration-1000 ease-out ${
                  isActive ? 'opacity-100 z-10' : 'opacity-0 z-0'
                }`}
              >
                {image ? (
                  <Image
                    src={image}
                    alt={movie.name}
                    fill
                    sizes="100vw"
                    priority={i === 0}
                    className={`object-cover ${isActive ? 'ken-burns' : ''}`}
                  />
                ) : (
                  <div className="w-full h-full bg-bg-card flex items-center justify-center text-text-muted">
                    No image
                  </div>
                )}
              </Link>
            )
          })}
        </motion.div>

        {/* Gradient overlay */}
        <div className="absolute inset-0 z-20 bg-gradient-to-t from-bg-dark via-bg-dark/25 to-transparent" />

        {/* Animated content */}
        <div key={active} className="absolute inset-0 z-30 flex items-end pointer-events-none">
          <div className="w-full pb-6 md:pb-10 px-5 md:px-10">
            <div className="hero-enter">
              <span className="inline-flex items-center px-3 py-1 rounded-full text-[10px] md:text-xs font-bold uppercase tracking-widest bg-gradient-to-r from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] text-white shadow-lg shadow-[#C44BED]/25">
                {current.year ? `Nổi bật · ${current.year}` : 'Nổi bật'}
              </span>
            </div>
            <h2 className="hero-enter hero-enter-delay-1 mt-3 text-white text-xl md:text-3xl lg:text-4xl font-bold drop-shadow-lg line-clamp-2 max-w-3xl">
              {current.name}
            </h2>
            {current.origin_name && (
              <p className="hero-enter hero-enter-delay-2 mt-1 text-text-secondary text-xs md:text-sm drop-shadow max-w-2xl truncate">
                {current.origin_name}
              </p>
            )}
            <p className="hero-enter hero-enter-delay-3 mt-4 inline-flex items-center gap-2 text-xs md:text-sm text-white/90 font-medium">
              <Link
                href={`/phim/${current.slug}`}
                onClick={(e) => e.stopPropagation()}
                className="pointer-events-auto inline-flex items-center gap-2 px-4 md:px-5 py-2 md:py-2.5 rounded-full bg-white/15 backdrop-blur border border-white/20 transition-all duration-300 hover:bg-white/25 hover:scale-105"
              >
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M8 5v14l11-7z" />
                </svg>
                Xem ngay
              </Link>
              {current.quality && (
                <span className="hidden sm:inline-flex px-3 py-1.5 rounded-full bg-white/10 backdrop-blur border border-white/15 text-text-secondary text-[11px] md:text-xs font-medium">
                  {current.quality}
                </span>
              )}
            </p>
          </div>
        </div>

        {/* Slide counter */}
        <div className="absolute top-5 right-5 md:top-6 md:right-8 z-40 hidden md:flex items-center gap-2 text-white/70">
          <span className="text-2xl font-bold text-white drop-shadow">{counter}</span>
          <span className="w-8 h-px bg-white/40" />
          <span className="text-sm">{String(movies.length).padStart(2, '0')}</span>
        </div>

        {/* Arrows */}
        <button
          onClick={() => go(-1)}
          aria-label="Trước"
          className="absolute left-3 top-1/2 -translate-y-1/2 z-40 w-9 h-9 md:w-11 md:h-11 rounded-full bg-black/30 backdrop-blur border border-white/10 text-white flex items-center justify-center opacity-0 group-hover/hero:opacity-100 transition-all duration-300 hover:bg-black/50 hover:scale-105"
        >
          <svg className="w-4 h-4 md:w-5 md:h-5" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
        </button>
        <button
          onClick={() => go(1)}
          aria-label="Tiếp"
          className="absolute right-3 top-1/2 -translate-y-1/2 z-40 w-9 h-9 md:w-11 md:h-11 rounded-full bg-black/30 backdrop-blur border border-white/10 text-white flex items-center justify-center opacity-0 group-hover/hero:opacity-100 transition-all duration-300 hover:bg-black/50 hover:scale-105"
        >
          <svg className="w-4 h-4 md:w-5 md:h-5" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>

      {/* Dots with autoplay progress */}
      <div className="flex justify-center gap-2.5 mt-4">
        {movies.map((_, i) => {
          const isActive = i === active
          return (
            <button
              key={i}
              onClick={() => setActive(i)}
              aria-label={`Slide ${i + 1}`}
              className={`relative h-1.5 rounded-full overflow-hidden transition-all duration-500 ${
                isActive ? 'w-10 bg-white/25' : 'w-4 bg-white/15 hover:bg-white/30'
              }`}
            >
              {isActive && (
                <span
                  key={paused ? 'paused' : active}
                  className={`absolute inset-y-0 left-0 rounded-full bg-gradient-to-r from-[#FF6B9D] to-[#4A9EFF] ${
                    paused ? 'w-full' : 'animate-[progress_6s_linear_forwards]'
                  }`}
                />
              )}
            </button>
          )
        })}
      </div>
    </div>
  )
}
