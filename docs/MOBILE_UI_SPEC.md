# Spec Giao Diện Mobile — Nô Lệ Làm Phim

> Tài liệu này mô tả toàn bộ giao diện web hiện tại (`https://nolelamphim.vercel.app`)
> để dev mobile làm lại giống hệt trên app (Android/iOS). Có thể dùng bản web làm
> reference thị giác song song. Tham khảo code thật tại `web/` nếu cần số liệu chính xác.

---

## 1. Tổng quan phong cách

**Phong cách chủ đạo: "Liquid Glass" trên nền tối.** Toàn bộ app là dark theme với
các tấm kính (glass panel) phủ khắp trang: navbar, hero, từng section, footer đều nằm
trong khung kính mờ (frosted glass) có viền sáng, gradient phản chiếu ở nửa trên và
bóng đổ mềm. Nền là gradient tối nhiều lớp với các đốm màu (blob) tím/hồng/xanh nhạt.

Vibe tổng thể: **tối, bóng bẩy, "premium tech", tương phản cao**, accent là dải
gradient hồng → tím → xanh dương (`#FF6B9D → #C44BED → #4A9EFF`) dùng xuyên suốt cho
CTA, badge, progress, text gradient khi hover.

### Không được làm

- Không dùng màu sáng nền (light mode). Không có mode light.
- Không đổi layout, tỉ lệ, màu sắc, hiệu ứng so với web — **bắt chước 1:1**.
- Dữ liệu API thiếu/trống → hiển thị empty state nhẹ nhàng (icon + text + nút phụ), không để trống vụng về.

---

## 2. Design tokens

### 2.1 Màu (từ `web/src/styles/global.css` `@theme` + `app_colors.dart`)

| Token | Giá trị | Ghi chú |
|---|---|---|
| `bg-deeper` | `#06060E` | nền html/body |
| `bg-dark` | `#0A0A14` | nền chính, bottom của gradient |
| `bg-surface` | `#111122` | surface |
| `bg-card` | `#181830` | nền card/poster khi thiếu ảnh |
| `text-primary` | `#FFFFFF` | |
| `text-secondary` | `rgba(255,255,255,0.7)` | |
| `text-muted` | `rgba(255,255,255,0.4)` | |
| `gradient-1` | `#FF6B9D` (hồng) | |
| `gradient-2` | `#C44BED` (tím) | |
| `gradient-3` | `#4A9EFF` (xanh dương) | |
| `glass` | `rgba(255,255,255,0.08)` | nền glass phụ |
| `glass-hover` | `rgba(255,255,255,0.16)` | |
| `glass-border` | `rgba(255,255,255,0.12)` | |
| `glass-border-hover` | `rgba(255,255,255,0.25)` | |

Accent khác khi render nội dung (không phải design token):
- Đỏ Marvel `#E62429`, xanh lơ `#22D3EE`, cam `#FFB020`, tím `#7C3AED`, vàng `#FF9A3C` — chỉ dùng trong gradient nền ThemeSection.

### 2.2 Nền gradient chính (`body::before`, layer dưới cùng)

Nền là 5 radial-gradient chồng lên 1 linear gradient dọc (`#0b0a1c → #0a0a14 → #0c0a1a`).
Đơn giản hoá cho mobile: nền tối `#0b0a1c → #0a0a14` kèm 3–5 đốm màu mờ ở các góc:

- Góc trên-trái: hồng `rgba(255,92,160,0.2~0.42)`
- Góc trên-phải: xanh `rgba(82,140,255,0.2~0.45)`
- Góc dưới-phải: tím `rgba(150,80,255,0.2~0.42)`
- Góc dưới-trái: teal `rgba(0,214,200,0.15~0.34)`
- Giữa: cam nhạt `rgba(255,176,60,0.12~0.3)`

