'use client'

import { useFavorites } from '@/lib/hooks/useFavorites'

export default function FavoriteButton({
  id,
  name,
  slug,
  thumb,
}: {
  id: number
  name: string
  slug: string
  thumb: string
}) {
  const { toggle, isFavorite } = useFavorites()
  const active = isFavorite(id)

  return (
    <button
      onClick={() => toggle({ id, name, slug, thumb })}
      className={`px-4 py-2 rounded-xl text-xs font-medium transition-all duration-200 ${
        active
          ? 'bg-[#FF6B9D]/20 text-[#FF6B9D] border border-[#FF6B9D]/30'
          : 'glass-tile text-text-secondary hover:text-white'
      }`}
    >
      {active ? '♥ Đã thích' : '♡ Yêu thích'}
    </button>
  )
}
