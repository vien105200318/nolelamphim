'use client'

import { useCallback, useState } from 'react'

export interface RecentItem {
  id: number
  slug: string
  name: string
  thumb: string
  episode?: string
  episodeSlug?: string
  watchedAt: number
}

const STORAGE_KEY = 'recent'

export function useRecent() {
  const [recent, setRecent] = useState<RecentItem[]>(() => {
    if (typeof window !== 'undefined') {
      try {
        return JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]')
      } catch {
        return []
      }
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

  const remove = useCallback((slug: string) => {
    setRecent((prev) => {
      const next = prev.filter((r) => r.slug !== slug)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
      return next
    })
  }, [])

  const clear = useCallback(() => {
    setRecent([])
    localStorage.setItem(STORAGE_KEY, '[]')
  }, [])

  return { recent, add, remove, clear }
}
