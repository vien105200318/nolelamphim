import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie_detail_response.dart';

void main() {
  group('MovieDetailResponse', () {
    final validJson = {
      'status': true,
      'msg': '',
      'movie': {
        '_id': 41383,
        'name': 'Màu Xanh Cuối Cùng',
        'origin_name': 'O Último Azul',
        'slug': 'mau-xanh-cuoi-cung',
        'content': 'A journey along the Amazon.',
        'type': 'single',
        'status': 'trailer',
        'poster_url': 'https://example.com/poster.jpg',
        'thumb_url': 'https://example.com/thumb.jpg',
        'year': 2025,
        'time': '86',
        'episode_current': 'Trailer',
        'episode_total': null,
        'quality': 'HD',
        'lang': 'Vietsub',
        'actor': ['Denise Weinberg', 'Rodrigo Santoro'],
        'director': ['Gabriel Mascaro'],
        'category': [
          {'_id': 15, 'name': 'Chính Kịch', 'slug': 'chinh-kich'}
        ],
        'country': [
          {'_id': 30, 'name': 'Brazil', 'slug': 'brazil'}
        ],
      },
      'episodes': [
        {
          'server_name': 'Vietsub #1',
          'server_data': [
            {
              'name': '1',
              'slug': 'tap-1',
              'filename': '1',
              'link_embed': 'https://example.com/video.mp4'
            }
          ]
        }
      ],
    };

    test('parses valid JSON correctly', () {
      final response = MovieDetailResponse.fromJson(validJson);

      expect(response.status, true);
      expect(response.message, '');
      expect(response.movie, isNotNull);

      final movie = response.movie!;
      expect(movie.id, 41383);
      expect(movie.name, 'Màu Xanh Cuối Cùng');
      expect(movie.originName, 'O Último Azul');
      expect(movie.slug, 'mau-xanh-cuoi-cung');
      expect(movie.content, 'A journey along the Amazon.');
      expect(movie.type, 'single');
      expect(movie.status, 'trailer');
      expect(movie.posterUrl, 'https://example.com/poster.jpg');
      expect(movie.thumbUrl, 'https://example.com/thumb.jpg');
      expect(movie.year, 2025);
      expect(movie.time, '86');
      expect(movie.episodeCurrent, 'Trailer');
      expect(movie.episodeTotal, null);
      expect(movie.quality, 'HD');
      expect(movie.lang, 'Vietsub');
    });

    test('parses actors and directors', () {
      final response = MovieDetailResponse.fromJson(validJson);
      final movie = response.movie!;

      expect(movie.actors, ['Denise Weinberg', 'Rodrigo Santoro']);
      expect(movie.directors, ['Gabriel Mascaro']);
    });

    test('parses category and country', () {
      final response = MovieDetailResponse.fromJson(validJson);
      final movie = response.movie!;

      expect(movie.categories.length, 1);
      expect(movie.categories[0].name, 'Chính Kịch');
      expect(movie.categories[0].slug, 'chinh-kich');

      expect(movie.countries.length, 1);
      expect(movie.countries[0].name, 'Brazil');
      expect(movie.countries[0].slug, 'brazil');
    });

    test('parses episodes with server data', () {
      final response = MovieDetailResponse.fromJson(validJson);
      final movie = response.movie!;

      expect(movie.episodes.length, 1);
      expect(movie.episodes[0].serverName, 'Vietsub #1');
      expect(movie.episodes[0].serverData.length, 1);
      expect(movie.episodes[0].serverData[0].name, '1');
      expect(movie.episodes[0].serverData[0].slug, 'tap-1');
      expect(movie.episodes[0].serverData[0].linkEmbed,
          'https://example.com/video.mp4');
    });

    test('handles missing optional fields gracefully', () {
      final minimalJson = {
        'status': false,
        'movie': {
          '_id': 1,
          'name': 'Test',
          'slug': 'test',
        },
      };

      final response = MovieDetailResponse.fromJson(minimalJson);
      expect(response.status, false);
      expect(response.movie, isNotNull);
      expect(response.movie!.name, 'Test');
      expect(response.movie!.actors, isEmpty);
      expect(response.movie!.directors, isEmpty);
      expect(response.movie!.categories, isEmpty);
      expect(response.movie!.countries, isEmpty);
      expect(response.movie!.episodes, isEmpty);
    });
  });
}
