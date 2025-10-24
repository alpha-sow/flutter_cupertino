import 'package:flutter/material.dart';

/// Extension on [Color] to convert to ARGB32 format for platform channels.
extension ColorExtension on Color {
  /// Converts the color to a 32-bit ARGB integer.
  ///
  /// The format is: AARRGGBB where:
  /// - AA: Alpha channel (0-255)
  /// - RR: Red channel (0-255)
  /// - GG: Green channel (0-255)
  /// - BB: Blue channel (0-255)
  int toARGB32() {
    final alphaValue = (a * 255.0).round() & 0xff;
    final redValue = (r * 255.0).round() & 0xff;
    final greenValue = (g * 255.0).round() & 0xff;
    final blueValue = (b * 255.0).round() & 0xff;
    return (alphaValue << 24) |
        (redValue << 16) |
        (greenValue << 8) |
        blueValue;
  }
}