**Lưu ý performance (quan trọng):** trên mobile nên dùng gradient tối giản, opacity thấp,
KHÔNG dùng `background-attachment: fixed` (gây repaint mỗi lần scroll — đã từng gây lag nặng).
Nên vẽ nền là 1 lớp tĩnh duy nhất, không scroll theo nội dung.

### 2.3 Blob nền (decor, layer giữa)

3 đốm tròn mờ `blur(120px)`, `fixed`, `pointer-events: none`:
- Trên-trái: `#FF5C9E` @ 15%
- Phải-giữa: `#4A9EFF` @ 15%
- Dưới-giữa: `#00D6C8` @ 10%

Mobile: chỉ giữ màu nhạt, bỏ hoặc giảm blur xuống mức chấp nhận được (blur 120px tốn GPU).

### 2.4 Font

- **Be Vietnam Pro** — hỗ trợ tiếng Việt đầy đủ. Self-host (không dùng Google Fonts runtime).
- Weights dùng: 400, 500, 600, 700.
- `font-mono`: dùng cho tên file trên trang Download.

---

## 3. Hệ thống "Liquid Glass" (dùng ở khắp nơi)

Đây là ngôn ngữ visual cốt lõi. Có 5 biến thể chính:

### 3.1 `.liquid-glass` — panel lớn (navbar, hero frame, section, footer, toast)

```
nền:    linear-gradient(180deg, rgba(255,255,255,0.09) 0%,
                                  rgba(255,255,255,0.02) 45%,
                                  rgba(255,255,255,0.06) 100%),
        rgba(24,24,48,0.04)
blur:   backdrop-filter: blur(32px) saturate(180%)   ← desktop
border: 1px solid rgba(255,255,255,0.16)
bóng:   0 12px 40px -12px rgba(0,0,0,0.55)
inset:  top rgba(255,255,255,0.28) · bottom/trái/phải rgba(255,255,255,0.05~0.07)
```

Mobile (đã tối ưu, giữ nguyên look): **không dùng backdrop-filter**; bù bằng nền đục hơn:
`linear-gradient(...) + rgba(18,18,40,0.55)`.

Thêm 2 lớp pseudo (mobile làm bằng layer riêng):
- **Specular cap** (`::before`): dải sáng cong nửa trên, radial-gradient trắng
  `rgba(255,255,255,0.32) → 0.09 → transparent`, mask mờ dần xuống dưới.
- **Sheen theo con trỏ** (`::after`): radial-gradient trắng `rgba(255,255,255,0.14)`
  theo `(--lx,--ly)`, `opacity: 0` → `1` khi hover. Mobile có thể bỏ (không có hover).

### 3.2 `.content-card` — panel nội dung (Nội dung phim, danh sách tập, empty state)

```
nền:    linear-gradient(180deg, rgba(255,255,255,0.09),
                                  rgba(255,255,255,0.03) 45%,
                                  rgba(255,255,255,0.065) 100%),
        rgba(24,24,48,0.1)
blur:   blur(24px) saturate(160%)   ← desktop
border: 1px solid rgba(255,255,255,0.12)
radius: 14px
bóng:   0 8px 30px -12px rgba(0,0,0,0.5), inset top trắng 0.16
```

### 3.3 `.glass-tile` — tile nhỏ (nút, chip, pagination, select, dropdown, back-to-top)

```
nền:    linear-gradient(180deg, rgba(255,255,255,0.09),
                                  rgba(255,255,255,0.025) 45%,
                                  rgba(255,255,255,0.05) 100%),
        rgba(24,24,48,0.06)
blur:   blur(12px) saturate(150%)   ← desktop
border: 1px solid rgba(255,255,255,0.13)
bóng:   0 2px 12px rgba(0,0,0,0.25), inset top trắng 0.18, inset bottom 0.04
```

Hover: sáng nền lên (`rgba(255,255,255,0.17→0.055→0.11) + rgba(24,24,48,0.32)`),
viền `0.22`, bóng to hơn `0 4px 20px rgba(0,0,0,0.35)`.

