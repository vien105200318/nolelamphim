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

export interface EpisodeData {
  name: string
  slug: string
  filename?: string
  link_embed: string
}

export interface EpisodeServer {
  server_name: string
  server_data: EpisodeData[]
}

export interface MovieDetail extends Movie {
  content?: string
  actor?: string[]
  director?: string[]
  category?: Category[]
  country?: Country[]
  episodes?: EpisodeServer[]
}

export interface ListResponse<T> {
  status: boolean
  items: T[]
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
