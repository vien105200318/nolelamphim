import MovieGrid from "@/components/MovieGrid";
import Link from "next/link";
import { getMoviesByCountry } from "@/lib/api";

export const dynamic = "force-dynamic";

export default async function CountryMoviesPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const name = slug.charAt(0).toUpperCase() + slug.slice(1);

  const data = await getMoviesByCountry(slug, { page: 1, limit: 24 }).catch(
    () => ({ status: false, items: [] }),
  );

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <div className="flex items-center gap-2 text-xs text-text-muted mb-4">
        <Link href="/" className="hover:text-white transition-colors">Trang chủ</Link>
        <span>/</span>
        <Link href="/search" className="hover:text-white transition-colors">Danh mục</Link>
        <span>/</span>
        <span className="text-white">{name}</span>
      </div>

      <h1 className="text-lg font-semibold text-text-primary mb-5">{name}</h1>

      {data.items?.length > 0 ? (
        <MovieGrid initialItems={data.items} path={`/quoc-gia/${slug}`} />
      ) : (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <p className="text-text-secondary text-sm">Không có phim nào</p>
        </div>
      )}
    </div>
  );
}