### 3.4 `.glass-chip` — chip tĩnh nhỏ (thể loại, keyword, meta) — KHÔNG blur

```
nền:    linear-gradient(180deg, rgba(255,255,255,0.1), rgba(255,255,255,0.03))
border: 1px solid rgba(255,255,255,0.11)
bóng:   inset top trắng 0.14, 0 1px 4px rgba(0,0,0,0.2)
```

### 3.5 `.glass-frame` — khung kính ép cho ảnh (poster, hero, banner)

```
border: 1px solid rgba(255,255,255,0.13)
bóng:   0 4px 20px -6px rgba(0,0,0,0.45), inset top 0.2, inset bottom 0.04
```

### 3.6 Trạng thái active

- `.glass-tile-active` — nút server/tab đang chọn: nền sáng hơn
  (`rgba(255,255,255,0.2→0.06→0.12) + rgba(24,24,48,0.35)`), viền `0.26`, thêm ring
  tím `0 0 0 1px rgba(196,75,237,0.15)`.
- `.pagination-active` — trang phân trang đang chọn: **gradient hồng→tím→xanh**,
  chữ trắng, bóng `0 10px 15px -3px rgba(196,75,237,0.25)`.

---

## 4. Layout chung & components

### 4.1 Khung trang (`BaseLayout`)

```
body: min-h-full, flex column
  ├── [decor nền: gradient + blobs]
  ├── Navbar (sticky top)
  ├── main.flex-1
  │     └── (slot — nội dung từng trang)
  └── Footer
  + scroll-progress bar (top, 3px, gradient, scaleX theo scrollY)
  + back-to-top (fixed bottom-right, nút tròn glass-tile 44px, hiện khi scroll > 600px)
```

- Padding ngang nội dung: **16px mobile / 32px desktop** (`px-4 md:px-8`).
- Khoảng cách giữa các section: **40px** (`mt-10`).

### 4.2 Navbar (sticky, z-50)

- Container sticky top, có lớp `.scrolled` khi `scrollY > 8` → navbar thu padding,
  nền đục hơn `rgba(10,10,20,0.85)`, bỏ blur.
- **Desktop:** 1 thanh glass tròn `rounded-3xl` chứa: logo + tên app (trái), link nav
  (giữa, có "pill" trắng trượt theo item active), nút mode switch (phải).
- **Mobile:** logo + tên (trái), nút **hamburger** (phải, 3 gạch ngang).
  Nhấn hamburger → dropdown glass trượt xuống: header "Mode" + 2 tab
  (Normal/Tu Tiên trong 1 `glass-tile`), rồi 5 link:
  **Trang chủ · Tìm kiếm · Yêu thích · Đã xem · Tải App**.
  Link active: chữ trắng + nền `white/10`.
  Hamburger thành X khi mở (2 đường chéo, 1 đường ẩn).
- **Mode switcher:** nút tròn glass có chấm màu (Normal = xanh `#4A9EFF`) + chevron.
  Menu dropdown glass: Normal (chọn sẵn, có tick xanh lá) / **Tu Tiên (disabled, badge
  "Sắp ra mắt" vàng)**. Nhấn Tu Tiên → toast "Mode Tu Tiên sắp ra mắt — Coming soon".
  Mode lưu `localStorage` (`phim:mode`). Hiện tại chỉ có Normal hoạt động.

### 4.3 Hero Carousel (trang chủ)

- Khung `glass-frame` tròn `rounded-2xl`, tỉ lệ **16:10 mobile / 21:9 desktop**, `max-h-[80vh]`.
- Bên trong: nền gradient tím/xanh mờ, rồi slides phủ đầy (ảnh `poster_url`, w=1600).
- Slide đang hiện: hiệu ứng **Ken Burns** (zoom chậm `scale 1→1.08` trong 9s).
  Chuyển slide: **cross-fade 1s** (opacity).
