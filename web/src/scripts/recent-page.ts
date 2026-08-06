import { getRecent } from './store'
import type { RecentItem } from './store'
import { escapeHTML } from './cards'
import { imgUrl } from '../lib/img'
import { registerPageInit } from './lifecycle'

registerPageInit(() => {
  const root = document.getElementById('recent-root')
  if (!root) return () => {}
  const items: RecentItem[] = getRecent()

  if (items.length === 0) {
    root.innerHTML = `
      <div class="content-card px-8 py-16 flex flex-col items-center">
        <div class="w-14 h-14 rounded-full bg-white/5 flex items-center justify-center mb-4">
          <svg class="w-7 h-7 text-text-muted" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
          </svg>
        </div>
        <p class="text-text-secondary text-sm mb-4">Chưa có lịch sử xem</p>
        <a href="/" class="px-5 py-2 rounded-xl glass-tile text-text-secondary text-xs">Khám phá phim</a>
      </div>
    `
  } else {
    const rows = items
      .map((item) => {
        const epSlug =
          escapeHTML(item.episodeSlug) ||
          (item.episode ? `tap-${escapeHTML(item.episode.replace('Tập ', ''))}` : 'tap-1')
        const name = escapeHTML(item.name)
        const thumb = escapeHTML(imgUrl(item.thumb, 300))
        const episode = escapeHTML(item.episode)
        const date = new Date(item.watchedAt).toLocaleDateString('vi-VN')
        return `
          <a href="/xem/${escapeHTML(item.slug)}/${epSlug}" class="flex items-center gap-4 px-4 py-3 rounded-xl glass-tile hover:text-white transition-all">
            <div class="w-14 h-20 rounded-lg overflow-hidden bg-bg-card shrink-0 relative glass-frame">
              ${item.thumb ? `<img src="${thumb}" alt="" loading="lazy" class="w-full h-full object-cover" />` : '<div class="w-full h-full bg-bg-card"></div>'}
            </div>
            <div class="min-w-0">
              <p class="text-sm font-medium text-text-primary truncate">${name}</p>
              ${item.episode ? `<p class="text-xs text-text-muted mt-0.5">${episode}</p>` : ''}
              <p class="text-[10px] text-text-muted mt-1">${date}</p>
            </div>
          </a>
        `
      })
      .join('')
    root.innerHTML = `<div class="space-y-2">${rows}</div>`
  }
})
