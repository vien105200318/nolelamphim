import { getMovieDetail, getMovieEpisodes } from "@/lib/api";
import type { MovieDetailResponse } from "@/lib/types";
import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import SimilarMovies from "@/components/SimilarMovies";
import FavoriteButton from "@/components/FavoriteButton";
import EpisodeList from "@/components/EpisodeList";

export const dynamic = "force-dynamic";

export default async function MovieDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const [data, epRes] = await Promise.all([
    getMovieDetail(slug).catch(() => ({ status: false, movie: null } as MovieDetailResponse)),
    getMovieEpisodes(slug),
  ]);

  if (!data.status || !data.movie) {
    notFound();
  }

  const movie = data.movie;
  const episodes = epRes.status ? epRes.episodes : [];

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <div className="relative h-[35vh] md:h-[45vh] rounded-2xl overflow-hidden mb-6">
        {movie.poster_url || movie.thumb_url ? (
          <Image
            src={movie.poster_url || movie.thumb_url || ""}
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
        <div className="absolute inset-0 bg-gradient-to-t from-bg-dark via-bg-dark/30 to-transparent" />
      </div>

      <div className="space-y-5">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold text-text-primary">
              {movie.name}
            </h1>
            {movie.origin_name && (
              <p className="text-sm text-text-muted mt-1">{movie.origin_name}</p>
            )}
          </div>
          <FavoriteButton id={movie._id} name={movie.name} slug={slug} thumb={movie.thumb_url || ''} />
        </div>

        <div className="flex flex-wrap gap-2">
          {[movie.year, movie.quality, movie.lang, movie.time, movie.status].filter(Boolean).map((chip, i) => (
            <span key={i} className="px-3 py-1 rounded-lg bg-bg-card text-text-secondary text-xs">
              {chip}
            </span>
          ))}
          {movie.episode_current && (
            <span className="px-3 py-1 rounded-lg bg-gradient-to-r from-[#FF6B9D]/15 to-[#4A9EFF]/15 text-[#FF6B9D] text-xs font-medium">
              {movie.episode_current}
            </span>
          )}
        </div>

        {movie.content && (
          <div className="content-card px-5 py-4">
            <h3 className="text-sm font-semibold text-text-primary mb-2">Nội dung</h3>
            <p className="text-sm text-text-secondary leading-relaxed">{movie.content}</p>
          </div>
        )}

        {movie.actor && (
          <div>
            <h3 className="text-sm font-semibold text-text-primary mb-2">Diễn viên</h3>
            <p className="text-sm text-text-secondary leading-relaxed">
              {Array.isArray(movie.actor) ? movie.actor.join(", ") : movie.actor}
            </p>
          </div>
        )}

        {movie.director && (
          <div>
            <h3 className="text-sm font-semibold text-text-primary mb-2">Đạo diễn</h3>
            <p className="text-sm text-text-secondary leading-relaxed">
              {Array.isArray(movie.director) ? movie.director.join(", ") : movie.director}
            </p>
          </div>
        )}

        {movie.category && movie.category.length > 0 && (
          <div className="flex flex-wrap gap-2">
            {Array.isArray(movie.category) && movie.category.map((cat) => (
              <Link
                key={typeof cat === "string" ? cat : cat.slug}
                href={`/the-loai/${typeof cat === "string" ? cat : cat.slug}`}
                className="px-3 py-1.5 rounded-xl glass-tile text-text-muted text-xs"
              >
                {typeof cat === "string" ? cat : cat.name}
              </Link>
            ))}
          </div>
        )}

        {movie.keywords && (
          <div className="flex flex-wrap gap-1.5">
            {movie.keywords.split(", ").slice(0, 10).map((kw) => (
              <span key={kw} className="px-2.5 py-1 rounded-lg bg-bg-card text-text-muted text-[10px]">
                {kw}
              </span>
            ))}
          </div>
        )}

        {episodes.length > 0 && (
          <div>
            <h3 className="text-sm font-semibold text-text-primary mb-3">Tập phim</h3>
            <EpisodeList slug={slug} servers={episodes} />
          </div>
        )}

        <SimilarMovies
          categories={movie.category ?? []}
          excludeSlug={slug}
        />

        <Link
          href="/"
          className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs"
        >
          <svg className="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z" />
          </svg>
          Quay lại
        </Link>
      </div>
    </div>
  );
}