- Gradient đè dưới cùng: `from-bg-dark via-bg-dark/25 to-transparent` (tối dần xuống đáy).
- Nội dung text đè góc dưới-trái:
  - Badge pill gradient "Nổi bật · {năm}" (chữ `10-12px`, bold, uppercase, tracking rộng).
  - Tiêu đề phim (trắng, bold, `20px mobile / 30-36px desktop`, `drop-shadow`, tối đa 2 dòng).
  - Tên gốc (text-secondary, nhỏ hơn, 1 dòng truncate).
  - Nút **"▶ Xem ngay"** (pill, `bg-white/15 backdrop-blur` viền `white/20`, hover sáng + scale 1.05) → trang `/phim/{slug}`.
  - Badge chất lượng (VD "Full HD"): pill nhỏ `bg-white/10 backdrop-blur`, ẩn trên mobile rất nhỏ.
- Các text xuất hiện có hiệu ứng **fade-up** (từ `translateY(28px)`, chậm dần theo delay 0.15s/0.3s/0.45s).
- **Counter** góc trên-phải (desktop): "01 — 08" kiểu `01 / 08` với gạch ngang.
- **Nút prev/next** tròn glass 2 bên (chỉ hiện khi hover — desktop; mobile bỏ hoặc luôn mờ).
- **Dots** dưới hero: gạch ngang; active là gradient dài 40px có **thanh tiến trình chạy**
  (autoplay 6s mỗi slide, thanh `progress` chạy theo thời gian).
- Autoplay: 6s/slide, dừng khi hover (desktop), tạm dừng khi tab ẩn.
- Có **parallax**: slides dịch xuống nhẹ theo scroll (`translateY(0→60px)` khi cuộn qua hero).

### 4.4 Movie Card (poster 2:3) — dùng khắp nơi

```
<card> width 160px (section ngang) | grid-responsive trong lưới
  ├── poster-shell aspect 2:3, rounded-xl, glass-frame
  │     └── img w=320, object-cover, lazy
  ├── badge "Mới" (xanh #4A9EFF) / "Hot" (gradient hồng→tím) — góc trên-trái, có glow
  ├── badge tập hiện tại (VD "Tập 14") — góc dưới-phải, bg-black/60, blur nhẹ
  ├── hover: poster nhấc lên -4px + glow tím + ring tím 35%; ảnh zoom scale 1.05
  │         + sheen trắng quét ngang + gradient tối dần từ đáy
  └── dưới poster:
        h3: tên phim (15px, 2 dòng tối đa)
        meta 1 dòng: "★ 8.5 · 2023 · Full HD · Vietsub" (dấu · phân cách)
```

Meta hiển thị theo thứ tự: **TMDB rating** (chỉ khi > 0, dạng `★ 8.5`), **năm**, **chất lượng**, **ngôn ngữ**.
Phần tử nào thiếu thì ẩn; nếu không có gì thì ẩn cả dòng meta.

Skeleton loading (card chưa có ảnh): nền shimmer (gradient trắng nhẹ chạy ngang 1.5s
loop) cho poster + 2 dòng text. Mobile tối ưu: dùng nền tĩnh thay vì shimmer animation.

### 4.5 CategorySection (trang chủ) — 1 khối / mỗi thể loại

```
<section mt-10>
  └── .liquid-glass rounded-3xl px-4/6 py-5
        ├── header: tên section (14px semibold) [trái] + "Xem thêm →" (11px muted) [phải]
        └── hàng card ngang: scroll ngang, snap, ẩn scrollbar, card 160px
```

Nếu section rỗng → empty state: icon film trong vòng tròn `white/5` + text
"Không thể tải phim thể loại này ngay lúc này" + nút "Xem trang thể loại".

### 4.6 ThemeSection "Chủ đề" (trang chủ)

