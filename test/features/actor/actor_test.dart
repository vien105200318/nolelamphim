import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/features/actor/models/actor.dart';

void main() {
  group('Actor.fromJson', () {
    test('parses valid JSON correctly', () {
      final actor = Actor.fromJson({
        '_id': 42781,
        'name': 'Jackie Chan',
        'slug': 'jackie-chan',
        'thumb_url': 'https://image.tmdb.org/t/p/w500/abc.jpg',
      });

      expect(actor.id, 42781);
      expect(actor.name, 'Jackie Chan');
      expect(actor.slug, 'jackie-chan');
      expect(actor.thumbUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    });

    test('handles missing optional fields as null', () {
      final actor = Actor.fromJson({
        '_id': 2186,
        'name': 'Ice Poa',
        'slug': 'ice-poa',
      });

      expect(actor.id, 2186);
      expect(actor.thumbUrl, isNull);
    });

    test('handles non-numeric _id gracefully', () {
      final actor = Actor.fromJson({
        '_id': 'abc',
        'name': 'Test',
        'slug': 'test',
      });

      expect(actor.id, 0);
    });

    test('initials built from name', () {
      expect(Actor.fromJson({'_id': 1, 'name': 'Jackie Chan', 'slug': 'j'}).initials, 'JC');
      expect(Actor.fromJson({'_id': 1, 'name': 'Ice Poa', 'slug': 'i'}).initials, 'IP');
      expect(Actor.fromJson({'_id': 1, 'name': '2 Chainz', 'slug': '2'}).initials, '2C');
    });
  });
}
