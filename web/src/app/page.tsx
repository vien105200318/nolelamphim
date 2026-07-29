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
      <main className="max-w-7xl mx-auto px-4 py-6">
        <h1 className="text-2xl font-bold mb-6">Nô Lệ Làm Phim</h1>

        {subteam.items.length > 0 && (
          <section className="mb-8">
            <h2 className="text-lg font-semibold mb-3">Subteam</h2>
            <div className="flex gap-3 overflow-x-auto pb-2">
              {subteam.items.slice(0, 10).map((movie) => (
                <div key={movie._id} className="min-w-[140px] w-[140px]">
                  <MovieCard movie={movie} />
                </div>
              ))}
            </div>
          </section>
        )}

        <section>
          <h2 className="text-lg font-semibold mb-3">Phim mới cập nhật</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {newMovies.items.map((movie) => (
              <MovieCard key={movie._id} movie={movie} />
            ))}
          </div>
        </section>
      </main>
    );
  } catch {
    return (
      <main className="max-w-7xl mx-auto px-4 py-6">
        <h1 className="text-2xl font-bold mb-6">Nô Lệ Làm Phim</h1>
        <p className="text-gray-400">Không thể tải dữ liệu. Vui lòng thử lại sau.</p>
      </main>
    );
  }
}
