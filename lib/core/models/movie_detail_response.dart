import 'movie_detail.dart';

class MovieDetailResponse {
  final bool status;
  final String? message;
  final MovieDetail? movie;

  MovieDetailResponse({
    required this.status,
    this.message,
    this.movie,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    final movieJson = json['movie'] as Map<String, dynamic>?;
    if (movieJson != null && json.containsKey('episodes')) {
      movieJson['episodes'] = json['episodes'];
    }
    return MovieDetailResponse(
      status: json['status'] == true,
      message: json['msg'] as String?,
      movie: movieJson != null ? MovieDetail.fromJson(movieJson) : null,
    );
  }
}
