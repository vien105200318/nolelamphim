export interface CardMovie {
  _id?: number
  slug: string
  name: string
  year?: number
  thumb_url?: string
}

export function movieCardHTML(movie: CardMovie, dot?: 'new' | 'hot'): string {
  const badge = dot
    ? `<span class="absolute top-3 left-3 z-20 px-2 py-0.5 rounded-full text-[10px] font-semibold tracking-wide uppercase ${
        dot === 'new'
          ? 'bg-[#4A9EFF] text-white shadow-[0_0_10px_rgba(74,158,255,0.4)]'
          : 'bg-gradient-to-r from-[#FF6B9D] to-[#C44BED] text-white shadow-[0_0_10px_rgba(196,75,237,0.4)]'
      }">${dot === 'new' ? 'Mới' : 'Hot'}</span>`
    : ''
  return `
    <a href="/phim/${movie.slug}" class="group block focus:outline-none">
      <div class="relative aspect-[2/3] rounded-xl overflow-hidden bg-bg-card glass-frame poster-shell${movie.thumb_url ? ' shimmer' : ''} transition-all duration-500 ease-out group-hover:-translate-y-1 group-hover:shadow-[0_18px_40px_-12px_rgba(196,75,237,0.3)] group-hover:ring-1 group-hover:ring-[#C44BED]/35">
        ${
          movie.thumb_url
            ? `<img src="${movie.thumb_url}" alt="${movie.name}" loading="lazy" decoding="async" class="absolute inset-0 w-full h-full object-cover transition-transform duration-700 ease-out group-hover:scale-105" />`
            : `<div class="w-full h-full flex items-center justify-center text-text-muted"><svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24"><path d="M18 3v2h-2V3H8v2H6V3H4v18h2v-2h2v2h8v-2h2v2h2V3h-2zM8 17H6v-2h2v2zm0-4H6v-2h2v2zm0-4H6V7h2v2zm10 8h-2v-2h2v2zm0-4h-2v-2h2v2zm0-4h-2V7h2v2z"/></svg></div>`
        }
        <div class="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-1000 ease-out bg-gradient-to-r from-transparent via-white/10 to-transparent pointer-events-none"></div>
        ${badge}
        <div class="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
      </div>
      <div class="mt-2.5 px-0.5">
        <h3 class="text-[15px] font-medium text-text-primary leading-snug line-clamp-2 transition-colors duration-300 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-[#FF6B9D] group-hover:to-[#4A9EFF]">${movie.name}</h3>
        ${movie.year ? `<p class="text-xs text-text-muted mt-1 transition-colors duration-300 group-hover:text-text-secondary">${movie.year}</p>` : ''}
      </div>
    </a>
  `
}

export function gridHTML(items: CardMovie[], dot?: 'new' | 'hot'): string {
  return items.map((m) => movieCardHTML(m, dot)).join('')
}
