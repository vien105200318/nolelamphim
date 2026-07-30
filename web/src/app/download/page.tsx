import Image from "next/image"
import Link from "next/link"

interface ReleaseAsset {
  name: string
  browser_download_url: string
}

interface Release {
  tag_name: string
  assets: ReleaseAsset[]
}

async function getLatestRelease(): Promise<Release | null> {
  try {
    const res = await fetch(
      "https://api.github.com/repos/vien105200318/nolelamphim/releases?per_page=1",
      { next: { revalidate: 3600 } }
    )
    if (!res.ok) return null
    const releases: Release[] = await res.json()
    return releases[0] ?? null
  } catch {
    return null
  }
}

export default async function DownloadPage() {
  const release = await getLatestRelease()

  const apkAsset = release?.assets.find((a) => a.name.endsWith(".apk") && !a.name.includes("tv"))
  const ipaAsset = release?.assets.find((a) => a.name.endsWith(".ipa"))
  const tvAsset = release?.assets.find((a) => a.name.endsWith("-androidtv.apk"))
  const webosAsset = release?.assets.find((a) => a.name.endsWith(".ipk") || a.name.includes("webos"))

  const platforms = [
    {
      id: "android",
      label: "Android",
      icon: (
        <svg viewBox="0 0 24 24" className="w-8 h-8" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
          <path d="M4 10v6" />
          <path d="M20 10v6" />
          <path d="M7 10h10v7a3 3 0 0 1-3 3h-4a3 3 0 0 1-3-3v-7Z" />
          <path d="M9 6.5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2" />
          <path d="M9 7v1" />
          <path d="M15 7v1" />
          <path d="M9 2 7 4" />
          <path d="M15 2l2 2" />
        </svg>
      ),
      url: apkAsset?.browser_download_url ?? null,
      filename: apkAsset?.name ?? null,
      note: apkAsset ? null : null,
    },
    {
      id: "ios",
      label: "iOS",
      icon: (
        <svg viewBox="0 0 24 24" className="w-8 h-8" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
          <rect x="4" y="2" width="16" height="20" rx="3" />
          <line x1="9" y1="6" x2="15" y2="6" />
          <line x1="12" y1="22" x2="12" y2="18" />
        </svg>
      ),
      url: ipaAsset?.browser_download_url ?? null,
      filename: ipaAsset?.name ?? null,
      note: ipaAsset ? "unsigned — cần sign trước khi cài" : null,
    },
    {
      id: "androidtv",
      label: "Android TV",
      icon: (
        <svg viewBox="0 0 24 24" className="w-8 h-8" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
          <rect x="2" y="4" width="20" height="14" rx="2" />
          <line x1="8" y1="20" x2="16" y2="20" />
          <line x1="12" y1="18" x2="12" y2="20" />
        </svg>
      ),
      url: tvAsset?.browser_download_url ?? null,
      filename: tvAsset?.name ?? null,
      note: null,
    },
    {
      id: "webos",
      label: "LG webOS",
      icon: (
        <svg viewBox="0 0 24 24" className="w-8 h-8" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
          <rect x="2" y="3" width="20" height="15" rx="3" />
          <rect x="6" y="6" width="12" height="9" rx="1" />
          <line x1="8" y1="21" x2="16" y2="21" />
          <line x1="12" y1="18" x2="12" y2="21" />
        </svg>
      ),
      url: webosAsset?.browser_download_url ?? null,
      filename: webosAsset?.name ?? null,
      note: webosAsset ? "Cài bằng webOS TV SDK (ares-install)" : null,
    },
  ]

  return (
    <div className="max-w-6xl mx-auto px-6 py-16">
      <div className="flex flex-col items-center text-center mb-14">
        <Image
          src="/logo.png"
          alt="Nô Lệ Làm Phim"
          width={80}
          height={80}
          className="rounded-2xl shadow-2xl shadow-[#C44BED]/30 mb-8"
        />
        <h1 className="text-3xl font-bold text-text-primary mb-3">
          Tải ứng dụng
        </h1>
        <p className="text-text-secondary text-sm max-w-md">
          Chọn nền tảng phù hợp để tải xuống. Hỗ trợ Android, iOS, Android TV và LG webOS.
        </p>
        {release && (
          <div className="mt-4 px-4 py-2 rounded-full glass-tile text-text-muted text-xs inline-flex items-center gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-green-400" />
            Phiên bản {release.tag_name.replace(/^v/i, "")}
          </div>
        )}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 max-w-5xl mx-auto">
        {platforms.map((p) => (
          <div
            key={p.id}
            className="glass-tile rounded-2xl p-7 flex flex-col items-center text-center"
          >
            <div className="w-14 h-14 rounded-xl bg-white/5 flex items-center justify-center text-[#C44BED] mb-5">
              {p.icon}
            </div>
            <h2 className="text-lg font-semibold text-text-primary mb-3">{p.label}</h2>

            {p.url ? (
              <>
                <a
                  href={p.url}
                  download
                  className="w-full py-3 rounded-xl bg-gradient-to-r from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF] text-white text-sm font-semibold hover:shadow-lg hover:shadow-[#C44BED]/25 transition-all duration-300 text-center"
                >
                  Tải xuống
                </a>
                {p.note && (
                  <p className="mt-3 text-text-muted text-xs leading-relaxed">{p.note}</p>
                )}
                {p.filename && (
                  <p className="mt-1.5 text-text-muted text-[11px] font-mono">{p.filename}</p>
                )}
              </>
            ) : (
              <>
                <div className="w-full py-3 rounded-xl bg-white/5 text-text-muted text-sm font-semibold text-center cursor-not-allowed">
                  Đang phát triển
                </div>
                <p className="mt-3 text-text-muted text-xs">Sẽ sớm ra mắt</p>
              </>
            )}
          </div>
        ))}
      </div>

      <div className="flex justify-center mt-12">
        <Link
          href="/"
          className="px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white transition-all"
        >
          ← Quay lại trang chủ
        </Link>
      </div>
    </div>
  )
}

