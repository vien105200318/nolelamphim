import { getRecent, removeRecent } from './store'
import type { RecentItem } from './store'

const root = document.getElementById('cw-root')
if (root) {
  const watched = getRecent().filter((r) => r.episodeSlug)

  function itemHTML(item: RecentItem): string {
    return `
      <div class="snap-start shrink-0 w-[150px] relative group" data-slug="${item.slug}">
        <a href="/xem/${item.slug}/${item.episodeSlug}" class="block relative aspect-[2/3] rounded-xl overflow-hidden bg-bg-card glass-frame">
          ${item.thumb ? `<img src="${item.thumb}" alt="${item.name}" loading="lazy" decoding="async" class="absolute inset-0 w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />` : '<div class="w-full h-full bg-bg-card"></div>'}
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
          ${item.episode ? `<span class="absolute top-2 left-2 px-2 py-0.5 rounded-full bg-[#FF6B9D] text-white text-[10px] font-semibold">${item.episode}</span>` : ''}
          <span class="absolute inset-x-0 bottom-0 px-2.5 py-2 flex items-center gap-1.5 text-white text-[11px] font-medium">
            <svg class="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
            Tiếp tục
          </span>
        </a>
        <button class="cw-remove absolute -top-1.5 -right-1.5 z-10 w-5 h-5 rounded-full bg-black/60 border border-white/15 text-white/80 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity hover:bg-black/80" aria-label="Xoá khỏi lịch sử xem">
          <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
        </button>
      </div>
    `
  }

  if (watched.length > 0) {
    root.innerHTML = `
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-sm font-semibold text-text-primary">Tiếp tục xem</h2>
        <span class="text-[11px] text-text-muted">${watched.length} phim</span>
      </div>
      <div class="flex gap-3 overflow-x-auto pb-2 scrollbar-none snap-x snap-mandatory">
        ${watched.slice(0, 10).map(itemHTML).join('')}
      </div>
    `
    root.querySelectorAll<HTMLButtonElement>('.cw-remove').forEach((btn) => {
      btn.addEventListener('click', () => {
        const card = btn.closest<HTMLElement>('[data-slug]')
        if (!card) return
        removeRecent(card.dataset.slug || '')
        card.remove()
        const remaining = root.querySelectorAll('[data-slug]').length
        const count = root.querySelector('.text-text-muted')
        if (count) count.textContent = `${remaining} phim`
        if (remaining === 0) root.innerHTML = ''
      })
    })
  }
}