- Header: "Chủ đề" (14px semibold) + sub "Khám phá theo sở thích" (11px muted).
- Hàng ngang scroll (card 220px rộng × 130px cao mobile).
- Mỗi card: nền ảnh mờ (opacity 55% → 75% hover), **gradient theo chủ đề** đè lên,
  tối dần từ đáy, text đáy trái: tên (bold, 16-18px) + sub (11px, white/70).
- 7 chủ đề (thứ tự): **Chữa lành** (hồng→tím), **Marvel** (đỏ→navy), **Kho tàng**
  (vàng→tím), **Anime mới** (xanh→tím), **Top 10 phim bộ** (xanh lơ→xanh dương),
  **Cổ trang** (cam→đỏ), **Phim điện ảnh** (tím→xanh).
- Card click → trang liên quan (the-loai hoặc search?q=).

### 4.7 ContinueWatching "Tiếp tục xem" (trang chủ)

- Chỉ hiện nếu có lịch sử xem (localStorage `recent` có item có episode).
- Card 150px, ảnh thumb w=300, gradient tối từ đáy:
  - badge hồng "Tập 5" (góc trên-trái)
  - badge "★ 8.5" (góc trên-phải, bg-black/60)
  - text đáy: "▶ Tiếp tục" (11px, trắng)
- Nút xoá ✕ nhỏ góc trên-phải (hover hiện).
- Header: "Tiếp tục xem" + "N phim".
- Empty: icon play trong vòng tròn + "Bạn chưa xem phim nào" + nút "Khám phá phim mới".

### 4.8 MovieGrid + Pagination

- **Lưới card responsive:** 2 cột (mobile) / 3-4 (tablet) / 5-6 (desktop) / 8 (2xl),
  khoảng cách `gap-2.5`.
- **Pagination** dưới lưới: nút `« ‹ [trang] › »` — trang active = gradient accent
  (`.pagination-active`), còn lại glass-tile. Nút `...` hiện khi nhiều trang. Disabled
  khi ở trang đầu/cuối (opacity 30%).
- Loading: spinner vòng tròn 20px (viền trắng 20% + mũi trắng 60%) quay.
- Phân trang client-side fetch API, giữ trạng thái.

### 4.9 Footer

- `liquid-glass` full-width (không bo góc).
- 4 cột (2 cột trên mobile):
  1. Logo + tên app + tagline "Xem phim đa nền tảng, cập nhật nhanh nhất."
  2. **Điều hướng**: Trang chủ · Tìm kiếm · Danh mục
  3. **Thể loại**: Hành động · Lãng mạn · Hài · Viễn tưởng
  4. **Thông tin**: email liên hệ (mailto) · "Dữ liệu từ vsmov.com" · "Phiên bản 1.0"
- Mỗi cột có heading chữ 12px uppercase tracking-widest muted; link 12px secondary,
  hover trắng.
- Đáy: divider `border-white/5` + "© {năm} Nô Lệ Làm Phim" (trắng 40%, 12px, center).

### 4.10 Empty state chung

Icon (film/heart/search/play) trong vòng tròn `bg-white/5` 40-56px + text chính 14px
secondary + text phụ 12px muted + nút glass-tile. Nằm trong `.content-card` bo 14px.

### 4.11 Toast (mode switch)

Pill glass tròn `rounded-full px-5 py-2.5`, chữ 14px semibold trắng, `fixed` bottom-center,
fade + slide lên/xuống, tự ẩn sau 3.2s.

### 4.12 Modal

- **Trailer modal:** overlay đen 85%, player 16:9 `max-w-3xl`, frame youtube-nocookie,
  nút đóng tròn đen góc trên-phải. Mở bằng nút "▶ Trailer".
- **Report modal:** overlay đen 60% + `blur-sm`, card glass `max-w-sm` bo 16px:
  tiêu đề "Báo lỗi phim" + danh sách lỗi (mục chọn đầu tiên active = gradient + border tím)
  + textarea "Ghi chú thêm (không bắt buộc)..." + 2 nút **Huỷ** / **Gửi báo lỗi**
  (Gửi = gradient accent). Gửi → mở mail client với nội dung soạn sẵn.

