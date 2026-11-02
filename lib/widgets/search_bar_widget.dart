import 'package:flutter/material.dart';

/// Search bar widget with magnifying lens icon.
///
/// Requirement:
/// "1. When the user search it, it will list all quotes from the array.
///  2. Hide this function first as comment"
class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    this.onSearchSubmitted,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    /* 
    ========================================================================
    [HIDDEN SEARCH FUNCTIONALITY - UNCOMMENT TO ACTIVATE ARRAY SEARCH]
    ========================================================================
    When activated, this sends the search query to the animechan API 
    (e.g., GET https://api.animechan.io/v1/quotes?character={name} or ?anime={name})
    and populates the results into a scrollable ListView from the returned array.

    Example implementation:
    
    if (query.trim().isEmpty) return;
    
    // Call the search callback to fetch array of quotes from API:
    // widget.onSearchSubmitted?.call(query.trim());
    
    // Example logic in parent state:
    // setState(() => _isLoading = true);
    // try {
    //   final quotesArray = await animeQuoteService.getQuotesByCharacter(query);
    //   setState(() {
    //     _quoteList = quotesArray; // Display ListView.builder of QuoteCards
    //   });
    // } catch (e) {
    //   _showError(e.toString());
    // } finally {
    //   setState(() => _isLoading = false);
    // }
    ========================================================================
    */

    // For now, inform the user or trigger optional callback if provided
    if (widget.onSearchSubmitted != null && query.isNotEmpty) {
      widget.onSearchSubmitted!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: _handleSearch,
        decoration: InputDecoration(
          // Lens icon as requested
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          hintText: 'Search quote by character or anime...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black38,
            fontSize: 14,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear?.call();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withAlpha(120),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
