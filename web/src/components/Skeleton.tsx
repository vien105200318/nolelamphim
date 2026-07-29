export function MovieCardSkeleton() {
  return (
    <div>
      <div className="aspect-[2/3] rounded-xl shimmer" />
      <div className="mt-2.5 h-3 shimmer rounded w-3/4" />
      <div className="mt-1.5 h-2.5 shimmer rounded w-1/2" />
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