### 4.13 Dropdown / Popover

- Filter dropdown & share popover: `glass-tile rounded-xl` (popover tròn hơn), shadow-2xl,
  mở với hiệu ứng `translateY(-8px) scale(0.96) → 0` + opacity.
- Share popover: nút "Copy liên kết" (đổi thành "Đã copy!" 2s) + "Chia sẻ Facebook".
  Trên mobile có `navigator.share` thì gọi native share sheet trước.

---

## 5. Các màn hình

### 5.1 Trang chủ (`/`)

Thứ tự từ trên xuống:
1. **Hero carousel** (mt-6) — mục 4.3
2. **ThemeSection** "Chủ đề" — mục 4.6
3. **ContinueWatching** "Tiếp tục xem" (nếu có) — mục 4.7
4. **Subteam** (nếu có dữ liệu): section glass, header "Subteam", hàng card 160px, badge "Hot"
5. **6 CategorySection** theo thứ tự: **Hành Động · Lãng Mạn · Kinh Dị · Hoạt Hình · Hài · Cổ Trang**
6. **Phim mới cập nhật**: section glass, header, MovieGrid (12+ card, có pagination), badge "Mới"

### 5.2 Trang chi tiết phim (`/phim/{slug}`)

1. **Banner** hero: ảnh `poster_url` w=1600, cao `35vh mobile / 45vh desktop`, Ken Burns,
   gradient tối từ đáy, bo 16px, glass-frame.
2. **Header**: tên phim (20-24px bold) + tên gốc (muted 14px). Hàng nút phải:
   **▶ Trailer** (nếu có) · **RatingBox** (5 sao) · **Share** (tròn) · **Báo lỗi** · **♡ Yêu thích**.
3. **Chips meta** (hàng wrap, gap 8): năm · chất lượng · ngôn ngữ · thời lượng · trạng thái
   (VD "Hoàn Tất") — mỗi cái `glass-chip` 12px. Tiếp: "1.2K lượt xem" · "★ TMDB 8.5"
   (nếu có) · "IMDb" (link ra ngoài) · **"Vietsub độc quyền"** (text hồng, gradient nền
   hồng/xanh nhạt) · "Tập 14" (cùng style).
4. **Nội dung** (`content-card`): h3 "Nội dung" + đoạn text mô tả 14px secondary.
5. **Diễn viên**: "Diễn viên" + chuỗi tên.
6. **Đạo diễn**: "Đạo diễn" + chuỗi tên.
7. **Thể loại**: hàng chip clickable `glass-tile` (tối đa 2 dòng).
8. **Từ khoá**: hàng chip nhỏ `glass-chip` 10px → link search (max 10).
9. **Tập phim** (nếu có): mục 5.4.
10. **Phim tương tự**: h3 "Phim tương tự" + lưới card (max 6, 2 cột mobile).
11. Nút "← Quay lại" (glass-tile).

### 5.3 RatingBox (5 sao)

Cột dọc: 5 ngôi sao (mặc định màu `white/20` = `.star-empty`, khi active = vàng `#FBBF24`
có glow `drop-shadow 0 0 6px rgba(251,191,36,0.5)`) + label "Đánh giá của bạn" (10px muted).
Chọn sao → hover preview; nhấn → lưu `localStorage` (`ratings`), label thành "Bạn: 4/5".
Đã đánh giá → sao luôn vàng theo giá trị.

### 5.4 EpisodeList "Tập phim"

- Hàng server (nếu > 1 server): nút glass-tile, active = `.glass-tile-active` (tim).
- Bên phải: "N tập" (11px muted, `ml-auto`).
- **Lưới tập** trong `content-card`: các ô vuông **48px mobile / 56px desktop**
  (`glass-tile`, số tập, hover trắng). Link → `/xem/{slug}/{epSlug}`.
- **Pagination** tập (nếu nhiều trang, PER_PAGE = 24): giống mục 4.8.

