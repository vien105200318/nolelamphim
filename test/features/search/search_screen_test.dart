import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nolelamphim/features/home/providers/home_provider.dart';
import 'package:nolelamphim/features/search/screens/search_screen.dart';
import 'package:nolelamphim/features/search/providers/search_provider.dart';

void main() {
  group('SearchScreen', () {
    testWidgets('renders search bar and filter chips', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchPagedProvider.overrideWith(
              (ref) async => const PagedMovies(items: [], totalPages: 1),
            ),
            categoriesProvider.overrideWith((ref) async => []),
            countriesProvider.overrideWith((ref) async => []),
            yearsProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(home: SearchScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Thể loại'), findsWidgets);
      expect(find.text('Quốc gia'), findsWidgets);
      expect(find.text('Năm'), findsWidgets);
      expect(find.text('Phim mới nhất'), findsOneWidget);
    });

    testWidgets('typing shows clear button on TextField', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            searchPagedProvider.overrideWith(
              (ref) async => const PagedMovies(items: [], totalPages: 1),
            ),
            categoriesProvider.overrideWith((ref) async => []),
            countriesProvider.overrideWith((ref) async => []),
            yearsProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(home: SearchScreen()),
        ),
      );
      await tester.pump();

      // Type in the search field
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'new query');
      await tester.pump();

      // Clear icon appears (Icons.clear)
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });
}
