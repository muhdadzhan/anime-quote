import 'package:flutter/material.dart';
import 'models/quote_model.dart';
import 'services/anime_quote_service.dart';
import 'theme/app_theme.dart';
import 'widgets/anime_logo.dart';
import 'widgets/quote_card.dart';
import 'widgets/search_bar_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AnimeQuotesApp());
}

class AnimeQuotesApp extends StatefulWidget {
  const AnimeQuotesApp({super.key});

  @override
  State<AnimeQuotesApp> createState() => _AnimeQuotesAppState();
}

class _AnimeQuotesAppState extends State<AnimeQuotesApp> {
  // Theme state: User can switch between Light and Dark mode
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeQuotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomePage(
        onToggleTheme: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AnimeQuoteService _quoteService = AnimeQuoteService();

  Quote? _currentQuote;
  bool _isLoading = false;
  String? _errorMessage;
  String _activeFilter = 'Random';

  /*
  ========================================================================
  [SEARCH & ARRAY STATE - HIDDEN AS COMMENT AS REQUESTED]
  ========================================================================
  When the search function is activated, quotes returned from the API array 
  can be stored in this list and rendered in a scrollable view:

  List<Quote> _searchResults = [];
  bool _isSearchActive = false;

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isSearchActive = true;
    });

    try {
      // 1. Try searching by character
      List<Quote> results = await _quoteService.getQuotesByCharacter(query);
      
      // 2. If empty, try searching by anime title
      if (results.isEmpty) {
        results = await _quoteService.getQuotesByAnime(query);
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Search error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearchActive = false;
      _searchResults = [];
    });
  }
  ========================================================================
  */

  late AnimationController _refreshAnimController;

  @override
  void initState() {
    super.initState();
    _refreshAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fetchRandomQuote();
  }

  @override
  void dispose() {
    _refreshAnimController.dispose();
    super.dispose();
  }

  /// Fetches a new random quote from the Animechan API
  Future<void> _fetchRandomQuote({String? animeFilter}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _refreshAnimController.forward(from: 0.0);

    try {
      final quote = await _quoteService.getRandomQuote(
        anime: animeFilter ?? (_activeFilter == 'Random' ? null : _activeFilter),
      );
      if (mounted) {
        setState(() {
          _currentQuote = quote;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Unable to connect to Animechan API. Showing offline quote.';
          _currentQuote = _currentQuote ?? Quote.fallback();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // i. Middle : Anime quote logo and text(AnimeQuotes)
        title: const AnimeLogo(),
        centerTitle: true,
        actions: [
          // Theme Switcher button
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                color: isDark ? const Color(0xFFFFD166) : const Color(0xFF6C5CE7),
              ),
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchRandomQuote(),
        color: const Color(0xFF6C5CE7),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Search bar with lens icon
              SearchBarWidget(
                onSearchSubmitted: (query) {
                  // The search function is hidden as comment per requirement.
                  // We show a helpful SnackBar to demonstrate user interaction.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Search query "$query" received!\n(Search list feature is currently commented out as requested)',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                onClear: () {
                  // Optional clear callback
                },
              ),

              const SizedBox(height: 18),

              // Quick Filter Chips (Demonstrating API query capabilities)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('Random', null),
                    const SizedBox(width: 8),
                    _buildFilterChip('Naruto', 'Naruto'),
                    const SizedBox(width: 8),
                    _buildFilterChip('One Piece', 'One Piece'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Bleach', 'Bleach'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Demon Slayer', 'Demon Slayer: Kimetsu no Yaiba'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Error banner if any
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ii. The quote (data:content)
              // iii. The character who said the quote (data:character{name})
              // iv. From which anime (data:anime{name})
              if (_currentQuote != null)
                QuoteCard(
                  quote: _currentQuote!,
                  isLoading: _isLoading,
                )
              else if (_isLoading)
                _buildLoadingPlaceholder(isDark),

              const SizedBox(height: 24),

              // v. Refresh icon & button
              // "1. Will refresh the page for display new quotes"
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: _isLoading ? null : () => _fetchRandomQuote(),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFFFF6584)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C5CE7).withAlpha(100),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RotationTransition(
                              turns: _refreshAnimController,
                              child: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isLoading ? 'Fetching Quote...' : 'Next Quote',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to fetch a new anime quote or pull down to refresh',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Subtle API credits badge
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withAlpha(10)
                        : Colors.black.withAlpha(8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.api_rounded,
                        size: 14,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Powered by Animechan API v1',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? queryValue) {
    final isSelected = _activeFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _activeFilter = label;
          });
          _fetchRandomQuote(animeFilter: queryValue);
        }
      },
      selectedColor: const Color(0xFF6C5CE7),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white70 : Colors.black87),
      ),
      backgroundColor:
          isDark ? const Color(0xFF1E2230) : Colors.black.withAlpha(10),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF6C5CE7)
            : (isDark ? Colors.white12 : Colors.black12),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildLoadingPlaceholder(bool isDark) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16),
            Text(
              'Summoning anime wisdom...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
