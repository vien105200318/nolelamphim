'use client'

import { motion, useScroll, useSpring } from 'motion/react'

export default function ScrollProgress() {
  const { scrollYProgress } = useScroll()
  const scaleX = useSpring(scrollYProgress, {
    stiffness: 120,
    damping: 30,
    restDelta: 0.001,
  })

  return (
    <motion.div
      aria-hidden
      className="fixed top-0 left-0 right-0 h-[3px] z-[70] origin-left bg-gradient-to-r from-[#FF6B9D] via-[#C44BED] to-[#4A9EFF]"
      style={{ scaleX }}
    />
  )
}
