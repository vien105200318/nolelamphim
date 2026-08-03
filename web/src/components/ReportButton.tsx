'use client'

import { useState } from 'react'
import { CONTACT_EMAIL } from '@/lib/site'

const ISSUES = [
  { id: 'broken', label: 'Không xem được / lỗi phát' },
  { id: 'wrong-episode', label: 'Sai tập / sai phim' },
  { id: 'subtitle', label: 'Lỗi phụ đề' },
  { id: 'image', label: 'Sai poster / ảnh' },
  { id: 'other', label: 'Khác' },
]

export default function ReportButton({
  slug,
  name,
  episode,
}: {
  slug: string
  name: string
  episode?: string
}) {
  const [open, setOpen] = useState(false)
  const [issue, setIssue] = useState(ISSUES[0].id)
  const [note, setNote] = useState('')

  const submit = () => {
    const subject = `[Báo lỗi] ${name}${episode ? ` - ${episode}` : ''}`
    const body =
      `Phim: ${name}\n` +
      `Liên kết: ${window.location.origin}/phim/${slug}\n` +
      (episode ? `Tập: ${episode}\n` : '') +
      `Vấn đề: ${ISSUES.find((i) => i.id === issue)?.label}\n` +
      (note ? `Ghi chú: ${note}\n` : '')
    window.location.href = `mailto:${CONTACT_EMAIL}?subject=${encodeURIComponent(
      subject,
    )}&body=${encodeURIComponent(body)}`
    setOpen(false)
    setNote('')
  }

  return (
    <div className="relative">
      <button
        onClick={() => setOpen((v) => !v)}
        aria-label="Báo lỗi phim"
        title="Báo lỗi phim"
        className="px-4 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white flex items-center gap-1.5"
      >
        <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        Báo lỗi
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"
          onClick={() => setOpen(false)}
        >
          <div
            className="w-full max-w-sm rounded-2xl glass-tile p-5 animate-[fade-in-up_0.25s_cubic-bezier(0.22,1,0.36,1)]"
            onClick={(e) => e.stopPropagation()}
          >
            <h3 className="text-sm font-semibold text-text-primary mb-4">Báo lỗi phim</h3>
            <div className="flex flex-col gap-1.5 mb-4">
              {ISSUES.map((i) => (
                <button
                  key={i.id}
                  onClick={() => setIssue(i.id)}
                  className={`w-full text-left px-3.5 py-2.5 rounded-xl text-xs transition-all ${
                    issue === i.id
                      ? 'bg-gradient-to-r from-[#FF6B9D]/15 to-[#4A9EFF]/15 text-white border border-[#C44BED]/30'
                      : 'bg-white/5 text-text-secondary hover:bg-white/10'
                  }`}
                >
                  {i.label}
                </button>
              ))}
            </div>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="Ghi chú thêm (không bắt buộc)..."
              rows={3}
              className="w-full px-3.5 py-2.5 rounded-xl bg-white/5 text-text-primary text-xs outline-none resize-none focus:ring-1 focus:ring-[#C44BED]/40 placeholder:text-text-muted"
            />
            <div className="flex gap-2 mt-4">
              <button
                onClick={() => setOpen(false)}
                className="flex-1 px-4 py-2.5 rounded-xl bg-white/5 text-text-secondary text-xs hover:bg-white/10 transition-colors"
              >
                Huỷ
              </button>
              <button
                onClick={submit}
                className="flex-1 px-4 py-2.5 rounded-xl bg-gradient-to-r from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] text-white text-xs font-medium shadow-lg shadow-[#C44BED]/25 hover:opacity-90 transition-opacity"
              >
                Gửi báo lỗi
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
