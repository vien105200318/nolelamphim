import Link from "next/link";

export default function DownloadPage() {
  return (
    <div className="max-w-6xl mx-auto px-6 py-20 flex flex-col items-center justify-center">
      <div className="w-20 h-20 rounded-2xl bg-gradient-to-br from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] flex items-center justify-center text-white text-3xl font-bold shadow-2xl shadow-[#C44BED]/30 mb-8">
        N
      </div>
      <h1 className="text-2xl font-bold text-text-primary mb-3">
        Tải ứng dụng
      </h1>
      <p className="text-text-secondary text-sm mb-8">
        Ứng dụng đang được phát triển. Sẽ sớm ra mắt!
      </p>
      <div className="flex items-center gap-3 px-6 py-3 rounded-2xl glass-tile text-text-muted text-xs">
        <span className="w-2 h-2 rounded-full bg-[#4A9EFF] animate-pulse" />
        Coming soon
      </div>
      <Link
        href="/"
        className="mt-8 px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white"
      >
        ← Quay lại trang chủ
      </Link>
    </div>
  )
}
