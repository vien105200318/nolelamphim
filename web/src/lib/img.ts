export const IMG_PROXY_PATH = '/img/'

export function imgUrl(src: string | undefined | null, w: number): string {
  if (!src) return ''
  if (src.startsWith(IMG_PROXY_PATH)) return src
  return `${IMG_PROXY_PATH}?src=${encodeURIComponent(src)}&w=${Math.max(1, Math.round(w))}`
}
