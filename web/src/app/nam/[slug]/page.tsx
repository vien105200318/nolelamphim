import MovieFilters from "@/components/MovieFilters";
import Link from "next/link";
import type { Metadata } from "next";
import { getMoviesByYear } from "@/lib/api";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  return {
    title: `Phim năm ${slug}`,
    description: `Xem các bộ phim ra mắt năm ${slug}, hay nhất với chất lượng HD VietSub miễn phí tại Nô Lệ Làm Phim.`,
    openGraph: { title: `Phim năm ${slug}` },
  };
}

export default async function YearMoviesPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;

  const data = await getMoviesByYear(slug, { page: 1, limit: 24 }).catch(
    () => ({ status: false, items: [] }),
  );

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <div className="flex items-center gap-2 text-xs text-text-muted mb-4">
        <Link href="/" className="hover:text-white transition-colors">Trang chủ</Link>
        <span>/</span>
        <Link href="/search" className="hover:text-white transition-colors">Danh mục</Link>
        <span>/</span>
        <span className="text-white">{slug}</span>
      </div>

      <h1 className="text-lg font-semibold text-text-primary mb-5">Phim năm {slug}</h1>

      {data.items?.length > 0 ? (
        <MovieFilters
          initialItems={data.items}
          path={`/nam/${slug}`}
          options={{ type: true, status: true }}
        />
      ) : (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <p className="text-text-secondary text-sm">Không có phim nào</p>
        </div>
      )}
    </div>
  );
}
