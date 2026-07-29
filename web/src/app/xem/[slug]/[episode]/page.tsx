'use client'

import { useState, useEffect, use } from 'react'
import Link from 'next/link'
import type { EpisodeServer, MovieDetail } from '@/lib/types'
import { useRecent } from '@/lib/hooks/useRecent'

export default function WatchPage({
  params,
}: {
  params: Promise<{ slug: string; episode: string }>
}) {
  const { slug, episode } = use(params)
  const { add: addRecent } = useRecent()
  const [movie, setMovie] = useState<MovieDetail | null>(null)
  const [episodes, setEpisodes] = useState<EpisodeServer[]>([])
  const [serverIdx, setServerIdx] = useState(0)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([
      fetch(`https://vsmov.com/api/phim/${slug}`).then((r) => r.json()),
    ])
      .then(([data]) => {
        if (data.status && data.movie) setMovie(data.movie)
      })
      .finally(() => setLoading(false))
  }, [slug])

  useEffect(() => {
    fetch(`/api/episodes?slug=${slug}`)
      .then((r) => r.json())
      .then((data) => {
        if (data.status) setEpisodes(data.episodes)
      })
  }, [slug])

  const currentServer = episodes[serverIdx]
  const currentList = currentServer?.list ?? []
  const currentEpIdx = currentList.findIndex((e) => e.slug === episode)
  const currentEp = currentList[currentEpIdx]
  const prevEp = currentEpIdx > 0 ? currentList[currentEpIdx - 1] : null
  const nextEp =
    currentEpIdx < currentList.length - 1
      ? currentList[currentEpIdx + 1]
      : null

  useEffect(() => {
    if (movie && currentEp) {
      addRecent({
        id: movie._id,
        slug,
        name: movie.name,
        thumb: movie.thumb_url || '',
        episode: currentEp.name,
      })
    }
  }, [movie, currentEp])

  if (loading) {
    return (
      <div className="max-w-6xl mx-auto px-6 py-6">
        <div className="aspect-video rounded-2xl shimmer" />
      </div>
    )
  }

  if (!currentEp) {
    return (
      <div className="max-w-6xl mx-auto px-6 py-20 flex flex-col items-center">
        <p className="text-text-secondary text-sm">Không tìm thấy tập phim</p>
        <Link href={`/phim/${slug}`} className="mt-4 glass-tile px-5 py-2 rounded-xl text-xs text-text-secondary">
          Quay lại
        </Link>
      </div>
    )
  }

  return (
    <div className="max-w-6xl mx-auto px-6 py-6 space-y-4">
      <div className="rounded-2xl overflow-hidden bg-black">
        <div className="aspect-video w-full">
          <iframe
            src={currentEp.embed}
            className="w-full h-full"
            allowFullScreen
            allow="autoplay; fullscreen"
            title={`${movie?.name} - ${currentEp.name}`}
          />
        </div>
      </div>

      <div className="content-card px-5 py-4">
        <div className="flex items-center gap-2 text-xs text-text-muted mb-2 flex-wrap">
          <Link href="/" className="hover:text-white transition-colors">Trang chủ</Link>
          <span>/</span>
          <Link href={`/phim/${slug}`} className="hover:text-white transition-colors">{movie?.name}</Link>
          <span>/</span>
          <span className="text-white">{currentEp.name}</span>
        </div>
        <h1 className="text-lg font-bold text-text-primary">{movie?.name} - {currentEp.name}</h1>
      </div>

      {/* Server selection */}
      {episodes.length > 1 && (
        <div className="flex gap-2">
          {episodes.map((s, i) => (
            <button
              key={i}
              onClick={() => setServerIdx(i)}
              className={`px-4 py-2 rounded-xl text-xs font-medium transition-all ${
                i === serverIdx
                  ? 'glass-tile-active text-white'
                  : 'glass-tile text-text-secondary'
              }`}
            >
              {s.server_name.trim()}
            </button>
          ))}
        </div>
      )}

      {/* Episode navigation */}
      <div className="flex items-center gap-3">
        {prevEp ? (
          <Link
            href={`/xem/${slug}/${prevEp.slug}`}
            className="px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white"
          >
            ← {prevEp.name}
          </Link>
        ) : (
          <span className="px-5 py-2.5 rounded-xl text-text-muted text-xs opacity-40">← Hết</span>
        )}

        <Link
          href={`/phim/${slug}`}
          className="px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white"
        >
          Danh sách tập
        </Link>

        {nextEp ? (
          <Link
            href={`/xem/${slug}/${nextEp.slug}`}
            className="px-5 py-2.5 rounded-xl glass-tile text-text-secondary text-xs hover:text-white"
          >
            {nextEp.name} →
          </Link>
        ) : (
          <span className="px-5 py-2.5 rounded-xl text-text-muted text-xs opacity-40">Hết →</span>
        )}
      </div>
    </div>
  )
}
