import { getFavorites } from './store'
import { gridHTML } from './cards'
import { registerPageInit } from './lifecycle'

registerPageInit(() => {
  const root = document.getElementById('favorites-root')
  if (!root) return () => {}
  const items = getFavorites().map((f) => ({
    _id: f.id,
    slug: f.slug,
    name: f.name,
    thumb_url: f.thumb,
  }))

  if (items.length === 0) {
    root.innerHTML = `
      <div class="content-card px-8 py-16 flex flex-col items-center">
        <div class="w-14 h-14 rounded-full bg-white/5 flex items-center justify-center mb-4">
          <svg class="w-7 h-7 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
          </svg>
        </div>
        <p class="text-text-secondary text-sm mb-4">Chưa có phim yêu thích</p>
        <a href="/" class="px-5 py-2 rounded-xl glass-tile text-text-secondary text-xs">Khám phá phim</a>
      </div>
    `
  } else {
    root.innerHTML = `<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8 gap-2.5">${gridHTML(items)}</div>`
  }
})
