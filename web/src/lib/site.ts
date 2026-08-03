export const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL?.replace(/\/$/, "") ||
  "https://nolelamphim.vercel.app"

export const SITE_NAME = "Nô Lệ Làm Phim"

export const CONTACT_EMAIL =
  process.env.NEXT_PUBLIC_CONTACT_EMAIL || "contact@nolelamphim.vercel.app"
