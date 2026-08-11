import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/features/actor/models/actor.dart';
import 'package:nolelamphim/features/actor/providers/actor_provider.dart';

void main() {
  group('actorsProvider', () {
    test('returns empty list when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          actorsProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(actorsProvider.future);
      expect(result, isEmpty);
    });

    test('returns actors for valid data', () async {
      final actors = [
        Actor(id: 1, name: 'Jackie Chan', slug: 'jackie-chan'),
        Actor(id: 2, name: 'Tony Leung', slug: 'tony-leung'),
      ];

      final container = ProviderContainer(
        overrides: [
          actorsProvider.overrideWith((ref) async => actors),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(actorsProvider.future);
      expect(result.length, 2);
      expect(result[0].name, 'Jackie Chan');
      expect(result[1].slug, 'tony-leung');
    });
  });
}
