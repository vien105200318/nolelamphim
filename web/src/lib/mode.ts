export type Mode = 'normal' | 'tu-tien'

export interface ModeInfo {
  id: Mode
  label: string
  apiBase?: string
}

export const MODES: ModeInfo[] = [
  { id: 'normal', label: 'Normal' },
  { id: 'tu-tien', label: 'Tu Tiên' },
]

export const DEFAULT_MODE: Mode = 'normal'

const STORAGE_KEY = 'phim:mode'

export function readMode(): Mode {
  const id = localStorage.getItem(STORAGE_KEY)
  return MODES.some((m) => m.id === id) ? (id as Mode) : DEFAULT_MODE
}

export function writeMode(mode: Mode) {
  localStorage.setItem(STORAGE_KEY, mode)
  document.documentElement.dataset.mode = mode
}
