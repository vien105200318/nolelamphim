export interface TMDb {
  type?: string
  id?: string
  season?: unknown
  vote_average?: string
  vote_count?: number
}

export interface Movie {
  _id: number
  name: string
  origin_name?: string
  slug: string
  poster_url?: string
  thumb_url?: string
  year?: number
  quality?: string
  lang?: string
  time?: string
  type?: string
  status?: string
  episode_current?: string
  episode_total?: string
  keywords?: string | string[]
  tmdb?: TMDb
}

export interface Category {
  _id: number
  name: string
  slug: string
}

export interface Country {
  _id: number
  name: string
  slug: string
}

export interface EpisodeItem {
  name: string
  slug: string
  embed: string
  m3u8?: string
}

export interface EpisodeServer {
  server_name: string
  list: EpisodeItem[]
}

export interface MovieDetail extends Movie {
  content?: string
  actor?: string[]
  director?: string[]
  category?: Category[]
  country?: Country[]
  episodes?: EpisodeServer[]
  view?: number
  imdb?: { id?: string | null }
  sub_docquyen?: boolean
  trailer_url?: string | null
}

export interface Pagination {
  totalItems: number
  totalItemsPerPage: number
  currentPage: number
  totalPages: number
}

export interface ListResponse<T> {
  status: boolean
  items: T[]
  pagination?: Pagination
}

export interface DataListResponse<T> {
  status: string
  data: {
    items: T[]
  }
}

export interface MovieDetailResponse {
  status: boolean
  msg?: string
  movie: MovieDetail | null
}
