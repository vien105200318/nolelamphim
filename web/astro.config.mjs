// @ts-check
import { defineConfig } from 'astro/config'
import vercel from '@astrojs/vercel/serverless'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  output: 'server',
  adapter: vercel({}),
  site: 'https://nolelamphim.vercel.app',
  prefetch: true,
  vite: {
    plugins: [/** @type {any} */ (tailwindcss())],
  },
})
