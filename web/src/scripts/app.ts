import { initWebOSRemote } from '../lib/webos'

initWebOSRemote()

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

window.addEventListener('scroll', onScroll, { passive: true })
onScroll()

backTop?.addEventListener('click', () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})

const revealEls = document.querySelectorAll('.reveal')
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible')
          io.unobserve(entry.target)
        }
      }
    },
    { threshold: 0.1, rootMargin: '0px 0px -40px 0px' },
  )
  revealEls.forEach((el) => io.observe(el))
} else {
  revealEls.forEach((el) => el.classList.add('is-visible'))
}