### 5.5 Trang xem phim (`/xem/{slug}/{episode}`)

1. **Player**: container đen 16:9 `rounded-2xl` `glass-frame`.
   - Trạng thái chưa phát: poster `thumb_url` w=1600 phủ đầy + overlay tối 35% +
     nút play tròn glass 64-80px ở giữa (icon "▶" trắng) + pill "Bấm để phát"
     (11px, glass-tile) dưới đáy giữa.
   - Nhấn play → iframe embed (`currentEp.embed`) phủ đầy, autoplay + fullscreen.
   - **Nút "Tập kế tiếp →"** (pill glass, bottom-right, hiện khi có tập tiếp).
   - Phím tắt: **←/→** đổi tập, **F** fullscreen, **Esc** đóng.
2. **Breadcrumb** (`content-card`): Trang chủ / {tên phim} / {tập} (12px, muted, mục cuối trắng).
   + h1: "{Tên phim} - {Tập}" (18px bold).
3. **Server** (nếu > 1): hàng nút glass-tile, active gradient/tím.
4. **Điều hướng tập**: nút **← {tập trước}** · **Danh sách tập** · **Báo lỗi** ·
   **{tập sau} →**. Ở tập đầu/cuối: "← Hết" / "Hết →" (muted, opacity 40%).
5. Tự động thêm vào **"Tiếp tục xem"** (localStorage `recent`).

### 5.6 Trang tìm kiếm (`/search`)

1. **Ô tìm kiếm**: `glass-tile rounded-2xl` chứa icon kính + input trong suốt
   (placeholder "Tìm kiếm phim...") + nút ✕ xoá.
2. **Suggestions**: dropdown `glass-tile` dưới ô (max-h 60vh, scroll) — gợi ý theo từ khoá.
3. **Recent searches**: hàng chip từ khoá đã tìm gần đây (localStorage `recent-searches`).
4. **Filter**: 3 dropdown **Thể loại · Quốc gia · Năm** (nút glass-tile + chevron,
   dropdown `glass-tile w-52 max-h-60` scroll) + nút "✕ Xoá" (hiện khi có filter) +
   **Sắp xếp**: Tên / Năm.
5. Label kết quả: "Kết quả cho \"{q}\"" / "Thể loại: X" / "Phim mới nhất" (12px muted).
6. **Lưới kết quả** (2-8 cột) + pagination. Loading: lưới skeleton shimmer 10 card.

### 5.7 Trang danh sách (`/the-loai/{slug}`, `/danh-sach/{slug}`, `/quoc-gia/{slug}`, `/nam/{slug}`)

- Breadcrumb: Trang chủ / (Danh mục) / {tên}.
- h1: "Hành Động", "Phim Bộ", "Phim Đang Chiếu", ...
- **Bộ lọc** (MovieFilters): chip **Phim bộ / Phim lẻ**, **Đang chiếu / Hoàn thành**,
  select **Năm**, select **Quốc gia** (tùy trang), "Xoá bộ lọc", **Sắp xếp: Mới nhất /
  Năm giảm dần**. Active chip = gradient tím ring (`.glass-tile-active`); sort active =
  nền sáng + chữ trắng (`.sort-active`).
- MovieGrid + pagination.

### 5.8 Yêu thích (`/favorites`) & Đã xem (`/recent`)

- h1: "Phim yêu thích" / "Xem gần đây" (18px semibold).
- Empty: icon + "Chưa có phim yêu thích" / "Chưa có phim" + nút "Khám phá phim".
- Nội dung: lưới card (2-8 cột). Recent lưu slug xem gần nhất, có thể xoá từng item.

### 5.9 Trang tải app (`/download`)

- Center: logo 80px (bo 16px, bóng tím) + h1 "Tải ứng dụng" (30px bold) + mô tả
  "Chọn nền tảng phù hợp..." (14px secondary).
