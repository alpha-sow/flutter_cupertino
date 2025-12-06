import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// ignore: unused_import, provides Color.toARGB32() extension
import 'package:flutter_cupertino/src/utilities.dart';

/// Button style options for native Cupertino buttons.
///
/// These styles map to native UIButton.Configuration styles on iOS
/// and NSButton.BezelStyle on macOS.
enum FCButtonStyle {
  /// Automatic style based on context.
  automatic,

  /// Bordered button style.
  bordered,

  /// Prominent bordered (accent-colored) style.
  borderedProminent,

  /// Borderless/minimal style.
  borderless,

  /// Glass effect with blur.
  glass,

  /// Prominent glass effect with blur.
  glassProminent,

  /// Minimal, text-only style.
  plain,
}

/// Button size options.
enum FCControlSize {
  /// Mini size button (iOS 15+).
  mini,

  /// Small size button.
  small,

  /// Regular size button (default).
  regular,

  /// Large size button.
  large,
}

/// {@template fc_button}
/// A native Cupertino button widget that uses platform-specific
/// implementations.
///
/// On iOS, this renders a native UIButton.
/// On macOS, this renders a native NSButton.
/// On other platforms, this widget is not supported.
/// {@endtemplate}
class FCButton extends StatefulWidget {
  /// {@macro fc_button}
  const FCButton({
    required this.onPressed,
    this.title = 'Button',
    this.style = FCButtonStyle.automatic,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize = 17.0,
    this.isEnabled = true,
    this.width,
    this.height = 44.0,
    this.controlSize = FCControlSize.regular,
    super.key,
  });

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// The text to display on the button.
  final String title;

  /// The style of the button.
  /// Defaults to [FCButtonStyle.automatic].
  final FCButtonStyle style;

  /// The background color of the button.
  /// If null, uses the system default for the selected style.
  final Color? backgroundColor;

  /// The text/foreground color of the button.
  /// Defaults to system blue on iOS/macOS.
  final Color? foregroundColor;

  /// The font size of the button text.
  /// Defaults to 17.0.
  final double fontSize;

  /// Whether the button is enabled.
  /// Defaults to true.
  final bool isEnabled;

  /// The width of the button container.
  /// If null, takes the available width.
  final double? width;

  /// The height of the button container.
  /// Defaults to 44.0.
  final double height;

  /// The size preset for the button.
  /// Defaults to [FCControlSize.regular].
  final FCControlSize controlSize;

  @override
  State<FCButton> createState() => _FCButtonState();
}

class _FCButtonState extends State<FCButton> {
  MethodChannel? _channel;
  Brightness? _lastBrightness;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('flutter_cupertino/fc_button_$id');
    _channel!.setMethodCallHandler(_handleMethodCall);
    _lastBrightness = CupertinoTheme.brightnessOf(context);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onPressed') {
      widget.onPressed?.call();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_syncBrightnessIfNeeded());
  }

  Future<void> _syncBrightnessIfNeeded() async {
    final ch = _channel;
    if (ch == null) return;
    final brightness = CupertinoTheme.brightnessOf(context);
    if (_lastBrightness != brightness) {
      _lastBrightness = brightness;
      try {
        await ch.invokeMethod('updateBrightness', {
          'brightness': brightness == Brightness.dark ? 'dark' : 'light',
        });
      } on Exception catch (e) {
        if (kDebugMode) {
          print('FCButton: Failed to update brightness: $e');
        }
      }
    }
  }

  Map<String, dynamic> _getCreationParams() {
    final brightness = CupertinoTheme.brightnessOf(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    return {
      'title': widget.title,
      'style': widget.style.name,
      'backgroundColor':
          widget.backgroundColor?.toARGB32() ?? primaryColor.toARGB32(),
      'foregroundColor': widget.foregroundColor?.toARGB32(),
      'fontSize': widget.fontSize,
      'isEnabled': widget.isEnabled && widget.onPressed != null,
      'controlSize': widget.controlSize.name,
      'brightness': brightness == Brightness.dark ? 'dark' : 'light',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError(
        'FCButton is only supported on iOS and macOS platforms.',
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildPlatformView(),
    );
  }

  Widget _buildPlatformView() {
    const viewType = 'flutter_cupertino/fc_button';
    final creationParams = _getCreationParams();

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      );
    } else if (Platform.isMacOS) {
      return AppKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      );
    }

    return const SizedBox.shrink();
  }
}
