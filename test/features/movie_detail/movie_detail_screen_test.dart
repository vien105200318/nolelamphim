import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie_detail_response.dart';

void main() {
  group('MovieDetailScreen dependencies', () {
    test('MovieDetailResponse model parses correctly', () {
      final json = {
        'status': true,
        'msg': '',
        'movie': {
          '_id': 1,
          'name': 'Test Movie',
          'slug': 'test-movie',
          'episodes': [],
        },
      };

      final response = MovieDetailResponse.fromJson(json);
      expect(response.status, true);
      expect(response.movie, isNotNull);
      expect(response.movie!.name, 'Test Movie');
    });
  });
}
