import type { APIRoute } from 'astro'
import { getMoviesByPath } from '../../lib/api'

export const GET: APIRoute = async () => {
  try {
    const [pageA, pageB] = await Promise.all([
      getMoviesByPath('/danh-sach/phim-moi-cap-nhat', { page: 1, limit: 60 }),
      getMoviesByPath('/danh-sach/phim-moi-cap-nhat', { page: 2, limit: 60 }),
    ])

    const all = [...(pageA.items ?? []), ...(pageB.items ?? [])].filter(
      (m) => m.slug && m.slug.trim(),
    )
    if (all.length === 0) {
      return new Response(null, { status: 404 })
    }

    const pick = all[Math.floor(Math.random() * all.length)]
    const target = pick.slug
      ? `/phim/${encodeURIComponent(pick.slug)}`
      : '/'

    return new Response(null, {
      status: 307,
      headers: {
        Location: target,
        'Cache-Control': 'no-store',
      },
    })
  } catch {
    return new Response(null, { status: 302, headers: { Location: '/' } })
  }
}
