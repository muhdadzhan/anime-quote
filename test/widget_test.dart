import 'package:flutter_test/flutter_test.dart';
import 'package:anime_quotes/main.dart';
import 'package:anime_quotes/widgets/anime_logo.dart';
import 'package:anime_quotes/widgets/search_bar_widget.dart';

void main() {
  testWidgets('AnimeQuotesApp renders AppBar, Logo, and SearchBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AnimeQuotesApp());

    // Expect the AnimeLogo to be in the widget tree
    expect(find.byType(AnimeLogo), findsOneWidget);

    // Expect search bar widget to be rendered
    expect(find.byType(SearchBarWidget), findsOneWidget);
  });
}
