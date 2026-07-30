# Nô Lệ Làm Phim

Xem phim đa nền tảng — Android, iOS, Web.

## Tech Stack

| Platform | Framework | State Management | Routing | HTTP |
|----------|-----------|-----------------|---------|------|
| **Mobile** | Flutter 3.44 | Riverpod 2 | GoRouter 14 | Dio 5 |
| **Web** | Next.js 16 | React 19 | App Router | Fetch |
| **TV** | Flutter (TV theme) | Riverpod | GoRouter | Dio |

**Common:** API từ `https://vsmov.com/api` (công khai, GET thuần), models dùng freezed + json_serializable.

## Project Structure

```
nolelamphim/
├── lib/                          # Flutter app
│   ├── main.dart
│   ├── core/
│   │   ├── api/                  # Dio client, endpoints
│   │   ├── models/               # Freezed models (Movie, Episode, ...)
│   │   ├── storage/              # SharedPreferences
│   │   ├── pip/                  # Picture-in-Picture (MethodChannel)
│   │   └── theme/                # Dark theme + liquid glass colors
│   ├── routing/app_router.dart   # GoRouter config
│   ├── shared/widgets/
│   │   ├── app_scaffold.dart     # Glass navigation bar
│   │   ├── glass_panel.dart      # Reusable frosted glass widget
│   │   └── liquid_background.dart# Gradient liquid bg + GradientText
│   └── features/
│       ├── home/                 # Home screen, carousel, grid, cards
│       ├── search/               # Search + filter chips
│       ├── category/             # Category listing & filtering
│       ├── movie_detail/         # Movie detail + episode list
│       ├── watch/                # Video player (custom overlay, PiP)
│       └── favorites/            # Favorites + watch history
├── web/                          # Next.js web app
│   └── src/
│       ├── app/                  # App Router pages
│       ├── components/           # Shared UI components
│       └── lib/                  # API client, types
├── android/
│   └── app/.../MainActivity.kt   # PiP MethodChannel
├── ios/
│   └── Runner/
│       ├── AppDelegate.swift
│       ├── SceneDelegate.swift   # PiB bridge setup
│       └── PiPBridge.swift       # AVFoundation PiP native handler
└── .github/workflows/
    └── build-release.yml         # CI/CD: APK + IPA unsigned
```

## Features

- **Home:** Movie carousel, subteam section, paginated grid, shimmer loading, pull-to-refresh
- **Search:** Tìm theo tên, lọc theo thể loại / quốc gia / năm
- **Category:** Duyệt phim theo thể loại, quốc gia, năm
- **Movie Detail:** Poster, thông tin, nội dung, diễn viên, tập phim
- **Watch:** Video player custom overlay (tự động ẩn, gradient), fullscreen, PiP (Android)
- **Favorites & History:** Yêu thích + lịch sử xem (lưu SharedPreferences)
- **UI:** Liquid glass design — blur kính, gradient accent `#FF6B9D→#C44BED→#4A9EFF`, hiệu ứng nền liquid

## Getting Started

### Prerequisites

- Flutter 3.44+ (`stable` channel)
- Node.js 20+
- npm

### Mobile (Flutter)

```bash
flutter pub get
flutter run                   # chạy thiết bị kết nối
flutter run -d chrome         # chạy web (Flutter)
flutter build apk --release   # build APK release
```

### Web (Next.js)

```bash
cd web
npm install
npm run dev                   # local dev → http://localhost:3000
npm run build                 # production build
npm run lint                  # ESLint
```

### iOS Build

App iOS dùng `flutter build ios --release --no-codesign` để build unsigned IPA. Cần sign riêng (certificate doanh nghiệp hoặc distribution) trước khi cài.

```bash
flutter build ios --release --no-codesign
# Sau đó sign thủ công:
# codesign -f -s "iPhone Distribution: ..." Runner.app/Frameworks/Flutter.framework
# codesign -f -s "iPhone Distribution: ..." Runner.app/Frameworks/App.framework
# codesign -f -s "iPhone Distribution: ..." Runner.app
```

## Build Release (CI/CD)

Trigger thủ công qua GitHub Actions → **Actions → Build Release (APK + IPA)**.

Input:
- `tag`: tên tag release (vd `v1.0.1`)
- `version_name`: phiên bản (vd `1.0.1` hoặc `v1.0.1`)

Workflow build song song:
- **Ubuntu:** APK release → upload artifact
- **macOS:** iOS unsigned IPA → upload artifact
- **Kết hợp:** tạo GitHub Release chung kèm cả 2 file

## Architecture Notes

- **State:** Riverpod `FutureProvider` + `StateNotifierProvider` — không dùng code generation cho providers (tránh phức tạp)
- **Data flow:** Screen → Provider → ApiClient → Dio → `vsmov.com/api`
- **Models:** Freezed (`@freezed`) với `json_serializable` cho parse API
- **Navigation:** GoRouter `ShellRoute` cho tab bar, leaf route cho detail/watch
- **Image:** `cached_network_image` (Flutter) / `next/image` (Web)
- **Player:** `video_player` + custom overlay (không dùng Chewie) + PiP MethodChannel
- **API response:** Tất cả hàm API trong `api.ts` (web) đều có fallback mặc định, không throw — chỉ `getMovieDetail` cần `.catch()` thủ công

## License

MIT
