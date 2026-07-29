import { getMoviesByCategory } from '@/lib/api'
import type { Category } from '@/lib/types'
import MovieCard from './MovieCard'

export default async function SimilarMovies({
  categories,
  excludeSlug,
}: {
  categories: Category[]
  excludeSlug: string
}) {
  if (categories.length === 0) return null

  const data = await getMoviesByCategory(categories[0].slug, {
    limit: 10,
  }).catch(() => ({ status: false, items: [] }))

  const items = data.items?.filter((m) => m.slug !== excludeSlug).slice(0, 6)

  if (!items?.length) return null

  return (
    <section>
      <h3 className="text-sm font-semibold text-text-primary mb-3">
        Phim tương tự
      </h3>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
        {items.map((movie) => (
          <MovieCard key={movie._id} movie={movie} />
        ))}
      </div>
    </section>
  )
}
