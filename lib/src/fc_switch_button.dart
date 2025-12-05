import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// ignore: unused_import, provides Color.toARGB32() extension
import 'package:flutter_cupertino/src/utilities.dart';

/// {@template fc_switch_button}
/// A native Cupertino switch button widget that uses platform-specific
/// switch controls (UISwitch on iOS, NSSwitch on macOS).
///
/// A switch button represents a control that toggles between on and
/// off states. Uses native iOS/macOS switch controls with proper
/// accessibility support.
///
/// On iOS, this renders a native UISwitch with toggleButton
/// accessibility trait. On macOS, this renders a native NSSwitch
/// with appropriate state handling. On other platforms,
/// this widget is not supported.
/// {@endtemplate}
class FCSwitchButton extends StatefulWidget {
  /// {@macro fc_switch_button}
  const FCSwitchButton({
    required this.onToggle,
    this.label,
    this.isOn = false,
    this.onColor,
    this.isEnabled = true,
    this.width,
    this.height = 44.0,
    super.key,
  });

  /// Callback invoked when the toggle state changes.
  /// Receives the new state as a parameter.
  final ValueChanged<bool> onToggle;

  /// The label text to display alongside the toggle.
  /// Defaults to empty string (no label).
  final String? label;

  /// The current state of the toggle button.
  /// Defaults to false (off).
  final bool isOn;

  /// The background color when the toggle is on.
  /// If null, uses system green.
  final Color? onColor;

  /// Whether the button is enabled.
  /// Defaults to true.
  final bool isEnabled;

  /// The width of the button container.
  /// If null, takes the available width.
  final double? width;

  /// The height of the button container.
  /// Defaults to 44.0.
  final double height;

  @override
  State<FCSwitchButton> createState() => _FCSwitchButtonState();
}

class _FCSwitchButtonState extends State<FCSwitchButton> {
  MethodChannel? _channel;
  Brightness? _lastBrightness;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_syncBrightnessIfNeeded());
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('flutter_cupertino/fc_switch_button_$id');
    _channel!.setMethodCallHandler(_handleMethodCall);
    _lastBrightness = CupertinoTheme.brightnessOf(context);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onToggle') {
      final isOn = call.arguments as bool? ?? false;
      widget.onToggle(isOn);
    }
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
          print('FCSwitchButton: Failed to update brightness: $e');
        }
      }
    }
  }

  Map<String, dynamic> _getCreationParams() {
    final brightness = CupertinoTheme.brightnessOf(context);
    return {
      'label': widget.label ?? '',
      'isOn': widget.isOn,
      'onColor':
          widget.onColor?.toARGB32() ?? CupertinoColors.systemBlue.toARGB32(),
      'isEnabled': widget.isEnabled,
      'brightness': brightness == Brightness.dark ? 'dark' : 'light',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError(
        'FCSwitchButton is only supported on iOS and macOS platforms.',
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildPlatformView(),
    );
  }

  Widget _buildPlatformView() {
    const viewType = 'flutter_cupertino/fc_switch_button';
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
