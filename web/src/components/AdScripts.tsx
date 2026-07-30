'use client'

import { useEffect } from 'react'

const scripts = [
  '/hilltopads-popunder.js',
  '/hilltopads-300x100.js',
  '/hilltopads-300x250.js',
  '/hilltopads-inpage.js',
]

export default function AdScripts() {
  useEffect(() => {
    const load = () => {
      scripts.forEach((src, i) => {
        setTimeout(() => {
          const s = document.createElement('script')
          s.src = src
          s.async = true
          document.body.appendChild(s)
        }, i * 1000)
      })
    }
    if (document.readyState === 'complete') {
      setTimeout(load, 2000)
    } else {
      window.addEventListener('load', () => setTimeout(load, 2000))
    }
  }, [])

  return null
}
