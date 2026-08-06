import { readMode, writeMode } from '../lib/mode'
import type { Mode } from '../lib/mode'
import { MODE_TOAST_MS } from '../lib/constants'

const nav = document.getElementById('navbar')
const toggle = document.getElementById('nav-toggle')
const mobile = document.getElementById('nav-mobile')
const pill = document.getElementById('nav-pill')
const linksContainer = document.getElementById('nav-links')
const line1 = document.getElementById('nav-line-1')
const line2 = document.getElementById('nav-line-2')
const line3 = document.getElementById('nav-line-3')

let menuOpen = false

function updatePill() {
  if (!pill || !linksContainer) return
  const active = linksContainer.querySelector('.nav-link.text-white') as HTMLElement | null
  if (!active) {
    pill.classList.add('opacity-0')
    return
  }
  const elRect = active.getBoundingClientRect()
  const parentRect = linksContainer.getBoundingClientRect()
  pill.style.left = `${elRect.left - parentRect.left}px`
  pill.style.width = `${elRect.width}px`
  pill.classList.remove('opacity-0')
}

function onScroll() {
  if (!nav) return
  nav.classList.toggle('scrolled', window.scrollY > 8)
}

function onPointerMove(e: PointerEvent) {
  const bar = document.getElementById('nav-bar')
  if (!bar) return
  const rect = bar.getBoundingClientRect()
  bar.style.setProperty('--lx', `${e.clientX - rect.left}px`)
  bar.style.setProperty('--ly', `${e.clientY - rect.top}px`)
}

function setMenu(open: boolean) {
  menuOpen = open
  if (!mobile || !toggle) return
  mobile.classList.toggle('open', open)
  toggle.setAttribute('aria-expanded', String(open))
  if (line1) line1.style.transform = open ? 'rotate(45deg) translateY(6px)' : ''
  if (line2) line2.style.opacity = open ? '0' : ''
  if (line3) line3.style.transform = open ? 'rotate(-45deg) translateY(-6px)' : ''
}

toggle?.addEventListener('click', () => setMenu(!menuOpen))
mobile?.addEventListener('click', (e) => {
  if ((e.target as HTMLElement).closest('a')) setMenu(false)
})

/* ---------------- Mode switcher ---------------- */

let currentMode: Mode = readMode()
if (currentMode === 'tu-tien') {
  currentMode = 'normal'
  writeMode('normal')
}

let toastTimer: number | undefined
function showToast(message: string) {
  let toast = document.getElementById('mode-toast') as HTMLElement | null
  if (!toast) {
    toast = document.createElement('div')
    toast.id = 'mode-toast'
    toast.className =
      'fixed bottom-6 left-1/2 -translate-x-1/2 z-[100] pointer-events-none opacity-0 translate-y-2 transition-all duration-300'
    const inner = document.createElement('div')
    inner.className =
      'liquid-glass rounded-full px-5 py-2.5 text-sm font-semibold text-white whitespace-nowrap'
    toast.appendChild(inner)
    document.body.appendChild(toast)
  }
  ;(toast.firstElementChild as HTMLElement).textContent = message
  requestAnimationFrame(() => {
    toast.classList.remove('opacity-0', 'translate-y-2')
  })
  clearTimeout(toastTimer)
  toastTimer = window.setTimeout(() => {
    toast.classList.add('opacity-0', 'translate-y-2')
  }, MODE_TOAST_MS)
}

function renderMode() {
  document.querySelectorAll('[data-mode-option]').forEach((el) => {
    const opt = el as HTMLElement
    const active = opt.dataset.mode === currentMode
    opt.classList.toggle('text-white', active)
    opt.classList.toggle('bg-white/10', active)
    opt.setAttribute('aria-selected', String(active))
    const check = opt.querySelector('[data-check]') as HTMLElement | null
    if (check) check.style.opacity = active ? '1' : '0'
  })
  document.querySelectorAll('[data-mode-dot]').forEach((el) => {
    const dot = el as HTMLElement
    dot.style.background =
      currentMode === 'tu-tien'
        ? 'linear-gradient(135deg, #C44BED, #FFB03C)'
        : '#4A9EFF'
    dot.style.boxShadow = '0 0 0 2px rgba(0,0,0,0.25)'
  })
}

function closeAllModeMenus() {
  document.querySelectorAll('.mode-switch').forEach((sw) => {
    const btn = sw.querySelector('[data-mode-toggle]')
    btn?.setAttribute('aria-expanded', 'false')
    const menu = sw.querySelector('[data-mode-menu]')
    menu?.classList.add('opacity-0', 'translate-y-1', 'pointer-events-none')
    const chev = sw.querySelector('[data-mode-chevron]')
    if (chev) (chev as HTMLElement).style.transform = ''
  })
}

document.querySelectorAll('.mode-switch').forEach((sw) => {
  const btn = sw.querySelector('[data-mode-toggle]')
  const menu = sw.querySelector('[data-mode-menu]')
  let open = false

  const setOpen = (o: boolean) => {
    open = o
    if (!menu || !btn) return
    menu.classList.toggle('opacity-0', !o)
    menu.classList.toggle('translate-y-1', !o)
    menu.classList.toggle('pointer-events-none', !o)
    btn.setAttribute('aria-expanded', String(o))
    const chev = sw.querySelector('[data-mode-chevron]')
    if (chev) (chev as HTMLElement).style.transform = o ? 'rotate(180deg)' : ''
  }

  btn?.addEventListener('click', (e) => {
    e.stopPropagation()
    closeAllModeMenus()
    setOpen(!open)
  })
})

document.querySelectorAll('[data-mode-option]').forEach((opt) => {
  opt.addEventListener('click', () => {
    const mode = (opt as HTMLElement).dataset.mode as Mode | undefined
    if (mode) {
      currentMode = mode
      writeMode(mode)
      renderMode()
      if (mode === 'tu-tien') {
        showToast('Mode Tu Tiên sắp ra mắt — Coming soon')
      }
    }
    closeAllModeMenus()
  })
})

document.addEventListener('click', closeAllModeMenus)
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeAllModeMenus()
})

writeMode(currentMode)
renderMode()

window.addEventListener('resize', updatePill)
window.addEventListener('scroll', onScroll, { passive: true })
document.getElementById('nav-bar')?.addEventListener('pointermove', onPointerMove)

updatePill()
onScroll()
setMenu(false)
