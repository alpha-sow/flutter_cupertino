import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';

/// Comprehensive examples page for FCSwitchButton showcasing all parameters.
class SwitchButtonPage extends StatefulWidget {
  /// Creates a [SwitchButtonPage].
  const SwitchButtonPage({super.key});

  @override
  State<SwitchButtonPage> createState() => _SwitchButtonPageState();
}

class _SwitchButtonPageState extends State<SwitchButtonPage> {
  bool _basicToggle = false;
  bool _customColorToggle = true;
  bool _disabledToggle = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('FCSwitchButton Examples'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // MARK: - Basic Switch Button
            _buildSection(
              title: 'Basic Switch Button',
              child: Column(
                spacing: 12,
                children: [
                  FCSwitchButton(
                    label: 'Toggle Me',
                    isOn: _basicToggle,
                    onToggle: (value) {
                      setState(() {
                        _basicToggle = value;
                      });
                    },
                  ),
                  Text(
                    'State: ${_basicToggle ? "ON" : "OFF"}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Custom Colors Toggle
            _buildSection(
              title: 'No Label & Custom Colors',
              child: Column(
                spacing: 12,
                children: [
                  FCSwitchButton(
                    isOn: _customColorToggle,
                    onColor: CupertinoColors.systemPink,
                    onToggle: (value) {
                      setState(() {
                        _customColorToggle = value;
                      });
                    },
                  ),
                  Text(
                    'State: ${_customColorToggle ? "ON" : "OFF"}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARK: - Disabled Toggle
            _buildSection(
              title: 'Disabled State',
              child: Column(
                spacing: 12,
                children: [
                  FCSwitchButton(
                    label: 'Disabled Toggle',
                    isOn: _disabledToggle,
                    isEnabled: false,
                    onToggle: (value) {
                      // This won't be called since button is disabled
                      setState(() {
                        _disabledToggle = value;
                      });
                    },
                  ),
                  const Text(
                    'This toggle is disabled',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
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
