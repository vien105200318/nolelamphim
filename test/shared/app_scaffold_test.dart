import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:nolelamphim/shared/widgets/app_scaffold.dart';

void main() {
  testWidgets('nav stays at bottom at phone size, body visible',
      (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: _testRouter()),
    );
    await tester.pump();

    // No overflow / layout exceptions.
    expect(tester.takeException(), isNull);

    final scaffoldRect = tester.getRect(find.byType(Scaffold));
    expect(scaffoldRect.height, 812);

    // Active (home) icon must sit in the bottom nav, not mid-screen.
    final iconRect = tester.getRect(find.byIcon(Icons.home_rounded));
    expect(iconRect.top, greaterThan(700));
    expect(iconRect.bottom, lessThan(scaffoldRect.bottom));

    // Body content must be on screen.
    final bodyText = tester.getRect(find.text('BODY CONTENT HERE'));
    expect(bodyText.height, greaterThan(0));
    expect(bodyText.bottom, lessThan(iconRect.top));
  });

  testWidgets('nav tabs navigate', (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: _testRouter()),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH BODY'), findsOneWidget);
  });
}

RouterConfig<Object> _testRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppScaffold(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const ColoredBox(
                color: Color(0xFF0A0A14),
                child: Center(
                  child: Text(
                    'BODY CONTENT HERE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/search',
              builder: (_, _) => const Center(
                child: Text(
                  'SEARCH BODY',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GoRoute(
              path: '/category',
              builder: (_, _) => const Text('category body'),
            ),
            GoRoute(
              path: '/favorites',
              builder: (_, _) => const Text('favorites body'),
            ),
            GoRoute(
              path: '/history',
              builder: (_, _) => const Text('history body'),
            ),
          ],
        ),
      ],
    );
