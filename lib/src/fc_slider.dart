import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// ignore: unused_import, provides Color.toARGB32() extension
import 'package:flutter_cupertino/src/utilities.dart';

/// {@template fc_slider}
/// A native Cupertino slider widget that uses platform-specific
/// slider controls (UISlider on iOS, NSSlider on macOS).
///
/// A slider represents a control used to select a single value from
/// a continuous range of values. Uses native iOS/macOS slider controls
/// for authentic platform appearance and behavior.
///
/// On iOS, this renders a native UISlider.
/// On macOS, this renders a native NSSlider.
/// On other platforms, this widget is not supported.
/// {@endtemplate}
class FCSlider extends StatefulWidget {
  /// {@macro fc_slider}
  const FCSlider({
    required this.onChanged,
    this.value = 0.5,
    this.minimumValue = 0.0,
    this.maximumValue = 1.0,
    this.minimumTrackTintColor,
    this.maximumTrackTintColor,
    this.thumbTintColor,
    this.isContinuous = true,
    this.width,
    this.height = 44.0,
    super.key,
  });

  /// Callback invoked when the slider value changes.
  /// Receives the new value as a parameter.
  final ValueChanged<double> onChanged;

  /// The current value of the slider.
  /// Defaults to 0.5.
  final double value;

  /// The minimum value of the slider range.
  /// Defaults to 0.0.
  final double minimumValue;

  /// The maximum value of the slider range.
  /// Defaults to 1.0.
  final double maximumValue;

  /// The color of the filled portion of the slider track (left/bottom side).
  /// If null, uses system blue.
  final Color? minimumTrackTintColor;

  /// The color of the unfilled portion of the slider track (right/top side).
  /// If null, uses system gray.
  final Color? maximumTrackTintColor;

  /// The color of the slider thumb.
  /// If null, uses system default (white on iOS).
  final Color? thumbTintColor;

  /// Whether the slider sends continuous updates during tracking.
  /// When true, onChanged is called continuously as the user drags.
  /// When false, onChanged is only called when the user releases.
  /// Defaults to true.
  final bool isContinuous;

  /// The width of the slider container.
  /// If null, takes the available width.
  final double? width;

  /// The height of the slider container.
  /// Defaults to 44.0.
  final double height;

  @override
  State<FCSlider> createState() => _FCSliderState();
}

class _FCSliderState extends State<FCSlider> {
  MethodChannel? _channel;
  double? _lastValue;
  Brightness? _lastBrightness;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didUpdateWidget(FCSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      unawaited(_updateNativeValue(widget.value));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_syncBrightnessIfNeeded());
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('flutter_cupertino/fc_slider_$id');
    _channel!.setMethodCallHandler(_onMethodCall);
    _lastValue = widget.value;
    _lastBrightness = CupertinoTheme.brightnessOf(context);
  }

  Future<void> _updateNativeValue(double value) async {
    final channel = _channel;
    if (channel == null) return;

    final clamped = value.clamp(widget.minimumValue, widget.maximumValue);
    if (_lastValue != clamped) {
      try {
        await channel.invokeMethod<void>('updateValue', clamped);
        _lastValue = clamped;
      } on Exception catch (e) {
        debugPrint('Failed to update slider value: $e');
      }
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
          print('FCSlider: Failed to update brightness: $e');
        }
      }
    }
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'valueChanged') {
      final args = call.arguments as Map?;
      final value = (args?['value'] as num?)?.toDouble();
      if (value != null) {
        widget.onChanged(value);
        _lastValue = value;
      }
    }
    return null;
  }

  Map<String, dynamic> _getCreationParams() {
    final brightness = CupertinoTheme.brightnessOf(context);
    return {
      'value': widget.value,
      'minimumValue': widget.minimumValue,
      'maximumValue': widget.maximumValue,
      'minimumTrackTintColor':
          widget.minimumTrackTintColor?.toARGB32() ??
          const Color(0xFF007AFF).toARGB32(),
      'maximumTrackTintColor': widget.maximumTrackTintColor?.toARGB32(),
      'thumbTintColor': widget.thumbTintColor?.toARGB32(),
      'isContinuous': widget.isContinuous,
      'brightness': brightness == Brightness.dark ? 'dark' : 'light',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError(
        'FCSlider is only supported on iOS and macOS platforms.',
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildPlatformView(),
    );
  }

  Widget _buildPlatformView() {
    const viewType = 'flutter_cupertino/fc_slider';
    final creationParams = _getCreationParams();

    // Allow horizontal drag and tap gestures to pass through
    // to the native slider
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
      const Factory<HorizontalDragGestureRecognizer>(
        HorizontalDragGestureRecognizer.new,
      ),
      const Factory<TapGestureRecognizer>(
        TapGestureRecognizer.new,
      ),
    };

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
      );
    } else if (Platform.isMacOS) {
      return AppKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
      );
    }

    return const SizedBox.shrink();
  }
}
