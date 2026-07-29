Tổng quan api

### Bộ lệnh kiểm thử nhanh

Dùng trực tiếp trên terminal để xác thực API hoạt động.

```
curl -s "https://vsmov.com/api/danh-sach/phim-moi-cap-nhat?page=1" | head -c 400
curl -s "https://vsmov.com/api/danh-sach/subteam?page=1&limit=5" | head -c 400
curl -s "https://vsmov.com/api/tim-kiem?keyword=avengers&limit=5" | head -c 400
curl -s "https://vsmov.com/api/phim/mau-xanh-cuoi-cung" | head -c 400
```

Các endpoint public đều dùng prefix `/api`, trả về JSON và không cần token.

### Checklist “chuẩn chỉnh”

- Đảm bảo `APP_URL` đúng, đã `php artisan storage:link`.
- Kiểm thử 4 nhóm: trang chủ, bộ lọc, tìm kiếm, chi tiết phim.
- Đối chiếu JSON: trường `name`, `slug`, `thumb_url`, `poster_url`, `episodes` nếu endpoint có chi tiết phim.
- Kiểm tra mã trạng thái HTTP = 200, header `content-type: application/json`.

Base API URL:

https://vsmov.com/api

Định dạng dữ liệu:

JSON

Mã hóa:

UTF-8

Phương thức HTTP:

GET

### Dữ liệu phim

- • Thông tin chi tiết phim
- • Hình ảnh HD từ TMDB
- • Thông tin diễn viên, đạo diễn
- • Tập phim và server phát nếu endpoint chi tiết có dữ liệu

### Tìm kiếm & Lọc

- • Tìm kiếm theo từ khóa
- • Lọc theo thể loại, quốc gia
- • Sắp xếp theo nhiều tiêu chí
- • Phân trang linh hoạt




danh sách phim homepage

```
curl --request GET \
  --url https://vsmov.com/api/danh-sach/phim-moi-cap-nhat?page=1 \
  --header 'accept: application/json'
```

danh sách phim 
```
curl --request GET \
  --url https://vsmov.com/api/danh-sach/subteam \
  --header 'accept: application/json'
```

tìm kiếm phim

```
curl --request GET \
  --url https://vsmov.com/api/tim-kiem?keyword=avengers&limit=20&page=1 \
  --header 'accept: application/json'
```

danh sách thể loại 

```
curl --request GET \
  --url https://vsmov.com/api/the-loai \
  --header 'accept: application/json'
```

phim theo thể loại 
```
curl --request GET \
  --url https://vsmov.com/api/the-loai/hanh-dong?limit=20&page=1&year=2024&country=han-quoc&type=series&status=completed \
  --header 'accept: application/json'
```

danh sách quốc gia

```
curl --request GET \
  --url https://vsmov.com/api/quoc-gia \
  --header 'accept: application/json'
```

phim theo quốc gia 
```
curl --request GET \
  --url https://vsmov.com/api/quoc-gia/nhat-ban?limit=20&page=1&year=2024&type=series&status=completed \
  --header 'accept: application/json'
```

danh sách năm đã phát hành 

```
curl --request GET \
  --url https://vsmov.com/api/nam \
  --header 'accept: application/json'
```

phim theo năm phát hành 

```
curl --request GET \
  --url https://vsmov.com/api/nam/2024?limit=20&page=1&type=series&status=completed \
  --header 'accept: application/json'
```

thông tin phim 

```
curl --request GET \
  --url https://vsmov.com/api/phim/mau-xanh-cuoi-cung \
  --header 'accept: application/json'
```


diễn viên 
```
curl --request GET \
  --url https://vsmov.com/api/dien-vien \
  --header 'accept: application/json'
```


