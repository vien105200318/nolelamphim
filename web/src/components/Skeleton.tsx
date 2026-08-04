export function MovieCardSkeleton() {
  return (
    <div>
      <div className="aspect-[2/3] rounded-xl shimmer" />
      <div className="mt-2.5 h-3 shimmer rounded w-3/4" />
      <div className="mt-1.5 h-2.5 shimmer rounded w-1/2" />
    </div>
  )
}

export function HeroSkeleton() {
  return (
    <div className="mt-6">
      <div className="aspect-[16/10] md:aspect-[21/9] rounded-2xl shimmer" />
    </div>
  )
}

export function SectionRowSkeleton({ title = true }: { title?: boolean }) {
  return (
    <div className="mt-10">
      {title && <div className="h-4 w-32 shimmer rounded mb-4" />}
      <div className="flex gap-3 overflow-hidden">
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="w-[170px] shrink-0">
            <MovieCardSkeleton />
          </div>
        ))}
      </div>
    </div>
  )
}

export function GridSkeleton() {
  return (
    <div className="mt-10">
      <div className="h-4 w-40 shimmer rounded mb-4" />
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3">
        {Array.from({ length: 10 }).map((_, i) => (
          <MovieCardSkeleton key={i} />
        ))}
      </div>
    </div>
  )
}

export function ThemeSectionSkeleton() {
  return (
    <div className="mt-10 py-8">
      <div className="flex items-center gap-2 px-4 md:px-8 mb-4">
        <div className="h-4 w-16 shimmer rounded" />
        <div className="h-3 w-28 shimmer rounded" />
      </div>
      <div className="flex gap-4 overflow-hidden px-4 md:px-8">
        {Array.from({ length: 7 }).map((_, i) => (
          <div key={i} className="w-[220px] sm:w-[260px] md:w-[300px] h-[130px] md:h-[150px] rounded-2xl shimmer shrink-0" />
        ))}
      </div>
    </div>
  )
}

export function DetailSkeleton() {
  return (
    <div className="max-w-6xl mx-auto px-6 py-6 space-y-5">
      <div className="h-[35vh] md:h-[45vh] rounded-2xl shimmer" />
      <div className="h-6 shimmer rounded w-1/3" />
      <div className="h-4 shimmer rounded w-1/4" />
      <div className="flex gap-2">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="h-6 w-16 rounded-lg shimmer" />
        ))}
      </div>
      <div className="h-20 rounded-xl shimmer" />
      <div className="h-10 shimmer rounded w-1/5" />
    </div>
  )
}
