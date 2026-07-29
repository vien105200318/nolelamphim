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
    return MovieDetailResponse(
      status: json['status'] == true,
      message: json['msg'] as String?,
      movie: json['movie'] != null
          ? MovieDetail.fromJson(json['movie'] as Map<String, dynamic>)
          : null,
    );
  }
}
