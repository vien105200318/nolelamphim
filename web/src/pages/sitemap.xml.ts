import type { APIRoute } from 'astro'
import { SITE_URL } from '../lib/site'
import { getCategories, getCountries, getYears, getNewMovies } from '../lib/api'

export const GET: APIRoute = async () => {
  const [categories, countries, years, newMovies] = await Promise.all([
    getCategories().catch(() => ({ data: { items: [] } })),
    getCountries().catch(() => ({ data: { items: [] } })),
    getYears().catch(() => ({ data: { items: [] } })),
    getNewMovies().catch(() => ({ items: [] })),
  ])

  type SitemapEntry = {
    url: string
    changeFrequency: string
    priority: number
    lastModified?: Date
  }

  const staticRoutes: SitemapEntry[] = [
    { url: SITE_URL, lastModified: new Date(), changeFrequency: 'daily', priority: 1 },
    { url: `${SITE_URL}/the-loai`, changeFrequency: 'weekly', priority: 0.7 },
    { url: `${SITE_URL}/search`, changeFrequency: 'yearly', priority: 0.4 },
    { url: `${SITE_URL}/recent`, changeFrequency: 'daily', priority: 0.6 },
    { url: `${SITE_URL}/favorites`, changeFrequency: 'yearly', priority: 0.3 },
    { url: `${SITE_URL}/download`, changeFrequency: 'monthly', priority: 0.5 },
    { url: `${SITE_URL}/danh-sach/phim-bo`, changeFrequency: 'weekly', priority: 0.7 },
    { url: `${SITE_URL}/danh-sach/phim-le`, changeFrequency: 'weekly', priority: 0.7 },
  ]

  const categoryRoutes: SitemapEntry[] = (categories.data?.items ?? []).map((c) => ({
    url: `${SITE_URL}/the-loai/${c.slug}`,
    changeFrequency: 'weekly',
    priority: 0.6,
  }))

  const countryRoutes: SitemapEntry[] = (countries.data?.items ?? []).map((c) => ({
    url: `${SITE_URL}/quoc-gia/${c.slug}`,
    changeFrequency: 'weekly',
    priority: 0.6,
  }))

  const yearRoutes: SitemapEntry[] = (years.data?.items ?? []).map((y) => ({
    url: `${SITE_URL}/nam/${y.slug}`,
    changeFrequency: 'monthly',
    priority: 0.5,
  }))

  const movieRoutes: SitemapEntry[] = (newMovies.items ?? []).map((m) => ({
    url: `${SITE_URL}/phim/${m.slug}`,
    lastModified: new Date(),
    changeFrequency: 'weekly',
    priority: 0.8,
  }))

  const all = [
    ...staticRoutes,
    ...categoryRoutes,
    ...countryRoutes,
    ...yearRoutes,
    ...movieRoutes,
  ]

  const body = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${all
  .map(
    (r) => `  <url>
    <loc>${r.url}</loc>
    <lastmod>${r.lastModified instanceof Date ? r.lastModified.toISOString() : ''}</lastmod>
    <changefreq>${r.changeFrequency}</changefreq>
    <priority>${r.priority}</priority>
  </url>`,
  )
  .join('\n')}
</urlset>`

  return new Response(body, {
    headers: {
      'Content-Type': 'application/xml; charset=utf-8',
      'Cache-Control': 'public, max-age=86400',
    },
  })
}
