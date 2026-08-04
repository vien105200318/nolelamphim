import MovieFilters from "@/components/MovieFilters";
import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getMoviesByListPath } from "@/lib/api";

export const dynamic = "force-dynamic";

const LISTS: Record<string, { title: string; desc: string }> = {
  "phim-bo": { title: "Phim Bộ", desc: "Xem các bộ phim truyền hình dài tập mới nhất, hay nhất với chất lượng HD VietSub miễn phí." },
  "phim-le": { title: "Phim Lẻ", desc: "Xem các bộ phim điện ảnh mới nhất, hay nhất với chất lượng HD VietSub miễn phí." },
};

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const meta = LISTS[slug];
  if (!meta) return { title: "Không tìm thấy" };
  return {
    title: meta.title,
    description: meta.desc,
    openGraph: { title: meta.title, description: meta.desc },
  };
}

export default async function DanhSachPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const meta = LISTS[slug];
  if (!meta) notFound();

  const data = await getMoviesByListPath(slug, 1, 24).catch(() => ({
    status: false,
    items: [],
  }));

  return (
    <div className="max-w-6xl mx-auto px-6 py-6">
      <div className="flex items-center gap-2 text-xs text-text-muted mb-4">
        <Link href="/" className="hover:text-white transition-colors">Trang chủ</Link>
        <span>/</span>
        <span className="text-white">{meta.title}</span>
      </div>

      <h1 className="text-lg font-semibold text-text-primary mb-5">{meta.title}</h1>

      {data.items?.length > 0 ? (
        <MovieFilters
          initialItems={data.items}
          path={`/danh-sach/${slug}`}
          options={{ status: true, year: true, country: true }}
        />
      ) : (
        <div className="content-card px-8 py-16 flex flex-col items-center">
          <p className="text-text-secondary text-sm">Không có phim nào</p>
        </div>
      )}
    </div>
  );
}
