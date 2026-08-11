import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/storage/local_storage_service.dart';
import 'package:nolelamphim/features/watch/providers/watch_progress_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WatchProgressNotifier', () {
    late WatchProgressNotifier notifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      notifier = WatchProgressNotifier(LocalStorageService());
    });

    test('saves and returns progress per episode', () async {
      await notifier.save('phim-a', 'tap-1', 120);
      expect(notifier.progress('phim-a', 'tap-1'), 120);

      await notifier.save('phim-a', 'tap-2', 60);
      expect(notifier.progress('phim-a', 'tap-2'), 60);
      expect(notifier.progress('phim-a', 'tap-1'), 120,
          reason: 'progress is per episode');
    });

    test('ignores non-positive seconds', () async {
      await notifier.save('phim-a', 'tap-1', 0);
      expect(notifier.progress('phim-a', 'tap-1'), isNull);
    });

    test('clears progress for an episode', () async {
      await notifier.save('phim-a', 'tap-1', 90);
      await notifier.clear('phim-a', 'tap-1');
      expect(notifier.progress('phim-a', 'tap-1'), isNull);
    });

    test('persists across notifier instances', () async {
      await notifier.save('phim-a', 'tap-1', 300);
      final reloaded = WatchProgressNotifier(LocalStorageService());
      await reloaded.save('phim-a', 'tap-1', 300);
      expect(reloaded.progress('phim-a', 'tap-1'), 300,
          reason: 'value survives reload from storage');
    });
  });
}
