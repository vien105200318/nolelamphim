import { getNewMovies, getSubteam } from "@/lib/api";
import MovieCard from "@/components/MovieCard";

export const dynamic = "force-dynamic";

export default async function Home() {
  try {
    const [newMovies, subteam] = await Promise.all([
      getNewMovies(),
      getSubteam(),
    ]);

    return (
      <main className="max-w-7xl mx-auto px-4 py-4">
        <header className="py-4 mb-2">
          <h1 className="text-xl font-bold text-text-primary">
            Nô Lệ Làm Phim
          </h1>
        </header>

        {subteam.items.length > 0 && (
          <section className="mb-10">
            <h2 className="text-lg font-bold text-text-primary mb-4 border-l-4 border-primary pl-3">
              Subteam
            </h2>
            <div className="flex gap-3 overflow-x-auto pb-3 -mx-4 px-4 snap-x snap-mandatory scrollbar-none">
              {subteam.items.slice(0, 10).map((movie) => (
                <div key={movie._id} className="min-w-[140px] w-[140px] snap-start">
                  <MovieCard movie={movie} />
                </div>
              ))}
            </div>
          </section>
        )}

        <section>
          <h2 className="text-lg font-bold text-text-primary mb-4 border-l-4 border-primary pl-3">
            Phim mới cập nhật
          </h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-3 md:gap-4">
            {newMovies.items.map((movie) => (
              <MovieCard key={movie._id} movie={movie} />
            ))}
          </div>
        </section>

        <footer className="mt-12 py-6 border-t border-bg-surface text-center text-text-muted text-xs">
          Nô Lệ Làm Phim &copy; {new Date().getFullYear()}
        </footer>
      </main>
    );
  } catch {
    return (
      <main className="max-w-7xl mx-auto px-4 py-6">
        <header className="py-4 mb-2">
          <h1 className="text-xl font-bold text-text-primary">
            Nô Lệ Làm Phim
          </h1>
        </header>
        <div className="flex flex-col items-center justify-center py-20">
          <svg className="w-12 h-12 text-text-muted mb-4" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
          <p className="text-text-secondary">Không thể tải dữ liệu. Vui lòng thử lại sau.</p>
        </div>
      </main>
    );
  }
}
