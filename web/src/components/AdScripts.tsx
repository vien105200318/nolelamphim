import Script from 'next/script'

export default function AdScripts() {
  return (
    <>
      <Script src="/hilltopads-popunder.js" strategy="afterInteractive" />
      <Script src="/hilltopads-300x100.js" strategy="afterInteractive" />
      <Script src="/hilltopads-300x250.js" strategy="afterInteractive" />
      <Script src="/hilltopads-inpage.js" strategy="afterInteractive" />
    </>
  )
}
