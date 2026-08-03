'use client'

import { useCallback, useState } from 'react'
import { SITE_URL } from '@/lib/site'

export default function ShareButton({ slug, name }: { slug: string; name: string }) {
  const [copied, setCopied] = useState(false)
  const [open, setOpen] = useState(false)

  const url = `${SITE_URL}/phim/${slug}`

  const copy = useCallback(async () => {
    try {
      await navigator.clipboard.writeText(url)
    } catch {
      const el = document.createElement('textarea')
      el.value = url
      document.body.appendChild(el)
      el.select()
      document.execCommand('copy')
      document.body.removeChild(el)
    }
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }, [url])

  const nativeShare = useCallback(async () => {
    if (navigator.share) {
      try {
        await navigator.share({ title: name, url })
        return
      } catch {
        // fall through to popover
      }
    }
    setOpen((v) => !v)
  }, [name, url])

  return (
    <div className="relative">
      <button
        onClick={nativeShare}
        aria-label="Chia sẻ"
        title="Chia sẻ phim"
        className="w-9 h-9 rounded-full glass-tile flex items-center justify-center text-text-secondary hover:text-white hover:bg-white/15 transition-colors"
      >
        <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.395-2.86 3 3 0 00-5.395 2.86zm0 0l6.632 3.316m0 0a3 3 0 105.395 2.86 3 3 0 00-5.395-2.86z" />
        </svg>
      </button>

      {open && (
        <div className="absolute right-0 top-12 z-50 w-48 rounded-xl glass-tile p-2 flex flex-col gap-1 animate-[fade-in-up_0.25s_cubic-bezier(0.22,1,0.36,1)]">
          <button
            onClick={copy}
            className="flex items-center gap-2 px-3 py-2 rounded-lg text-xs text-text-secondary hover:bg-white/10 hover:text-white transition-colors"
          >
            <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" d="M13.828 10.172a4 4 0 010 5.656l-4 4a4 4 0 01-5.656-5.656l1.586-1.586M10.172 13.828a4 4 0 010-5.656l4-4a4 4 0 015.656 5.656l-1.586 1.586" />
            </svg>
            {copied ? 'Đã copy!' : 'Copy liên kết'}
          </button>
          <a
            href={`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-2 px-3 py-2 rounded-lg text-xs text-text-secondary hover:bg-white/10 hover:text-white transition-colors"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
            </svg>
            Chia sẻ Facebook
          </a>
        </div>
      )}
    </div>
  )
}
