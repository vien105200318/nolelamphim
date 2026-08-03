'use client'

import { useEffect, useMemo, useState } from 'react'
import { getCountries, getYears } from '@/lib/api'
import type { Movie, Category, Country } from '@/lib/types'
import MovieGrid from './MovieGrid'

interface MovieFiltersProps {
  path: string
  initialItems: Movie[]
  options?: {
    type?: boolean
    status?: boolean
    year?: boolean
    country?: boolean
  }
}

interface Chip {
  key: string
  label: string
}

const TYPE_OPTIONS: Chip[] = [
  { key: 'series', label: 'Phim bộ' },
  { key: 'single', label: 'Phim lẻ' },
]

const STATUS_OPTIONS: Chip[] = [
  { key: 'ongoing', label: 'Đang chiếu' },
  { key: 'completed', label: 'Hoàn thành' },
]

export default function MovieFilters({
  path,
  initialItems,
  options = {},
}: MovieFiltersProps) {
  const [type, setType] = useState('')
  const [status, setStatus] = useState('')
  const [year, setYear] = useState('')
  const [country, setCountry] = useState('')
  const [sort, setSort] = useState<'newest' | 'year'>('newest')
  const [items, setItems] = useState(initialItems)

  const [years, setYears] = useState<Category[]>([])
  const [countries, setCountries] = useState<Country[]>([])

  useEffect(() => {
    getYears()
      .then((r) => {
        if (r.status === 'success') setYears(r.data.items)
      })
      .catch(() => {})
    if (options.country) {
      getCountries()
        .then((r) => {
          if (r.status === 'success') setCountries(r.data.items)
        })
        .catch(() => {})
    }
  }, [options.country])

  const extraParams = useMemo(() => {
    const p = new URLSearchParams()
    if (type) p.set('type', type)
    if (status) p.set('status', status)
    if (year) p.set('year', year)
    if (country) p.set('country', country)
    return p.toString()
  }, [type, status, year, country])

  const hasFilter = type || status || year || country
  const clearAll = () => {
    setType('')
    setStatus('')
    setYear('')
    setCountry('')
  }

  const chip = (
    active: boolean,
    label: string,
    onClick: () => void,
    clearable = true,
  ) => (
    <button
      onClick={onClick}
      className={`px-3.5 py-1.5 rounded-xl text-[11px] font-medium transition-all ${
        active
          ? 'glass-tile-active text-white'
          : 'glass-tile text-text-secondary hover:text-white'
      }`}
    >
      {label}
      {active && clearable && <span className="ml-1 text-white/60">✕</span>}
    </button>
  )

  return (
    <div>
      <div className="flex flex-wrap items-center gap-2 mb-5">
        {options.type && (
          <div className="flex items-center gap-1.5 mr-1">
            {TYPE_OPTIONS.map((o) => chip(type === o.key, o.label, () => setType(type === o.key ? '' : o.key)))}
          </div>
        )}
        {options.status && (
          <div className="flex items-center gap-1.5 mr-1">
            {STATUS_OPTIONS.map((o) => chip(status === o.key, o.label, () => setStatus(status === o.key ? '' : o.key)))}
          </div>
        )}
        {options.year && years.length > 0 && (
          <select
            value={year}
            onChange={(e) => setYear(e.target.value)}
            className="px-3 py-1.5 rounded-xl glass-tile text-text-secondary text-[11px] font-medium outline-none cursor-pointer appearance-none bg-no-repeat pr-8"
            style={{
              backgroundImage:
                "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='%23a0a0b8'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E\")",
              backgroundPosition: 'right 10px center',
            }}
          >
            <option value="" className="bg-bg-card">Năm</option>
            {years.map((y) => (
              <option key={y.slug} value={y.slug} className="bg-bg-card">
                {y.name}
              </option>
            ))}
          </select>
        )}
        {options.country && countries.length > 0 && (
          <select
            value={country}
            onChange={(e) => setCountry(e.target.value)}
            className="px-3 py-1.5 rounded-xl glass-tile text-text-secondary text-[11px] font-medium outline-none cursor-pointer appearance-none bg-no-repeat pr-8"
            style={{
              backgroundImage:
                "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='%23a0a0b8'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E\")",
              backgroundPosition: 'right 10px center',
            }}
          >
            <option value="" className="bg-bg-card">Quốc gia</option>
            {countries.map((c) => (
              <option key={c.slug} value={c.slug} className="bg-bg-card">
                {c.name}
              </option>
            ))}
          </select>
        )}
        {hasFilter && (
          <button
            onClick={clearAll}
            className="px-3 py-1.5 rounded-xl text-[11px] text-text-muted hover:text-white transition-colors"
          >
            Xoá bộ lọc
          </button>
        )}
        <div className="flex items-center gap-1.5 ml-auto">
          <span className="text-[10px] text-text-muted mr-1">Sắp xếp:</span>
          <button
            onClick={() => setSort(sort === 'newest' ? 'year' : 'newest')}
            className={`px-3 py-1.5 rounded-xl text-[11px] font-medium transition-all ${
              sort === 'year' ? 'bg-white/12 text-white' : 'glass-tile text-text-secondary'
            }`}
          >
            {sort === 'newest' ? 'Mới nhất' : 'Năm giảm dần'}
          </button>
        </div>
      </div>

      <MovieGrid
        key={`${path}|${extraParams}`}
        initialItems={items}
        path={path}
        extraParams={extraParams}
        sort={sort}
        onData={setItems}
      />
    </div>
  )
}
