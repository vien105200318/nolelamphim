import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
  const slug = req.nextUrl.searchParams.get('slug')
  if (!slug) return NextResponse.json({ status: false, episodes: [] })

  try {
    const res = await fetch(`https://vsmov.com/phim/${slug}`, {
      headers: { 'User-Agent': 'Mozilla/5.0' },
    })
    const html = await res.text()

    const start = html.indexOf('[{"server_name"')
    if (start < 0) return NextResponse.json({ status: false, episodes: [] })

    let depth = 0
    let inStr = false
    let end = start
    for (let i = start; i < html.length; i++) {
      const ch = html[i]
      if (ch === '\\' && inStr) continue
      if (ch === '"') { inStr = !inStr; continue }
      if (inStr) continue
      if (ch === '[') depth++
      if (ch === ']') { depth--; if (depth === 0) { end = i + 1; break } }
    }

    let raw = html.slice(start, end)
    raw = raw.replace(/[\x00-\x1f\x7f]/g, '')
    raw = raw.replace(/\\\//g, '/')
    raw = raw.replace(/\\"/g, '"')
    raw = raw.replace(/\\n/g, '').replace(/\\r/g, '')

    const episodes = JSON.parse(raw)
    return NextResponse.json({ status: true, episodes })
  } catch {
    return NextResponse.json({ status: false, episodes: [] })
  }
}
