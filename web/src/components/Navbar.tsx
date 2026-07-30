'use client'

import { useState } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import { usePathname } from 'next/navigation'

const links = [
  { href: '/', label: 'Trang chủ' },
  { href: '/search', label: 'Tìm kiếm' },
  { href: '/favorites', label: 'Yêu thích' },
  { href: '/recent', label: 'Đã xem' },
  { href: '/download', label: 'Tải App' },
]

export default function Navbar() {
  const pathname = usePathname()
  const [menuOpen, setMenuOpen] = useState(false)

  return (
    <nav className="sticky top-0 z-50 glass-pane">
      <div className="max-w-6xl mx-auto px-4 md:px-6 h-14 md:h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2 md:gap-3 shrink-0 group">
          <Image
            src="/logo.png"
            alt="Nô Lệ Làm Phim"
            width={32}
            height={32}
            className="md:w-9 md:h-9 rounded-xl transition-all duration-300 group-hover:scale-110 group-hover:shadow-xl group-hover:shadow-[#C44BED]/20"
          />
          <span className="font-semibold text-sm md:text-base text-text-primary transition-all duration-300 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-[#FF6B9D] group-hover:via-[#C44BED] group-hover:to-[#4A9EFF]">
            Nô Lệ Làm Phim
          </span>
        </Link>

        <button
          onClick={() => setMenuOpen(!menuOpen)}
          className="md:hidden relative w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center"
          aria-label="Menu"
        >
          <div className="w-5 flex flex-col gap-1">
            <span className={`block h-0.5 bg-text-secondary rounded transition-all duration-300 ${menuOpen ? 'rotate-45 translate-y-1.5' : ''}`} />
            <span className={`block h-0.5 bg-text-secondary rounded transition-all duration-300 ${menuOpen ? 'opacity-0' : ''}`} />
            <span className={`block h-0.5 bg-text-secondary rounded transition-all duration-300 ${menuOpen ? '-rotate-45 -translate-y-1.5' : ''}`} />
          </div>
        </button>

        <div className="hidden md:flex items-center gap-1">
          {links.map((link) => {
            const active = pathname === link.href || (link.href !== '/' && pathname.startsWith(link.href))
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`group relative px-4 py-2 rounded-xl text-sm font-medium transition-all duration-300 ease-out ${
                  active ? 'text-white' : 'text-text-secondary hover:text-white'
                }`}
              >
                <span className="relative z-10">{link.label}</span>
                <span
                  className={`absolute inset-0 rounded-xl transition-all duration-300 ease-out ${
                    active
                      ? 'bg-white/10 shadow-[inset_0_1px_0_rgba(255,255,255,0.08)]'
                      : 'bg-white/0 group-hover:bg-white/6 group-hover:shadow-[inset_0_1px_0_rgba(255,255,255,0.04)]'
                  }`}
                />
              </Link>
            )
          })}
        </div>
      </div>

      {/* Mobile menu */}
      <div
        className={`md:hidden overflow-hidden transition-all duration-300 ease-out ${
          menuOpen ? 'max-h-80 opacity-100' : 'max-h-0 opacity-0'
        }`}
      >
        <div className="px-4 pb-4 pt-2 flex flex-col gap-1 border-t border-white/5">
          {links.map((link) => {
            const active = pathname === link.href || (link.href !== '/' && pathname.startsWith(link.href))
            return (
              <Link
                key={link.href}
                href={link.href}
                onClick={() => setMenuOpen(false)}
                className={`px-4 py-3 rounded-xl text-sm font-medium transition-all ${
                  active
                    ? 'text-white bg-white/10'
                    : 'text-text-secondary hover:text-white hover:bg-white/5'
                }`}
              >
                {link.label}
              </Link>
            )
          })}
        </div>
      </div>
    </nav>
  )
}
