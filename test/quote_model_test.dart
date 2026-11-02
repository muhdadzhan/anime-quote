import 'package:flutter_test/flutter_test.dart';
import 'package:anime_quotes/models/quote_model.dart';

void main() {
  group('Quote Model Tests', () {
    test('Correctly parses single quote JSON from Animechan API v1', () {
      final json = {
        "content": "The lifespan of a human is certainly way too short.",
        "anime": {
          "id": 311,
          "name": "Akame ga Kill!",
          "altName": "Akame ga Kill!"
        },
        "character": {
          "id": 483,
          "name": "Leone"
        }
      };

      final quote = Quote.fromJson(json);

      expect(quote.content, "The lifespan of a human is certainly way too short.");
      expect(quote.character, "Leone");
      expect(quote.characterId, 483);
      expect(quote.anime, "Akame ga Kill!");
      expect(quote.animeId, 311);
    });

    test('Correctly falls back when anime and character are simple strings', () {
      final json = {
        "content": "Power comes in response to a need, not a desire.",
        "anime": "Dragon Ball Z",
        "character": "Goku"
      };

      final quote = Quote.fromJson(json);

      expect(quote.content, "Power comes in response to a need, not a desire.");
      expect(quote.character, "Goku");
      expect(quote.anime, "Dragon Ball Z");
    });

    test('Fallback quote is valid', () {
      final fallback = Quote.fallback();
      expect(fallback.content.isNotEmpty, isTrue);
      expect(fallback.character, "Saitama");
      expect(fallback.anime, "One Punch Man");
    });
  });
}
