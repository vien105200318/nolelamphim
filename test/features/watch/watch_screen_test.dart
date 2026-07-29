import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/features/watch/providers/watch_provider.dart';

void main() {
  group('WatchParams', () {
    test('equality works correctly', () {
      final a = WatchParams(movieSlug: 'test', episodeSlug: 'tap-1');
      final b = WatchParams(movieSlug: 'test', episodeSlug: 'tap-1');
      final c = WatchParams(movieSlug: 'test', episodeSlug: 'tap-2');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('supports empty slugs', () {
      final params = WatchParams(movieSlug: '', episodeSlug: '');
      expect(params.movieSlug, '');
      expect(params.episodeSlug, '');
    });
  });
}
