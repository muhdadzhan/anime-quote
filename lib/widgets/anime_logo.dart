import 'package:flutter/material.dart';

/// Appbar Middle Anime Quotes Logo & Title widget
class AnimeLogo extends StatelessWidget {
  final double size;

  const AnimeLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Styled Anime Icon Badge
        Container(
          width: size + 6,
          height: size + 6,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFFF6584)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.format_quote_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Logo Text: AnimeQuotes
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: isDark ? Colors.white : const Color(0xFF2D3436),
            ),
            children: const [
              TextSpan(text: 'Anime'),
              TextSpan(
                text: 'Quotes',
                style: TextStyle(
                  color: Color(0xFFFF6584),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
