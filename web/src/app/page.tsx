import { getNewMovies, getSubteam } from "@/lib/api";
import MovieCard from "@/components/MovieCard";
import MovieGrid from "@/components/MovieGrid";
import HeroCarousel from "@/components/HeroCarousel";
import CategorySection from "@/components/CategorySection";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function Home() {
  const [newMovies, subteam] = await Promise.all([
    getNewMovies().catch(() => ({ items: [] })),
    getSubteam().catch(() => ({ items: [] })),
  ]);

  if (newMovies.items.length === 0) {
    return (
      <div className="max-w-6xl mx-auto px-4 py-20 flex flex-col items-center justify-center">
        <div className="bg-bg-card rounded-2xl px-8 py-12 flex flex-col items-center">
          <div className="w-12 h-12 rounded-full bg-white/5 flex items-center justify-center mb-4">
            <svg className="w-6 h-6 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
          </div>
          <p className="text-text-secondary text-sm mb-4">Không thể tải dữ liệu</p>
          <Link href="/" className="px-5 py-2 rounded-xl bg-white/10 text-white text-sm font-medium hover:bg-white/20 transition-colors">
            Thử lại
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4">
      {/* Hero carousel */}
      <section className="mt-6">
        <HeroCarousel movies={newMovies.items.slice(0, 8)} />
      </section>

      {/* Subteam */}
      {subteam.items.length > 0 && (
        <section className="mt-10">
          <h2 className="text-sm font-semibold text-text-primary mb-4">
            Subteam
          </h2>
          <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-none snap-x snap-mandatory">
            {subteam.items.slice(0, 10).map((movie) => (
              <div key={movie._id} className="snap-start shrink-0 w-[150px]">
                <MovieCard movie={movie} dot="hot" />
              </div>
            ))}
          </div>
        </section>
      )}

      <CategorySection slug="hanh-dong" name="Hành Động" />
      <CategorySection slug="lang-man" name="Lãng Mạn" />
      <CategorySection slug="kinh-di" name="Kinh Dị" />
      <CategorySection slug="hoat-hinh" name="Hoạt Hình" />
      <CategorySection slug="hai" name="Hài" />
      <CategorySection slug="co-trang" name="Cổ Trang" />

      {/* New movies */}
      <section className="mt-10">
        <h2 className="text-sm font-semibold text-text-primary mb-4">
          Phim mới cập nhật
        </h2>
        <MovieGrid initialItems={newMovies.items} path="/danh-sach/phim-moi-cap-nhat" />
      </section>
    </div>
  );
}
