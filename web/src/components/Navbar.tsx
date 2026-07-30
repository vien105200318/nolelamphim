'use client'

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

  return (
    <nav className="sticky top-0 z-50 glass-pane">
      <div className="max-w-6xl mx-auto px-6 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-3 shrink-0 group">
          <Image
            src="/logo.png"
            alt="Nô Lệ Làm Phim"
            width={36}
            height={36}
            className="rounded-xl transition-all duration-300 group-hover:scale-110 group-hover:shadow-xl group-hover:shadow-[#C44BED]/20"
          />
          <span className="font-semibold text-base text-text-primary transition-all duration-300 group-hover:text-transparent group-hover:bg-clip-text group-hover:bg-gradient-to-r group-hover:from-[#FF6B9D] group-hover:via-[#C44BED] group-hover:to-[#4A9EFF]">
            Nô Lệ Làm Phim
          </span>
        </Link>

        <div className="flex items-center gap-1">
          {links.map((link) => {
            const active = pathname === link.href || (link.href !== '/' && pathname.startsWith(link.href))
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`group relative px-4 py-2 rounded-xl text-sm font-medium transition-all duration-300 ease-out ${
                  active
                    ? 'text-white'
                    : 'text-text-secondary hover:text-white'
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
    </nav>
  )
}
