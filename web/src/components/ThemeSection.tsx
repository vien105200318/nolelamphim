import Link from 'next/link'
import Image from 'next/image'
import {
  getMoviesByCategory,
  searchMovies,
  getNewMovies,
  getMoviesByListPath,
} from '@/lib/api'

interface ThemeConfig {
  label: string
  sub: string
  href: string
  gradient: string
  fetchThumb: () => Promise<string | undefined>
}

const THEMES: ThemeConfig[] = [
  {
    label: 'Chữa lành',
    sub: 'Tình yêu ngọt ngào',
    href: '/the-loai/tinh-yeu-ngot-ngao',
    gradient: 'from-[#FF6B9D]/80 via-[#C44BED]/40 to-transparent',
    fetchThumb: async () => {
      const d = await getMoviesByCategory('tinh-yeu-ngot-ngao', { limit: 1 }).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Marvel',
    sub: 'Vũ trụ siêu anh hùng',
    href: '/search?q=marvel',
    gradient: 'from-[#E62429]/85 via-[#151965]/60 to-transparent',
    fetchThumb: async () => {
      const d = await searchMovies('marvel', 1, 1).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Kho tàng',
    sub: 'Kho phim đồ sộ',
    href: '/search',
    gradient: 'from-[#FFB020]/75 via-[#C44BED]/40 to-transparent',
    fetchThumb: async () => {
      const d = await getNewMovies(1).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Anime mới',
    sub: 'Hoạt hình mới nhất',
    href: '/the-loai/hoat-hinh',
    gradient: 'from-[#4A9EFF]/85 via-[#C44BED]/50 to-transparent',
    fetchThumb: async () => {
      const d = await getMoviesByCategory('hoat-hinh', { limit: 1 }).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Top 10 phim bộ',
    sub: 'Phim bộ đỉnh cao',
    href: '/danh-sach/phim-bo',
    gradient: 'from-[#22D3EE]/70 via-[#4A9EFF]/40 to-transparent',
    fetchThumb: async () => {
      const d = await getMoviesByListPath('phim-bo', 1, 1).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Cổ trang',
    sub: 'Kiếm hiệp xưa',
    href: '/the-loai/co-trang',
    gradient: 'from-[#FF9A3C]/80 via-[#E62429]/35 to-transparent',
    fetchThumb: async () => {
      const d = await getMoviesByCategory('co-trang', { limit: 1 }).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
  {
    label: 'Phim điện ảnh',
    sub: 'Phim lẻ hấp dẫn',
    href: '/danh-sach/phim-le',
    gradient: 'from-[#7C3AED]/85 via-[#4A9EFF]/40 to-transparent',
    fetchThumb: async () => {
      const d = await getMoviesByListPath('phim-le', 1, 1).catch(() => null)
      return d?.items?.[0]?.thumb_url || d?.items?.[0]?.poster_url
    },
  },
]

export default async function ThemeSection() {
  const themes = await Promise.all(
    THEMES.map(async (t) => ({ ...t, image: await t.fetchThumb() })),
  )

  return (
    <section className="mt-10 bg-gradient-to-b from-[#C44BED]/10 via-transparent to-transparent py-8 overflow-hidden">
      <div className="flex items-center gap-2 px-4 md:px-8 mb-4">
        <h2 className="text-sm font-semibold text-text-primary">Chủ đề</h2>
        <span className="text-[11px] text-text-muted">Khám phá theo sở thích</span>
      </div>
      <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-none snap-x snap-mandatory px-4 md:px-8">
        {themes.map((theme) => (
          <Link
            key={theme.label}
            href={theme.href}
            className="group relative shrink-0 w-[220px] sm:w-[260px] md:w-[300px] h-[130px] md:h-[150px] rounded-2xl overflow-hidden snap-start"
          >
            {theme.image && (
              <Image
                src={theme.image}
                alt={theme.label}
                fill
                sizes="300px"
                className="object-cover opacity-55 group-hover:opacity-75 transition-all duration-500 group-hover:scale-105"
              />
            )}
            <div className={`absolute inset-0 bg-gradient-to-br ${theme.gradient} transition-opacity duration-300 group-hover:opacity-90`} />
            <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-black/20" />
            <span className="absolute top-3 right-3 w-7 h-7 rounded-full bg-white/15 backdrop-blur border border-white/20 flex items-center justify-center text-white opacity-0 group-hover:opacity-100 translate-x-1 group-hover:translate-x-0 transition-all duration-300">
              <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </span>
            <div className="absolute inset-x-0 bottom-0 p-4">
              <p className="text-white text-base md:text-lg font-bold drop-shadow">{theme.label}</p>
              <p className="text-white/70 text-[11px] mt-0.5 truncate">{theme.sub}</p>
            </div>
          </Link>
        ))}
      </div>
    </section>
  )
}
