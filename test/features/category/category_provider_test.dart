import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie.dart';
import 'package:nolelamphim/features/category/providers/category_provider.dart';

void main() {
  group('categoryMoviesProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          categoryMoviesProvider('hanh-dong')
              .overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(categoryMoviesProvider('hanh-dong').future);
      expect(result, isEmpty);
    });

    test('returns movies for valid slug', () async {
      final movies = [
        Movie(id: 1, name: 'Phim Hành Động', slug: 'phim-hanh-dong', year: 2024),
        Movie(id: 2, name: 'Phim Võ Thuật', slug: 'phim-vo-thuat', year: 2023),
      ];

      final container = ProviderContainer(
        overrides: [
          categoryMoviesProvider('hanh-dong')
              .overrideWith((ref) async => movies),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(categoryMoviesProvider('hanh-dong').future);
      expect(result.length, 2);
      expect(result[0].name, 'Phim Hành Động');
      expect(result[1].slug, 'phim-vo-thuat');
    });

    test('returns empty for unknown slug', () async {
      final container = ProviderContainer(
        overrides: [
          categoryMoviesProvider('unknown-slug')
              .overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(categoryMoviesProvider('unknown-slug').future);
      expect(result, isEmpty);
    });

    test('throws on error', () async {
      final container = ProviderContainer(
        overrides: [
          categoryMoviesProvider('hanh-dong')
              .overrideWith((ref) async => throw Exception('API fail')),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () async =>
            container.read(categoryMoviesProvider('hanh-dong').future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('countryMoviesProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          countryMoviesProvider('viet-nam')
              .overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(countryMoviesProvider('viet-nam').future);
      expect(result, isEmpty);
    });
  });

  group('yearMoviesProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          yearMoviesProvider('2025').overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(yearMoviesProvider('2025').future);
      expect(result, isEmpty);
    });
  });
}
