'use client'

import { useCallback, useState } from 'react'

export interface RecentItem {
  id: number
  slug: string
  name: string
  thumb: string
  episode?: string
  watchedAt: number
}

const STORAGE_KEY = 'recent'

export function useRecent() {
  const [recent, setRecent] = useState<RecentItem[]>(() => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem(STORAGE_KEY)
      return stored ? JSON.parse(stored) : []
    }
    return []
  })

  const add = useCallback((item: Omit<RecentItem, 'watchedAt'>) => {
    setRecent((prev) => {
      const next = [
        { ...item, watchedAt: Date.now() },
        ...prev.filter((r) => r.slug !== item.slug),
      ].slice(0, 20)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
      return next
    })
  }, [])

  return { recent, add }
}
