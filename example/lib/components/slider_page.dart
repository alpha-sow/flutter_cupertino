import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';

/// Comprehensive examples page for FCSlider showcasing all parameters.
class SliderPage extends StatefulWidget {
  /// Creates a [SliderPage].
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _basicSliderValue = 0.5;
  double _customColorSliderValue = 0.3;
  double _rangeSliderValue = 50;
  double _discreteSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('FCSlider Examples'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // MARK: - Basic Slider
            _buildSection(
              title: 'Basic Slider',
              child: Column(
                spacing: 12,
                children: [
                  FCSlider(
                    value: _basicSliderValue,
                    onChanged: (value) {
                      setState(() {
                        _basicSliderValue = value;
                      });
                    },
                  ),
                  Text(
                    'Value: ${_basicSliderValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Custom Colors
            _buildSection(
              title: 'Custom Colors',
              child: Column(
                spacing: 12,
                children: [
                  FCSlider(
                    value: _customColorSliderValue,
                    minimumTrackTintColor: const Color(0xFF34C759),
                    maximumTrackTintColor: const Color(0xFFE5E5EA),
                    thumbTintColor: const Color(0xFFFFFFFF),
                    onChanged: (value) {
                      setState(() {
                        _customColorSliderValue = value;
                      });
                    },
                  ),
                  Text(
                    'Value: ${_customColorSliderValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Custom Range
            _buildSection(
              title: 'Custom Range (0-100)',
              child: Column(
                spacing: 12,
                children: [
                  FCSlider(
                    value: _rangeSliderValue,
                    maximumValue: 100,
                    onChanged: (value) {
                      setState(() {
                        _rangeSliderValue = value;
                      });
                    },
                  ),
                  Text(
                    'Value: ${_rangeSliderValue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Discrete Values
            _buildSection(
              title: 'Discrete Values (1-10)',
              child: Column(
                spacing: 12,
                children: [
                  FCSlider(
                    value: _discreteSliderValue,
                    minimumValue: 1,
                    maximumValue: 10,
                    isContinuous: false,
                    onChanged: (value) {
                      setState(() {
                        _discreteSliderValue = value.roundToDouble();
                      });
                    },
                  ),
                  Text(
                    'Value: ${_discreteSliderValue.toInt()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Info Section
            _buildSection(
              title: 'About Sliders',
              child: const Text(
                'FCSlider uses UISlider on iOS and NSSlider on macOS '
                'for native platform appearance and behavior. '
                'Set isContinuous to false for discrete value changes.',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
