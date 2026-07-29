class ApiEndpoints {
  ApiEndpoints._();

  static const String base = '/api';

  static const String newMovies = '$base/danh-sach/phim-moi-cap-nhat';
  static const String subteam = '$base/danh-sach/subteam';
  static const String search = '$base/tim-kiem';
  static const String categories = '$base/the-loai';
  static const String countries = '$base/quoc-gia';
  static const String years = '$base/nam';
  static const String actors = '$base/dien-vien';

  static String movieDetail(String slug) => '$base/phim/$slug';
  static String categoryMovies(String slug) => '$base/the-loai/$slug';
  static String countryMovies(String slug) => '$base/quoc-gia/$slug';
  static String yearMovies(String year) => '$base/nam/$year';
}
