import 'package:flutter_test/flutter_test.dart';
import 'package:anime_quotes/main.dart';
import 'package:anime_quotes/widgets/anime_logo.dart';
import 'package:anime_quotes/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('AnimeQuotesApp renders AppBar and Logo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AnimeQuotesApp());

    // Expect the AnimeLogo to be in the widget tree
    expect(find.byType(AnimeLogo), findsOneWidget);
  });

  testWidgets('SearchBarWidget renders correctly standalone',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(),
        ),
      ),
    );

    expect(find.byType(SearchBarWidget), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });
}
