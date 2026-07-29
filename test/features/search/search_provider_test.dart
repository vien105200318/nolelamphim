import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie.dart';
import 'package:nolelamphim/features/search/providers/search_provider.dart';

void main() {
  group('searchQueryProvider', () {
    test('starts empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(searchQueryProvider), '');
    });

    test('can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'harry';
      expect(container.read(searchQueryProvider), 'harry');
    });
  });

  group('searchResultsProvider', () {
    test('returns empty list when query is empty', () async {
      final container = ProviderContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => ''),
          searchResultsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchResultsProvider.future);
      expect(result, isEmpty);
    });

    test('returns movies for valid query', () async {
      final movies = [
        Movie(id: 1, name: 'Test Movie', slug: 'test-movie', year: 2024),
      ];

      final container = ProviderContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => 'test'),
          searchResultsProvider.overrideWith((ref) async => movies),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchResultsProvider.future);
      expect(result.length, 1);
      expect(result[0].name, 'Test Movie');
    });

    test('returns empty when query has no results', () async {
      final container = ProviderContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => 'zzzzz'),
          searchResultsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchResultsProvider.future);
      expect(result, isEmpty);
    });

    test('throws on error', () async {
      final container = ProviderContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => 'error'),
          searchResultsProvider.overrideWith(
            (ref) async => throw Exception('API fail'),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () async => container.read(searchResultsProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('categoriesProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          categoriesProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(categoriesProvider.future);
      expect(result, isEmpty);
    });
  });

  group('countriesProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          countriesProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(countriesProvider.future);
      expect(result, isEmpty);
    });
  });

  group('yearsProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          yearsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(yearsProvider.future);
      expect(result, isEmpty);
    });
  });
}
