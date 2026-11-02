import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

/// Service class to interact with the Animechan API (v1).
///
/// Base URL: https://api.animechan.io/v1
/// Authentication: None
class AnimeQuoteService {
  static const String baseUrl = 'https://api.animechan.io/v1';

  final http.Client _client;

  AnimeQuoteService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches a single random anime quote.
  ///
  /// Optional [anime] parameter scopes the random quote to a specific anime.
  /// Endpoint: GET /quotes/random or /quotes/random?anime={anime}
  Future<Quote> getRandomQuote({String? anime}) async {
    final queryParameters = <String, String>{};
    if (anime != null && anime.trim().isNotEmpty) {
      queryParameters['anime'] = anime.trim();
    }

    final uri = Uri.parse('$baseUrl/quotes/random').replace(
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'AnimeQuotes-Flutter-App/1.0',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == 'success' && body['data'] != null) {
        return Quote.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        throw Exception('API returned unsuccessful status: ${body['status']}');
      }
    } else {
      throw Exception('Failed to load quote. HTTP status: ${response.statusCode}');
    }
  }

  /// Fetches paginated or list of quotes by a specific character name.
  ///
  /// Endpoint: GET /quotes?character={character}
  Future<List<Quote>> getQuotesByCharacter(String character) async {
    final uri = Uri.parse('$baseUrl/quotes').replace(
      queryParameters: {'character': character.trim()},
    );

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'AnimeQuotes-Flutter-App/1.0',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == 'success' && body['data'] is List) {
        final list = body['data'] as List;
        return list.map((item) => Quote.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load quotes for character "$character" (Status: ${response.statusCode})');
    }
  }

  /// Fetches quotes filtered by anime title.
  ///
  /// Endpoint: GET /quotes?anime={anime}
  Future<List<Quote>> getQuotesByAnime(String anime) async {
    final uri = Uri.parse('$baseUrl/quotes').replace(
      queryParameters: {'anime': anime.trim()},
    );

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'AnimeQuotes-Flutter-App/1.0',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == 'success' && body['data'] is List) {
        final list = body['data'] as List;
        return list.map((item) => Quote.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load quotes for anime "$anime" (Status: ${response.statusCode})');
    }
  }

  /// Fetches quotes by a general query (searches anime or character or content).
  ///
  /// Endpoint: GET /quotes
  Future<List<Quote>> searchQuotes(String query) async {
    // If user query matches character or anime, API supports ?anime= or ?character=
    // Animechan v1 /quotes returns paginated quotes.
    final uri = Uri.parse('$baseUrl/quotes').replace(
      queryParameters: {'query': query.trim()},
    );

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'AnimeQuotes-Flutter-App/1.0',
      },
    ).timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == 'success' && body['data'] is List) {
        final list = body['data'] as List;
        return list.map((item) => Quote.fromJson(item as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }
}
