import Link from "next/link";
import type { Movie } from "@/lib/types";

export default function MovieCard({ movie }: { movie: Movie }) {
  return (
    <Link href={`/phim/${movie.slug}`} className="group block">
      <div className="aspect-[2/3] rounded-lg overflow-hidden bg-[#252525]">
        {movie.thumb_url ? (
          <img
            src={movie.thumb_url}
            alt={movie.name}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform"
            loading="lazy"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-[#808080]">
            <svg className="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18 3v2h-2V3H8v2H6V3H4v18h2v-2h2v2h8v-2h2v2h2V3h-2zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm10 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z" />
            </svg>
          </div>
        )}
      </div>
      <h3 className="mt-2 text-sm font-medium text-white line-clamp-2">
        {movie.name}
      </h3>
      {movie.year && (
        <p className="text-xs text-[#808080]">{movie.year}</p>
      )}
    </Link>
  );
}
