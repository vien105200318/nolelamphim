import { pageList } from '../lib/pagination'

export interface PageButtonAttrs {
  page: number
  total: number
  activeClass?: string
  inactiveClass?: string
  baseClass?: string
}

export function pageButtonsHTML(attrs: PageButtonAttrs): string {
  const { page, total, activeClass = 'pagination-active', inactiveClass = 'glass-tile text-text-secondary hover:text-white', baseClass = 'w-9 h-9 rounded-xl text-sm font-medium transition-all duration-200' } = attrs
  return pageList(page, total)
    .map((p) =>
      p === '...'
        ? `<span class="px-2 text-text-muted text-xs select-none">…</span>`
        : `<button type="button" class="${baseClass} ${p === page ? activeClass : inactiveClass}" data-page="${p}" aria-label="Trang ${p}" ${p === page ? 'aria-current="page"' : ''}>${p}</button>`,
    )
    .join('')
}

const NAV_CLASS = 'w-9 h-9 rounded-xl glass-tile text-text-secondary hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors'

export function arrowButtonsHTML(page: number, total: number, prefix: string): string {
  return `
    <button type="button" class="${NAV_CLASS}" data-nav="first" aria-label="Trang đầu" ${page <= 1 ? 'disabled' : ''}>«</button>
    <button type="button" class="${NAV_CLASS}" data-nav="prev" aria-label="Trang trước" ${page <= 1 ? 'disabled' : ''}>‹</button>
    <span class="flex flex-wrap items-center justify-center gap-1.5">
      ${pageButtonsHTML({ page, total, baseClass: `${prefix} w-9 h-9 rounded-xl text-sm font-medium transition-all duration-200` })}
    </span>
    <button type="button" class="${NAV_CLASS}" data-nav="next" aria-label="Trang sau" ${page >= total ? 'disabled' : ''}>›</button>
    <button type="button" class="${NAV_CLASS}" data-nav="last" aria-label="Trang cuối" ${page >= total ? 'disabled' : ''}>»</button>
  `
}
