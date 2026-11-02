import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote_model.dart';

/// QuoteCard Widget
/// Displays:
/// - data:content (The quote)
/// - data:character{name} (The character who said the quote)
/// - data:anime{name} (From which anime)
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const QuoteCard({
    super.key,
    required this.quote,
    this.onRefresh,
    this.isLoading = false,
  });

  void _copyToClipboard(BuildContext context) {
    final textToCopy = '"${quote.content}"\n— ${quote.character} (${quote.anime})';
    Clipboard.setData(ClipboardData(text: textToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Quote copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF6C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(8),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E2230),
                    const Color(0xFF161925),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF9FAFF),
                  ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: decorative quote icon & quick copy button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withAlpha(isDark ? 50 : 25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF6C5CE7),
                    size: 26,
                  ),
                ),
                IconButton(
                  tooltip: 'Copy quote',
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: isDark ? Colors.white60 : Colors.black45,
                  onPressed: () => _copyToClipboard(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ii. The quote (data:content)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isLoading ? 0.4 : 1.0,
              child: Text(
                quote.content,
                style: TextStyle(
                  fontSize: quote.content.length > 140 ? 17 : 20,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.2,
                  color: isDark ? const Color(0xFFF1F2F6) : const Color(0xFF2D3436),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Divider(
              color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(12),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Metadata Row: Character and Anime
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // iii. The character who said the quote (data:character{name})
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6584).withAlpha(isDark ? 40 : 20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: Color(0xFFFF6584),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHARACTER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                          Text(
                            quote.character,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E272E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // iv. From which anime (data:anime{name})
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B894).withAlpha(isDark ? 40 : 20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.tv_rounded,
                        size: 16,
                        color: Color(0xFF00B894),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ANIME SERIES',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                          Text(
                            quote.anime,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF81ECEC) : const Color(0xFF0984E3),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
