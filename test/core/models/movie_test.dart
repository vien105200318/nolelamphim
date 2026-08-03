import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie.dart';

void main() {
  group('Movie.fromJson', () {
    final baseJson = {
      '_id': 1,
      'name': 'Test',
      'slug': 'test',
    };

    test('parses valid JSON correctly', () {
      final json = {
        ...baseJson,
        'poster_url': 'https://example.com/poster.jpg',
        'thumb_url': 'https://example.com/thumb.jpg',
        'year': 2026,
        'quality': 'HD',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 1);
      expect(movie.name, 'Test');
      expect(movie.slug, 'test');
      expect(movie.posterUrl, 'https://example.com/poster.jpg');
      expect(movie.thumbUrl, 'https://example.com/thumb.jpg');
      expect(movie.year, 2026);
      expect(movie.quality, 'HD');
    });

    test('handles non-string thumb_url gracefully', () {
      final json = {
        ...baseJson,
        'thumb_url': {},
      };

      final movie = Movie.fromJson(json);

      expect(movie.thumbUrl, isNull);
    });

    test('handles non-string poster_url gracefully', () {
      final json = {
        ...baseJson,
        'poster_url': {'broken': true},
      };

      final movie = Movie.fromJson(json);

      expect(movie.posterUrl, isNull);
    });

    test('handles non-string optional string fields gracefully', () {
      final json = {
        ...baseJson,
        'origin_name': {'broken': true},
        'quality': ['broken'],
        'lang': 123,
        'time': {'broken': true},
        'type': false,
        'status': {'broken': true},
        'episode_current': {'broken': true},
        'episode_total': {'broken': true},
      };

      final movie = Movie.fromJson(json);

      expect(movie.originName, isNull);
      expect(movie.quality, isNull);
      expect(movie.lang, isNull);
      expect(movie.time, isNull);
      expect(movie.type, isNull);
      expect(movie.status, isNull);
      expect(movie.episodeCurrent, isNull);
      expect(movie.episodeTotal, isNull);
    });

    test('preserves missing optional fields as null', () {
      final movie = Movie.fromJson(baseJson);

      expect(movie.posterUrl, isNull);
      expect(movie.thumbUrl, isNull);
      expect(movie.year, isNull);
    });
  });
}
