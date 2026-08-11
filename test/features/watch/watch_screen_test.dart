import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/core/models/episode.dart';
import 'package:nolelamphim/core/models/movie.dart' show TMDbInfo;
import 'package:nolelamphim/core/models/movie_detail.dart';
import 'package:nolelamphim/features/watch/providers/watch_provider.dart';
import 'package:nolelamphim/features/watch/screens/watch_screen.dart';

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

  testWidgets(
      'watch screen with data: no flex-unbounded layout error (regression)',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 2.625;
    tester.view.padding = const FakeViewPadding(bottom: 24);
    addTearDown(tester.view.reset);

    final detail = MovieDetail(
      id: 1,
      name: 'Những Cuộc Phiêu Lưu Cùng Superman - Phần 2',
      slug: 'test',
      posterUrl: 'https://example.com/poster.jpg',
      episodes: [
        EpisodeServer(
          serverName: 'Server #1',
          serverData: List.generate(
            10,
            (i) => EpisodeData(
              name: 'Tập ${i + 1}',
              slug: 'tap-${i + 1}',
              linkEmbed: 'https://example.com/${i + 1}',
            ),
          ),
        ),
        EpisodeServer(
          serverName: 'Server #2 HD',
          serverData: List.generate(
            10,
            (i) => EpisodeData(
              name: 'Tập ${i + 1}',
              slug: 'tap-${i + 1}',
              linkEmbed: 'https://example.com/2/${i + 1}',
            ),
          ),
        ),
      ],
      tmdb: const TMDbInfo(voteAverage: '6.3', voteCount: 262),
    );
    final watchData = WatchData(movie: detail, serverIndex: 0, episodeIndex: 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          watchDataProvider.overrideWith((ref, params) async => watchData),
          watchProvider.overrideWith(
            (ref, params) async => 'https://example.com/master.m3u8',
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WatchScreen(
            slug: 'test',
            episode: 'tap-1',
            movieName: 'Test Movie',
          ),
        ),
      ),
    );

    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      final ex = tester.takeException();
      if (ex != null) fail('Watch layout exception at pump $i: $ex');
    }
    await tester.pumpAndSettle();

    final ex = tester.takeException();
    expect(ex, isNull, reason: 'Layout exception on watch: $ex');
    debugDefaultTargetPlatformOverride = null;
  });
}
