'use client'

import { useEffect, useCallback, useState } from 'react'

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
  const [recent, setRecent] = useState<RecentItem[]>([])

  useEffect(() => {
    const stored = localStorage.getItem(STORAGE_KEY)
    if (stored) setRecent(JSON.parse(stored))
  }, [])

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
