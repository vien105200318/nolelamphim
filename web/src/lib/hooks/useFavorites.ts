'use client'

import { useState, useEffect, useCallback } from 'react'

export interface FavoriteItem {
  id: number
  name: string
  slug: string
  thumb: string
}

const STORAGE_KEY = 'favorites'

export function useFavorites() {
  const [favorites, setFavorites] = useState<FavoriteItem[]>([])

  useEffect(() => {
    const stored = localStorage.getItem(STORAGE_KEY)
    if (stored) setFavorites(JSON.parse(stored))
  }, [])

  const toggle = useCallback((item: FavoriteItem) => {
    setFavorites((prev) => {
      const exists = prev.find((f) => f.id === item.id)
      const next = exists
        ? prev.filter((f) => f.id !== item.id)
        : [...prev, item]
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
      return next
    })
  }, [])

  const isFavorite = useCallback(
    (id: number) => favorites.some((f) => f.id === id),
    [favorites],
  )

  return { favorites, toggle, isFavorite }
}
