# webOS TV App — Nô Lệ Làm Phim

Web app wrapper cho LG webOS TV. Chạy Next.js app trong iframe + xử lý remote TV.

## Yêu cầu

- [webOS TV SDK (CLI)](https://webostv.developer.lge.com/develop/tools/cli-introduction) — `ares` commands
- Simulator (đã có ở `~/Download/webOS_TV_26_Simulator_1.5.0`)

## Cấu trúc

```
webos/
├── appinfo.json          # metadata app
├── index.html            # entry point (iframe + loader)
├── icon.svg              # icon 80x80
├── icon_130.svg          # icon 130x130
└── README.md
```

## Build IPK

```bash
# Đóng gói app
ares-package webos/

# Cài lên simulator
ares-install --device simulator com.nolelamphim.webos_1.0.0_all.ipk

# Chạy
ares-launch --device simulator com.nolelamphim.webos
```

## Dev

`index.html` hiện load app từ `https://nolelamphim.vercel.app`. Muốn trỏ local:

1. Start Next.js dev: `cd web && npm run dev`
2. Sửa `index.html` → `src` thành `http://<IP>:3000`
3. Repackage & install

## Remote Control

Phím remote webOS được forward vào web app qua `postMessage` → `web/src/lib/webos.ts`:
- **Lên/Xuống/Trái/Phải** → Arrow keys
- **OK** → Enter
- **Back** → history.back()
