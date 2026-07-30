import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/storage/local_storage_service.dart';
import 'package:nolelamphim/features/favorites/providers/history_provider.dart';

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

  group('HistoryProvider', () {
    test('starts empty', () {
      final list = container.read(historyProvider);
      expect(list, isEmpty);
    });

    test('adds item to history', () async {
      final item = HistoryItem(
        id: 1,
        slug: 'test-movie',
        name: 'Test Movie',
        episode: 'tap-1',
        watchedAt: 1000,
      );
      await container.read(historyProvider.notifier).add(item);
      final list = container.read(historyProvider);
      expect(list.length, 1);
      expect(list[0].slug, 'test-movie');
      expect(list[0].episode, 'tap-1');
    });

    test('deduplicates by slug', () async {
      final item1 = HistoryItem(
        id: 1, slug: 'test-movie', name: 'Test', episode: 'tap-1', watchedAt: 1000,
      );
      final item2 = HistoryItem(
        id: 1, slug: 'test-movie', name: 'Test', episode: 'tap-2', watchedAt: 2000,
      );
      final notifier = container.read(historyProvider.notifier);
      await notifier.add(item1);
      await notifier.add(item2);

      final list = container.read(historyProvider);
      expect(list.length, 1);
      expect(list[0].episode, 'tap-2');
    });

    test('caps at 20 items', () async {
      final notifier = container.read(historyProvider.notifier);
      for (int i = 0; i < 25; i++) {
        await notifier.add(HistoryItem(
          id: i, slug: 'movie-$i', name: 'Movie $i', episode: 'tap-1', watchedAt: i,
        ));
      }
      expect(container.read(historyProvider).length, 20);
    });
  });
}
