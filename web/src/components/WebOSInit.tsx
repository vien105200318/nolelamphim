'use client'

import { useEffect } from 'react'
import { initWebOSRemote } from '@/lib/webos'

export default function WebOSInit() {
  useEffect(() => {
    initWebOSRemote()
  }, [])

  return null
}
