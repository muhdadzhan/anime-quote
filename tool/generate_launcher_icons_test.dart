// One-off generator for the AnimeQuotes launcher icon.
//
// Run with:  flutter test tool/generate_launcher_icons_test.dart
//
// It rasterizes the brand mark (purple -> pink gradient with the white
// Material quote glyph used by the in-app logo badge) and writes:
//   * legacy launcher icons           -> android/app/src/main/res/mipmap-*/ic_launcher.png
//   * round launcher icons            -> android/app/src/main/res/mipmap-*/ic_launcher_round.png
//   * adaptive icon foreground layers -> android/app/src/main/res/mipmap-*/ic_launcher_foreground.png
//   * Play Console listing icon       -> assets/branding/app_icon_512.png
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Brand gradient, sampling the purple -> pink/red artwork.
const List<Color> brandGradient = <Color>[
  Color(0xFF9B3EDB),
  Color(0xFFC944B8),
  Color(0xFFFF5F6D),
];

const String resDir = 'android/app/src/main/res';

/// Legacy densities: folder, launcher size in px (48dp), adaptive foreground px (108dp).
const Map<String, List<int>> densities = <String, List<int>>{
  'mipmap-mdpi': <int>[48, 108],
  'mipmap-hdpi': <int>[72, 162],
  'mipmap-xhdpi': <int>[96, 216],
  'mipmap-xxhdpi': <int>[144, 324],
  'mipmap-xxxhdpi': <int>[192, 432],
};

Future<void> loadIconFont() async {
  final String? root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) {
    throw StateError('FLUTTER_ROOT is not set; run this through `flutter test`.');
  }
  final File file = File(
    '$root/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  );
  final Uint8List bytes = file.readAsBytesSync();
  final FontLoader loader = FontLoader('MaterialIcons')
    ..addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
  await loader.load();
}

TextPainter _quotePainter() {
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(Icons.format_quote_rounded.codePoint),
      style: const TextStyle(
        fontFamily: 'MaterialIcons',
        fontSize: 200,
        color: Colors.white,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  painter.layout();
  return painter;
}

/// Paints the white quote glyph so it occupies [widthFraction] of the canvas
/// width and is optically centred.
void _paintQuotes(
  Canvas canvas,
  Size size,
  TextPainter painter,
  double widthFraction,
) {
  final double scale = (size.width * widthFraction) / painter.width;
  canvas.save();
  canvas.translate(size.width / 2, size.height / 2);
  canvas.scale(scale);
  painter.paint(
    canvas,
    Offset(-painter.width / 2, -painter.height / 2),
  );
  canvas.restore();
}

Paint _gradientPaint(Size size) {
  return Paint()
    ..shader = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      brandGradient,
      const <double>[0.0, 0.55, 1.0],
    );
}

Future<void> _writeIcon(
  String path,
  int size,
  void Function(Canvas canvas, Size size) paint,
) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  paint(canvas, Size(size.toDouble(), size.toDouble()));
  final ui.Picture picture = recorder.endRecording();
  final ui.Image image = await picture.toImage(size, size);
  final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) {
    throw StateError('Failed to encode $path');
  }
  final File out = File(path);
  out.parent.createSync(recursive: true);
  out.writeAsBytesSync(data.buffer.asUint8List());
  image.dispose();
  picture.dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate launcher icons', () async {
    await loadIconFont();
    final TextPainter painter = _quotePainter();

    for (final MapEntry<String, List<int>> entry in densities.entries) {
      final String folder = '$resDir/${entry.key}';
      final int legacy = entry.value[0];
      final int foreground = entry.value[1];

      // Legacy icon: full-bleed gradient with rounded corners.
      await _writeIcon('$folder/ic_launcher.png', legacy, (canvas, size) {
        final RRect rr = RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.width * 0.2),
        );
        canvas.drawRRect(rr, _gradientPaint(size));
        _paintQuotes(canvas, size, painter, 0.56);
      });

      // Round variant for launchers that request a circular icon.
      await _writeIcon('$folder/ic_launcher_round.png', legacy, (canvas, size) {
        canvas.save();
        canvas.clipPath(
          Path()..addOval(Rect.fromCircle(
            center: size.center(Offset.zero),
            radius: size.width / 2,
          )),
        );
        canvas.drawRect(Offset.zero & size, _gradientPaint(size));
        _paintQuotes(canvas, size, painter, 0.56);
        canvas.restore();
      });

      // Adaptive foreground: transparent, glyph inside the 66dp safe zone.
      await _writeIcon(
        '$folder/ic_launcher_foreground.png',
        foreground,
        (canvas, size) => _paintQuotes(canvas, size, painter, 0.50),
      );
    }

    // Play Console listing icon: 512x512, full-bleed, no transparency.
    await _writeIcon('assets/branding/app_icon_512.png', 512, (canvas, size) {
      canvas.drawRect(Offset.zero & size, _gradientPaint(size));
      _paintQuotes(canvas, size, painter, 0.56);
    });
  });
}