- Badge phiên bản: pill glass "● Phiên bản 1.0.0" (xanh lá).
- Lưới 4 card nền glass-tile bo 16px, mỗi card: icon nền vuông + tên nền tảng + nút
  **"Tải xuống"** (gradient accent, full-width) hoặc "Đang phát triển" (disabled).
  Nền tảng: **Android · iOS · Android TV · LG webOS**. Note phụ + tên file mono.
- Nút "← Quay lại trang chủ".

### 5.10 404

- "404" gradient-text khổng lồ (60px bold) + "Không tìm thấy trang này" + nút "Về trang chủ".

---

## 6. Animation & interaction (nhắc ngắn)

- **Reveal on scroll**: sections nhẹ nhàng `fade-in-up` (opacity 0 → 1, translateY 24px → 0,
  0.7s ease-out, delay theo từng section). Mobile có thể tắt hoặc dùng mức nhẹ.
- **Ken Burns**: ảnh hero/banner zoom `scale 1 → 1.08` trong 9s (GPU transform, rẻ).
- **Hover** (desktop): card nhấc lên + glow, link chuyển gradient text, nút scale nhẹ 1.05.
  Mobile: bỏ hover, dùng trạng thái nhấn (`pressed`).
- Tất cả transition nên ưu tiên **transform/opacity** (GPU-composited), tránh repaint
  layout (background-position, width, margin) — lý do mobile web từng bị lag.
- Tôn trọng `prefers-reduced-motion`.

---

## 7. Data & lưu trữ local

### 7.1 Nguồn dữ liệu

API backend: `https://vsmov.com/api` (xem `web/src/lib/api.ts`, `web/src/lib/types.ts`,
`API phim.md`). App dùng cùng API.

- Homepage: danh sách phim mới, subteam, phim theo thể loại (hành động, lãng mạn, kinh dị,
  hoạt hình, hài, cổ trang).
- Chi tiết: `getMovieDetail(slug)` → movie (nội dung, diễn viên, đạo diễn, thể loại,
  keywords, view, tmdb vote, imdb id, trailer_url, episodes).
- Ảnh: `thumb_url` / `poster_url`. Web resize qua proxy `/img?src=&w=` (webp q75);
  app có thể dùng `cached_network_image` + tự resize nếu cần.

### 7.2 localStorage keys (`web/src/scripts/store.ts`)

| Key | Nội dung |
|---|---|
| `recent` | lịch sử xem: `{id, slug, name, thumb, episode, episodeSlug, watchedAt, tmdb_vote}[]`, max 20, mới nhất trước |
| `favorites` | phim yêu thích: `{id, name, slug, thumb, tmdb_vote}[]` |
| `ratings` | `{slug: điểm}` 1–5 |
| `recent-searches` | từ khoá tìm gần đây, max 8 |
| `phim:mode` | mode hiện tại (`"normal"`) |

---

## 8. Checklist chốt cho mobile

1. Dark theme duy nhất, token màu đúng mục 2.1.
2. Font Be Vietnam Pro self-host, đủ 4 weight.
3. Nền tối gradient + blob mờ, KHÔNG `background-attachment: fixed`.
4. Tất cả panel lớn dùng ngôn ngữ liquid-glass (nền gradient trắng nhẹ + viền trắng +
   inset highlight trên + bóng đen mềm), bo tròn: panel lớn 24px, card nội dung 14px,
   tile 12px, pill tròn.
5. Gradient accent `#FF6B9D → #C44BED → #4A9EFF` cho CTA/badge/active/progress.
6. Khớp từng màn hình mục 5, giữ nguyên thứ tự & nội dung.
7. Empty state đẹp cho mọi danh sách trống.
8. Animation nhẹ, ưu tiên transform/opacity, không làm lag scroll.
9. Lưu local giống key mục 7.2 (đồng bộ dữ liệu nếu chuyển từ web sang app).
10. Test trên thiết bị thật low-end: scroll mượt, không giật.
