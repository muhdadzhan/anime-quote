/// Model class representing an Anime Quote from the Animechan API.
///
/// Handles response schema:
/// data: {
///   content: "quote text",
///   anime: { id: 311, name: "Anime Name", altName: "..." },
///   character: { id: 483, name: "Character Name" }
/// }
class Quote {
  final String content;
  final String character;
  final int? characterId;
  final String anime;
  final String? animeAlt;
  final int? animeId;

  const Quote({
    required this.content,
    required this.character,
    this.characterId,
    required this.anime,
    this.animeAlt,
    this.animeId,
  });

  /// Factory constructor to parse quote from JSON map
  factory Quote.fromJson(Map<String, dynamic> json) {
    // Parse Anime object (or fallback string)
    String animeName = 'Unknown Anime';
    String? animeAlt;
    int? animeId;
    if (json['anime'] is Map) {
      final animeMap = json['anime'] as Map<String, dynamic>;
      animeName = animeMap['name']?.toString() ?? 'Unknown Anime';
      animeAlt = animeMap['altName']?.toString();
      animeId = animeMap['id'] is int ? animeMap['id'] as int : null;
    } else if (json['anime'] is String) {
      animeName = json['anime'] as String;
    }

    // Parse Character object (or fallback string)
    String characterName = 'Unknown Character';
    int? characterId;
    if (json['character'] is Map) {
      final charMap = json['character'] as Map<String, dynamic>;
      characterName = charMap['name']?.toString() ?? 'Unknown Character';
      characterId = charMap['id'] is int ? charMap['id'] as int : null;
    } else if (json['character'] is String) {
      characterName = json['character'] as String;
    }

    // Parse quote content
    final quoteText = json['content']?.toString() ?? json['quote']?.toString() ?? '';

    return Quote(
      content: quoteText.trim(),
      character: characterName.trim(),
      characterId: characterId,
      anime: animeName.trim(),
      animeAlt: animeAlt,
      animeId: animeId,
    );
  }

  /// Helper factory for default/fallback quote
  factory Quote.fallback() {
    return const Quote(
      content: 'If you really want to be strong... Stop caring about what your surrounding thinks of you!',
      character: 'Saitama',
      characterId: 213,
      anime: 'One Punch Man',
      animeAlt: 'One Punch Man',
      animeId: 188,
    );
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'character': {
      'name': character,
      if (characterId != null) 'id': characterId,
    },
    'anime': {
      'name': anime,
      if (animeAlt != null) 'altName': animeAlt,
      if (animeId != null) 'id': animeId,
    },
  };
}
