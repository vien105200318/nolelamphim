import type { MetadataRoute } from "next"
import { SITE_URL } from "@/lib/site"
import { getCategories, getCountries, getYears, getNewMovies } from "@/lib/api"

export const revalidate = 86400

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const [categories, countries, years, newMovies] = await Promise.all([
    getCategories().catch(() => ({ data: { items: [] } })),
    getCountries().catch(() => ({ data: { items: [] } })),
    getYears().catch(() => ({ data: { items: [] } })),
    getNewMovies().catch(() => ({ items: [] })),
  ])

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: SITE_URL, lastModified: new Date(), changeFrequency: "daily", priority: 1 },
    { url: `${SITE_URL}/the-loai`, changeFrequency: "weekly", priority: 0.7 },
    { url: `${SITE_URL}/search`, changeFrequency: "yearly", priority: 0.4 },
    { url: `${SITE_URL}/recent`, changeFrequency: "daily", priority: 0.6 },
    { url: `${SITE_URL}/favorites`, changeFrequency: "yearly", priority: 0.3 },
    { url: `${SITE_URL}/download`, changeFrequency: "monthly", priority: 0.5 },
  ]

  const categoryRoutes: MetadataRoute.Sitemap = (categories.data?.items ?? []).map((c) => ({
    url: `${SITE_URL}/the-loai/${c.slug}`,
    changeFrequency: "weekly",
    priority: 0.6,
  }))

  const countryRoutes: MetadataRoute.Sitemap = (countries.data?.items ?? []).map((c) => ({
    url: `${SITE_URL}/quoc-gia/${c.slug}`,
    changeFrequency: "weekly",
    priority: 0.6,
  }))

  const yearRoutes: MetadataRoute.Sitemap = (years.data?.items ?? []).map((y) => ({
    url: `${SITE_URL}/nam/${y.slug}`,
    changeFrequency: "monthly",
    priority: 0.5,
  }))

  const movieRoutes: MetadataRoute.Sitemap = (newMovies.items ?? []).map((m) => ({
    url: `${SITE_URL}/phim/${m.slug}`,
    lastModified: new Date(),
    changeFrequency: "weekly",
    priority: 0.8,
  }))

  return [
    ...staticRoutes,
    ...categoryRoutes,
    ...countryRoutes,
    ...yearRoutes,
    ...movieRoutes,
  ]
}
