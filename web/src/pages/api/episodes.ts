import type { APIRoute } from 'astro'
import { getMovieEpisodes } from '../../lib/api'

export const GET: APIRoute = async ({ url }) => {
  const slug = url.searchParams.get('slug') || ''
  if (!slug) {
    return new Response(JSON.stringify({ status: false, episodes: [] }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    })
  }
  const result = await getMovieEpisodes(slug)
  return new Response(JSON.stringify(result), {
    headers: { 'Content-Type': 'application/json' },
  })
}
