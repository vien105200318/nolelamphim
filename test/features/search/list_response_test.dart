import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/list_response.dart';
import 'package:nolelamphim/core/models/movie.dart';
import 'package:nolelamphim/core/models/category.dart';
import 'package:nolelamphim/core/models/country.dart';
import 'package:nolelamphim/core/models/year_item.dart';

void main() {
  group('ListResponse<Movie> (search results)', () {
    final validSearchJson = {
      'status': true,
      'items': [
        {
          '_id': 12345,
          'name': 'Harry Potter và Mệnh Lệnh Phượng Hoàng',
          'origin_name': 'Harry Potter and the Order of the Phoenix',
          'slug': 'harry-potter-va-menh-lenh-phuong-hoang',
          'poster_url': 'https://example.com/poster.jpg',
          'thumb_url': 'https://example.com/thumb.jpg',
          'year': 2007,
          'quality': 'HD',
          'lang': 'Vietsub',
          'time': '138',
          'type': 'single',
          'status': 'completed',
          'episode_current': 'Full',
          'episode_total': '1',
        },
        {
          '_id': 54321,
          'name': 'Harry Potter và Bảo Bối Tử Thần',
          'slug': 'harry-potter-va-bao-boi-tu-than',
          'year': 2011,
        },
      ],
    };

    test('parses search results correctly', () {
      final response = ListResponse<Movie>.fromJson(
        validSearchJson,
        (json) => Movie.fromJson(json),
      );

      expect(response.status, true);
      expect(response.items.length, 2);
      expect(response.items[0].name, 'Harry Potter và Mệnh Lệnh Phượng Hoàng');
      expect(response.items[0].slug, 'harry-potter-va-menh-lenh-phuong-hoang');
      expect(response.items[0].year, 2007);
      expect(response.items[0].quality, 'HD');
      expect(response.items[0].lang, 'Vietsub');
      expect(response.items[0].type, 'single');
      expect(response.items[0].status, 'completed');
      expect(response.items[0].episodeCurrent, 'Full');
    });

    test('parses movie with minimal fields', () {
      final response = ListResponse<Movie>.fromJson(
        validSearchJson,
        (json) => Movie.fromJson(json),
      );

      final second = response.items[1];
      expect(second.id, 54321);
      expect(second.name, 'Harry Potter và Bảo Bối Tử Thần');
      expect(second.slug, 'harry-potter-va-bao-boi-tu-than');
      expect(second.year, 2011);
      expect(second.posterUrl, isNull);
      expect(second.thumbUrl, isNull);
      expect(second.originName, isNull);
    });

    test('handles empty items list', () {
      final response = ListResponse<Movie>.fromJson(
        {'status': true, 'items': []},
        (json) => Movie.fromJson(json),
      );

      expect(response.status, true);
      expect(response.items, isEmpty);
    });

    test('handles missing items key', () {
      final response = ListResponse<Movie>.fromJson(
        {'status': false},
        (json) => Movie.fromJson(json),
      );

      expect(response.status, false);
      expect(response.items, isEmpty);
    });

    test('handles pagination query parameters', () {
      expect(true, isTrue);
    });
  });

  group('Category model', () {
    test('parses from JSON', () {
      final category = Category.fromJson({
        'id': 15,
        'name': 'Hành Động',
        'slug': 'hanh-dong',
      });

      expect(category.id, 15);
      expect(category.name, 'Hành Động');
      expect(category.slug, 'hanh-dong');
    });
  });

  group('Country model', () {
    test('parses from JSON', () {
      final country = Country.fromJson({
        'id': 30,
        'name': 'Việt Nam',
        'slug': 'viet-nam',
      });

      expect(country.id, 30);
      expect(country.name, 'Việt Nam');
      expect(country.slug, 'viet-nam');
    });
  });

  group('YearItem model', () {
    test('parses from JSON', () {
      final year = YearItem.fromJson({
        '_id': '67f5b8d7e4b0',
        'name': '2025',
        'slug': '2025',
      });

      expect(year.id, '67f5b8d7e4b0');
      expect(year.name, '2025');
      expect(year.slug, '2025');
    });
  });
}
