# Kế hoạch chi tiết — Nô Lệ Làm Phim

## Kiến trúc

| Nền tảng | Công nghệ |
|----------|-----------|
| Android  | Flutter   |
| iOS      | Flutter   |
| TV       | Flutter   |
| **Web**  | **Astro (TypeScript)** — fork riêng, load nhanh, SEO tốt, dễ build |

Cả 4 nền tảng dùng chung API: `https://vsmov.com/api`

## Sprint 1: Khởi tạo & Hạ tầng

### Bước 1.1: Tạo Flutter project
```bash
flutter create --org com.nolelamphim --project-name nolelamphim .
```

### Bước 1.2: Cấu hình pubspec.yaml
**Dependencies chính:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Networking
  dio: ^5.4.0
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Navigation
  go_router: ^14.2.0
  
  # UI / Responsive
  responsive_framework: ^1.5.1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Video Player (cho Sprint 4)
  # media_kit: ^1.1.10
  
  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  riverpod_generator: ^2.4.0
  json_serializable: ^6.7.1
  freezed: ^2.5.2
  freezed_annotation: ^2.4.1
```

### Bước 1.3: Cấu trúc thư mục source
```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart          # Dio instance, base config
│   │   ├── api_endpoints.dart       # Tất cả endpoint constants
│   │   └── api_interceptors.dart    # Error handling, logging
│   ├── models/
│   │   ├── movie.dart               # Movie model
│   │   ├── movie.freezed.dart
│   │   ├── movie.g.dart
│   │   ├── category.dart
│   │   ├── category.freezed.dart
│   │   ├── category.g.dart
│   │   ├── country.dart
│   │   ├── episode.dart
│   │   └── api_response.dart        # Generic response wrapper
│   ├── theme/
│   │   ├── app_theme.dart           # Light + Dark theme
│   │   ├── tv_theme.dart            # TV 10ft theme
│   │   └── app_colors.dart
│   └── constants.dart               # Base URL, pagination defaults
├── features/
│   ├── home/
│   │   ├── providers/
│   │   │   └── home_provider.dart
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── movie_carousel.dart
│   │       └── movie_grid.dart
│   ├── search/
│   │   ├── providers/
│   │   │   └── search_provider.dart
│   │   ├── screens/
│   │   │   └── search_screen.dart
│   │   └── widgets/
│   │       ├── search_bar_widget.dart
│   │       └── filter_chips.dart
│   ├── category/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── movie_detail/
│   │   ├── providers/
│   │   ├── screens/
│   │   │   └── movie_detail_screen.dart
│   │   └── widgets/
│   │       ├── episode_list.dart
│   │       └── server_selector.dart
│   ├── watch/
│   │   ├── providers/
│   │   ├── screens/
│   │   │   └── watch_screen.dart
│   │   └── widgets/
│   │       └── video_player_widget.dart
│   └── actor/
│       ├── providers/
│       └── screens/
├── shared/
│   ├── layouts/
│   │   ├── mobile_layout.dart
│   │   ├── tablet_layout.dart
│   │   ├── tv_layout.dart
│   │   └── web_layout.dart
│   └── widgets/
│       ├── movie_card.dart
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       ├── empty_widget.dart
│       └── app_scaffold.dart        # Bottom nav + responsive shell
├── routing/
│   └── app_router.dart              # GoRouter config
└── main.dart
```

### Bước 1.4: API Client
- Tạo `ApiClient` singleton với Dio
- Base URL: `https://vsmov.com`
- Timeout: 30s
- Interceptor log request/response
- Auto parse lỗi HTTP

```dart
// core/api/api_client.dart
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ));
    _dio.interceptors.add(LogInterceptor());
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) {
    return _dio.get(path, queryParameters: params);
  }
}
```

### Bước 1.5: Models (dùng freezed)
```dart
// Ví dụ Movie model
@freezed
class Movie with _$Movie {
  const factory Movie({
    required String name,
    required String slug,
    required String? thumbUrl,
    required String? posterUrl,
    required int? year,
    @Default('') String? quality,
    @Default('') String? language,
    String? time,
    double? score,
    String? type, // 'series' | 'single' | 'hoathinh'
    String? status, // 'completed' | 'ongoing'
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
```

### Bước 1.6: Routing (GoRouter)
```dart
// routing/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/category', builder: (_, __) => const CategoryScreen()),
        GoRoute(path: '/phim/:slug', builder: (_, state) => MovieDetailScreen(slug: state.pathParameters['slug']!)),
        GoRoute(path: '/xem/:slug/:episode', builder: (_, state) => WatchScreen(slug: state.pathParameters['slug']!, episode: state.pathParameters['episode']!)),
      ],
    ),
  ],
);
```

## Sprint 2: Home Page

### Bước 2.1: Home Provider
- Gọi `GET /api/danh-sach/phim-moi-cap-nhat?page=1`
- Gọi `GET /api/danh-sach/subteam`
- State: `AsyncValue<HomeData>` (loading/data/error)

### Bước 2.2: MovieCard widget
- Hiển thị thumb_url + name + year + quality
- responsive: mobile=2 cột, tablet=3-4 cột, tv=5-6 cột, web=tùy width

### Bước 2.3: Home Screen
- AppBar với logo + search icon
- Banner slider (phim mới nhất)
- Section "Phim mới cập nhật" (grid)
- Section "Subteam" (horizontal list)
- Pull to refresh (mobile) / auto-refresh (web/tv)

## Sprint 3: Chi tiết phim

### Bước 3.1: Movie Detail Provider
- Gọi `GET /api/phim/{slug}`
- Parse: Thông tin, diễn viên, đạo diễn, tập, server

