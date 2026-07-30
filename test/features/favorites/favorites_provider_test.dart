import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/movie.dart';
import 'package:nolelamphim/core/storage/local_storage_service.dart';
import 'package:nolelamphim/features/favorites/providers/favorites_provider.dart';

class MockStorage extends LocalStorageService {
  final Map<String, List<Map<String, dynamic>>> _data = {};

  @override
  Future<List<Map<String, dynamic>>> readList(String key) async {
    return _data[key] ?? [];
  }

  @override
  Future<void> writeList(String key, List<Map<String, dynamic>> items) async {
    _data[key] = items;
  }
}

void main() {
  late MockStorage mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockStorage();
    container = ProviderContainer(
      overrides: [
        localStorageServiceProvider.overrideWith((ref) => mockStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FavoritesProvider', () {
    test('starts empty', () {
      final list = container.read(favoritesProvider);
      expect(list, isEmpty);
    });

    test('adds movie to favorites', () async {
      final movie = Movie(id: 1, name: 'Test', slug: 'test', year: 2024);
      await container.read(favoritesProvider.notifier).toggle(movie);
      final list = container.read(favoritesProvider);
      expect(list.length, 1);
      expect(list[0].slug, 'test');
    });

    test('removes movie from favorites', () async {
      final movie = Movie(id: 1, name: 'Test', slug: 'test', year: 2024);
      final notifier = container.read(favoritesProvider.notifier);
      await notifier.toggle(movie);
      expect(container.read(favoritesProvider).length, 1);

      await notifier.toggle(movie);
      expect(container.read(favoritesProvider), isEmpty);
    });

    test('isFavorite checks correctly', () async {
      final movie = Movie(id: 1, name: 'Test', slug: 'test', year: 2024);
      final notifier = container.read(favoritesProvider.notifier);
      expect(notifier.isFavorite(1), false);

      await notifier.toggle(movie);
      expect(notifier.isFavorite(1), true);
      expect(notifier.isFavorite(2), false);
    });

    test('persists across provider recreation', () async {
      final movie = Movie(id: 1, name: 'Test', slug: 'test', year: 2024);
      await container.read(favoritesProvider.notifier).toggle(movie);

      final container2 = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWith((ref) => mockStorage),
        ],
      );
      await container2.read(favoritesProvider.notifier).ready;
      final list = container2.read(favoritesProvider);
      expect(list.length, 1);
      expect(list[0].slug, 'test');
      container2.dispose();
    });
  });
}
