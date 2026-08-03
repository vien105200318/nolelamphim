'use client'

import { useCallback, useState } from 'react'

const STORAGE_KEY = 'ratings'

function loadRatings(): Record<string, number> {
  if (typeof window === 'undefined') return {}
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}')
  } catch {
    return {}
  }
}

const STAR_PATH =
  'M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z'

export default function RatingBox({ slug }: { slug: string; name?: string }) {
  const [ratings, setRatings] = useState<Record<string, number>>(loadRatings)
  const [hover, setHover] = useState(0)

  const value = ratings[slug] ?? 0
  const display = hover || value

  const rate = useCallback(
    (n: number) => {
      setRatings((prev) => {
        const next = { ...prev, [slug]: n }
        localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
        return next
      })
    },
    [slug],
  )

  return (
    <div
      className="flex flex-col items-center gap-1 group/rating cursor-pointer"
      onMouseLeave={() => setHover(0)}
      title={value ? `Bạn đánh giá ${value}/5` : 'Đánh giá phim này'}
    >
      <div className="flex gap-0.5">
        {[1, 2, 3, 4, 5].map((n) => (
          <button
            key={n}
            type="button"
            aria-label={`${n} sao`}
            onClick={() => rate(n)}
            onMouseEnter={() => setHover(n)}
            className="p-0.5 transition-transform duration-150 hover:scale-110"
          >
            <svg
              className={`w-5 h-5 transition-colors duration-150 ${
                n <= display
                  ? 'text-amber-400 drop-shadow-[0_0_6px_rgba(251,191,36,0.5)]'
                  : 'text-white/20 group-hover/rating:text-white/35'
              }`}
              fill="currentColor"
              viewBox="0 0 24 24"
            >
              <path d={STAR_PATH} />
            </svg>
          </button>
        ))}
      </div>
      <span className="text-[10px] text-text-muted leading-none">
        {value ? `${value}/5` : 'Đánh giá'}
      </span>
    </div>
  )
}