### Bước 3.2: Movie Detail Screen
- Poster lớn + thông tin (name, year, quality, language, time, score)
- Mô tả
- Diễn viên (horizontal scroll)
- Danh sách server phát
- Danh sách tập theo server (grid)
- Nút "Xem ngay" → navigate tới WatchScreen

### Bước 3.3: Episode List
- Grid các tập
- Đánh dấu tập đã xem (local storage)
- Highlight tập hiện tại

## Sprint 4: Video Player

### Bước 4.1: Chọn thư viện player
- **`media_kit`** (recommended) — support Android, iOS, Windows, Linux, Web
- Hoặc **`better_player`** nếu media_kit gặp vấn đề

### Bước 4.2: Watch Screen
- Video player controls: play/pause, seek, next/prev episode
- Hiển thị danh sách tập overlay
- Auto play tập kế tiếp
- Lock screen orientation (mobile landscape)
- TV: D-pad controls

## Sprint 5: Tìm kiếm + Filter

### Bước 5.1: Search Provider
- Debounce 500ms
- Gọi `GET /api/tim-kiem?keyword=...&limit=20&page=...`
- Gợi ý khi gõ

### Bước 5.2: Search Screen
- Search bar với auto focus
- Kết quả dạng grid/card
- Filter chips bộ lọc nâng cao:
  - Thể loại (dropdown) — lấy từ `/api/the-loai`
  - Quốc gia (dropdown) — lấy từ `/api/quoc-gia`
  - Năm (dropdown) — lấy từ `/api/nam`
  - Type: series / single / hoathinh
  - Status: completed / ongoing

## Sprint 6: Category / Country / Year Browser

### Bước 6.1: Category Screen
- Tab bar: Thể loại | Quốc gia | Năm
- Mỗi tab là grid/list các item
- Khi chọn → navigate sang Movie List Screen

### Bước 6.2: Movie List Screen (dùng chung)
- Gọi API tương ứng (the-loai/{slug}, quoc-gia/{slug}, nam/{year})
- Grid movie cards
- Filter params: limit, page, year, country, type, status
- Infinite scroll / load more
- Pull to refresh

## Sprint 7: TV Adaptation

### Bước 7.1: Phát hiện nền tảng
```dart
bool get isTV => Platform.isAndroid && MediaQuery.of(context).size.width > 800 && ... ;
```
Hoặc check `SystemChrome` / custom platform detection.

### Bước 7.2: TV Layout
- TV Theme: font lớn hơn (26sp+), padding lớn
- Focus system: `FocusTraversalGroup` + `Focus` widget
- D-pad điều hướng: Left/Right/Up/Down/Enter
- No scrollbar, use auto-scroll khi focus

### Bước 7.3: TV Home
- Banner hero full width
- Horizontal sections (auto scroll)
- Voice search hỗ trợ

## Sprint 8: Web với Astro (fork riêng)

### Bước 8.1: Tạo Astro project
```bash
npm create astro@latest web -- --template minimal
```

### Bước 8.2: Thư mục đề xuất
```
web/
├── src/
│   ├── pages/
│   │   ├── index.astro            # Home
│   │   ├── search.astro           # Search
│   │   ├── phim/[slug].astro      # Movie detail
│   │   └── xem/[slug]/[ep].astro  # Watch
│   ├── components/
│   │   ├── MovieCard.astro
│   │   ├── MovieGrid.astro
│   │   └── VideoPlayer.astro
│   ├── lib/
│   │   ├── api.ts                 # API client (fetch/axios)
│   │   └── types.ts              # TypeScript types
│   └── styles/
├── public/
└── package.json
```

### Bước 8.3: API Client (lib/api.ts)
```typescript
const BASE_URL = 'https://vsmov.com/api';

export async function fetchMovies(page = 1) {
  const res = await fetch(`${BASE_URL}/danh-sach/phim-moi-cap-nhat?page=${page}`);
  return res.json();
}
```

### Bước 8.4: Tính năng
- Server Side Rendering (SSR) cho SEO (adapter `@astrojs/node`)
- Static prerender cho trang tĩnh (sitemap, robots)
- Video player dùng HTML5 `<video>` tag
- Responsive với Tailwind CSS
- Dark mode mặc định

## Sprint 9: Polish & Hoàn thiện

### Bước 9.1: Theme
- Dark mode mặc định (phim ảnh)
- Light mode option
- TV theme riêng (màu sáng hơn, contrast cao)

### Bước 9.2: Loading / Error / Empty
- Loading: Shimmer effect cho card grid
- Error: Retry button + message
- Empty: Illustration + message

### Bước 9.3: Performance
- `ImageCache` tuning
- `ListView.builder` / `GridView.builder` everywhere
- Debounce search
- Cache API response (dio cache interceptor)

### Bước 9.4: Khác
- Splash screen
- App icon
- Bottom nav: Home, Search, Category, (Watch History?)
- Drawer/sidebar cho web/tablet

---

## Luồng điều hướng chính

```
Home ──► Chi tiết phim ──► Xem phim
  │            │
  │            └──► Chọn tập ──► Xem phim
  │
  ├──► Search ──► Chi tiết phim ──► Xem phim
  │
  ├──► Category Browser
  │     ├──► Thể loại ──► DS phim ──► Chi tiết ──► Xem
  │     ├──► Quốc gia ──► DS phim ──► Chi tiết ──► Xem
  │     └──► Năm ──► DS phim ──► Chi tiết ──► Xem
  │
  └──► Actor ──► DS phim ──► Chi tiết ──► Xem
```

---

## Ghi chú

- **Flutter** codebase chính: Android, iOS, TV
- **Astro** (thư mục `web/`): Web app riêng, SSR, SEO, load nhanh
- Cả hai đều dùng chung API `https://vsmov.com/api`
