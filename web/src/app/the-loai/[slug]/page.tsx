import MovieFilters from "@/components/MovieFilters";
import Link from "next/link";
import type { Metadata } from "next";
import { getMoviesByCategory, getCategories } from "@/lib/api";

export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const cats = await getCategories().catch(() => null);
  const cat = cats?.data?.items?.find((c) => c.slug === slug);
  const title = cat ? `Phim ${cat.name}` : `Phim ${slug}`;
  return {
    title,
    description: `Xem các bộ phim ${cat?.name ?? slug} mới nhất, hay nhất với chất lượng HD VietSub miễn phí tại Nô Lệ Làm Phim.`,
    openGraph: { title },
  };
}

export default async function CategoryMoviesPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const name = slug.charAt(0).toUpperCase() + slug.slice(1);

  const data = await getMoviesByCategory(slug, { page: 1, limit: 24 }).catch(
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
        <MovieFilters
          initialItems={data.items}
          path={`/the-loai/${slug}`}
          options={{ type: true, status: true, year: true, country: true }}
        />
      ) : (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <p className="text-text-secondary text-sm">Không có phim nào</p>
        </div>
      )}
    </div>
  );
}
