import { getMoviesByCategory } from '@/lib/api'
import Link from 'next/link'
import MovieCard from './MovieCard'

export default async function CategorySection({
  slug,
  name,
}: {
  slug: string
  name: string
}) {
  const data = await getMoviesByCategory(slug, { limit: 12 }).catch(() => ({
    status: false,
    items: [],
  }))

  if (!data.status || data.items.length === 0) return null

  return (
    <section className="mt-10">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-sm font-semibold text-text-primary">{name}</h2>
        <Link
          href={`/the-loai/${slug}`}
          className="text-[11px] text-text-muted hover:text-white transition-colors"
        >
          Xem thêm →
        </Link>
      </div>
      <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none snap-x snap-mandatory">
        {data.items.map((movie) => (
          <div key={movie._id} className="snap-start shrink-0 w-[170px]">
            <MovieCard movie={movie} />
          </div>
        ))}
      </div>
    </section>
  )
}
