import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { SITE_URL, SITE_NAME } from "@/lib/site";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import WebOSInit from "@/components/WebOSInit";
import ScrollProgress from "@/components/animations/ScrollProgress";
import BackToTop from "@/components/animations/BackToTop";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: SITE_NAME,
    template: `%s | ${SITE_NAME}`,
  },
  description: "Xem phim đa nền tảng miễn phí, cập nhật nhanh nhất.",
  keywords: ["phim", "xem phim", "phim mới", "phim bộ", "phim lẻ", "Nô Lệ Làm Phim"],
  openGraph: {
    siteName: SITE_NAME,
    type: "website",
    locale: "vi_VN",
  },
  twitter: {
    card: "summary_large_image",
  },
  icons: [
    { rel: "icon", url: "/favicon.ico", sizes: "32x32" },
    { rel: "icon", url: "/favicon.svg", type: "image/svg+xml" },
    { rel: "apple-touch-icon", url: "/apple-touch-icon.png", sizes: "180x180" },
  ],
};

export const viewport = {
  themeColor: "#0a0a0f",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="vi"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <WebOSInit />
        <ScrollProgress />
        <div className="fixed inset-0 -z-10 overflow-hidden pointer-events-none" aria-hidden>
          <div className="absolute -top-32 -left-32 w-[36rem] h-[36rem] rounded-full bg-[#C44BED]/8 blur-[120px]" />
          <div className="absolute top-1/4 -right-40 w-[32rem] h-[32rem] rounded-full bg-[#4A9EFF]/8 blur-[120px]" />
        </div>
        <Navbar />
        <main className="flex-1">
          {children}
        </main>
        <Footer />
        <BackToTop />
      </body>
    </html>
  );
}
