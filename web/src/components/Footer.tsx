import Link from "next/link";

export default function Footer() {
  return (
    <footer className="mt-16 glass-pane border-t-0">
      <div className="max-w-6xl mx-auto px-6 py-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div className="col-span-2 md:col-span-1">
            <Link href="/" className="flex items-center gap-3">
              <span className="w-8 h-8 rounded-xl bg-gradient-to-br from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] flex items-center justify-center text-white text-sm font-bold shadow-lg shadow-[#C44BED]/20">
                N
              </span>
              <span className="font-semibold text-sm text-text-primary">
                Nô Lệ Làm Phim
              </span>
            </Link>
            <p className="text-xs text-text-muted mt-3 leading-relaxed max-w-48">
              Xem phim đa nền tảng, cập nhật nhanh nhất.
            </p>
          </div>

          <div>
            <h4 className="text-xs font-semibold text-text-muted uppercase tracking-widest mb-4">
              Điều hướng
            </h4>
            <ul className="space-y-3">
              {[
                { href: '/', label: 'Trang chủ' },
                { href: '/search', label: 'Tìm kiếm' },
                { href: '/the-loai', label: 'Danh mục' },
              ].map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-xs text-text-secondary hover:text-white transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="text-xs font-semibold text-text-muted uppercase tracking-widest mb-4">
              Thể loại
            </h4>
            <ul className="space-y-3">
              {[
                { href: '/the-loai/hanh-dong', label: 'Hành động' },
                { href: '/the-loai/tinh-cam', label: 'Tình cảm' },
                { href: '/the-loai/hai-huoc', label: 'Hài hước' },
                { href: '/the-loai/vien-tuong', label: 'Viễn tưởng' },
              ].map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-xs text-text-secondary hover:text-white transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="text-xs font-semibold text-text-muted uppercase tracking-widest mb-4">
              Thông tin
            </h4>
            <ul className="space-y-3">
              <li>
                <span className="text-xs text-text-muted">
                  Dữ liệu từ vsmov.com
                </span>
              </li>
              <li>
                <span className="text-xs text-text-muted">
                  Phiên bản 1.0
                </span>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-10 pt-4 border-t border-white/5 text-center">
          <p className="text-xs text-text-muted">
            &copy; {new Date().getFullYear()} Nô Lệ Làm Phim
          </p>
        </div>
      </div>
    </footer>
  );
}
