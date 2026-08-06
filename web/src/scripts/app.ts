import { initWebOSRemote } from '../lib/webos'
import { registerPageInit } from './lifecycle'

registerPageInit(() => {
  const ac = new AbortController()

  initWebOSRemote(ac.signal)

  const progressBar = document.getElementById('scroll-progress')
  const backTop = document.getElementById('back-to-top')

  let ticking = false
  function onScroll() {
    if (ticking) return
    ticking = true
    requestAnimationFrame(() => {
      const y = window.scrollY
      const max = document.documentElement.scrollHeight - window.innerHeight
      if (progressBar) {
        progressBar.style.transform = `scaleX(${max > 0 ? y / max : 0})`
      }
      if (backTop) {
        backTop.classList.toggle('show', y > 600)
      }
      ticking = false
    })
  }

  window.addEventListener('scroll', onScroll, { passive: true, signal: ac.signal })
  onScroll()

  backTop?.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  })

  document.addEventListener(
    'error',
    (e) => {
      const target = e.target as HTMLElement | null
      if (target && target.tagName === 'IMG') {
        const shell = target.closest<HTMLElement>('.poster-shell')
        if (shell) {
          shell.classList.remove('shimmer')
          shell.classList.add('poster-missing')
          target.remove()
        }
      }
    },
    { capture: true, signal: ac.signal },
  )

  const revealEls = document.querySelectorAll('.reveal')
  let io: IntersectionObserver | null = null
  if ('IntersectionObserver' in window) {
    io = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible')
            io?.unobserve(entry.target)
          }
        }
      },
      { threshold: 0.1, rootMargin: '0px 0px -40px 0px' },
    )
    revealEls.forEach((el) => io?.observe(el))
  } else {
    revealEls.forEach((el) => el.classList.add('is-visible'))
  }

  return () => {
    ac.abort()
    io?.disconnect()
  }
})
