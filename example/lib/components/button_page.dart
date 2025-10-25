import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_cupertino/flutter_cupertino.dart';

/// Comprehensive examples page for FCButton showcasing all parameters.
class ButtonPage extends StatelessWidget {
  /// Creates a [ButtonPage].
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('FCButton Examples'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section: All Button Styles
            _buildSectionTitle('Button Styles'),
            const SizedBox(height: 8),

            FCButton(
              onPressed: () {},
              title: 'Automatic Style',
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Bordered Prominent',
              style: FCButtonStyle.borderedProminent,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Bordered Button',
              style: FCButtonStyle.bordered,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Borderless Button',
              style: FCButtonStyle.borderless,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Plain Button',
              style: FCButtonStyle.plain,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Glass Button',
              style: FCButtonStyle.glass,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Glass Prominent',
              style: FCButtonStyle.glassProminent,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Custom Colors
            _buildSectionTitle('Custom Colors'),
            const SizedBox(height: 8),

            FCButton(
              onPressed: () {},
              title: 'Custom Red',
              style: FCButtonStyle.borderedProminent,
              backgroundColor: const Color(0xFFFF3B30),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Custom Green',
              style: FCButtonStyle.borderedProminent,
              backgroundColor: const Color(0xFF34C759),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Custom Purple',
              style: FCButtonStyle.borderedProminent,
              backgroundColor: const Color(0xFFAF52DE),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Orange Text',
              style: FCButtonStyle.bordered,
              foregroundColor: const Color(0xFFFF9500),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Pink Glass',
              style: FCButtonStyle.glass,
              backgroundColor: const Color(0xFFFF2D55),
              foregroundColor: CupertinoColors.white,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Control Sizes
            _buildSectionTitle('Control Sizes'),
            const SizedBox(height: 8),

            FCButton(
              onPressed: () {},
              title: 'Mini Button',
              style: FCButtonStyle.borderedProminent,
              controlSize: FCControlSize.mini,
              height: 28,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Small Button',
              style: FCButtonStyle.borderedProminent,
              controlSize: FCControlSize.small,
              height: 36,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Regular Button',
              style: FCButtonStyle.borderedProminent,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Large Button',
              style: FCButtonStyle.borderedProminent,
              controlSize: FCControlSize.large,
              height: 52,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Font Sizes
            _buildSectionTitle('Font Size Variations'),
            const SizedBox(height: 8),

            FCButton(
              onPressed: () {},
              title: 'Small Font (13pt)',
              style: FCButtonStyle.borderedProminent,
              fontSize: 13,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Regular Font (17pt)',
              style: FCButtonStyle.borderedProminent,
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Large Font (22pt)',
              style: FCButtonStyle.borderedProminent,
              fontSize: 22,
              height: 52,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Disabled State
            _buildSectionTitle('Disabled State'),
            const SizedBox(height: 8),

            const FCButton(
              onPressed: null,
              title: 'Disabled Prominent',
              style: FCButtonStyle.borderedProminent,
              isEnabled: false,
            ),
            const SizedBox(height: 12),

            const FCButton(
              onPressed: null,
              title: 'Disabled Bordered',
              style: FCButtonStyle.bordered,
              isEnabled: false,
            ),
            const SizedBox(height: 12),

            const FCButton(
              onPressed: null,
              title: 'Disabled Glass',
              style: FCButtonStyle.glass,
              isEnabled: false,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Width Variations
            _buildSectionTitle('Width Variations'),
            const SizedBox(height: 8),

            Center(
              child: FCButton(
                onPressed: () {},
                title: 'Narrow',
                style: FCButtonStyle.borderedProminent,
                width: 120,
              ),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: 'Full Width',
              style: FCButtonStyle.borderedProminent,
            ),
            const SizedBox(height: 12),

            Center(
              child: FCButton(
                onPressed: () {},
                title: 'Fixed 200pt',
                style: FCButtonStyle.borderedProminent,
                width: 200,
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Interactive Examples
            _buildSectionTitle('Interactive Button Groups'),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: FCButton(
                    onPressed: () {},
                    title: 'Cancel',
                    style: FCButtonStyle.bordered,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FCButton(
                    onPressed: () {},
                    title: 'Confirm',
                    style: FCButtonStyle.borderedProminent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FCButton(
                  onPressed: () {},
                  title: 'Delete',
                  style: FCButtonStyle.borderedProminent,
                  backgroundColor: const Color(0xFFFF3B30),
                  width: 100,
                ),
                FCButton(
                  onPressed: () {},
                  title: 'Edit',
                  style: FCButtonStyle.bordered,
                  width: 100,
                ),
                FCButton(
                  onPressed: () {},
                  title: 'Share',
                  style: FCButtonStyle.borderless,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stacked action buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FCButton(
                  onPressed: () {},
                  title: 'Primary Action',
                  style: FCButtonStyle.borderedProminent,
                ),
                const SizedBox(height: 8),
                FCButton(
                  onPressed: () {},
                  title: 'Secondary Action',
                  style: FCButtonStyle.bordered,
                ),
                const SizedBox(height: 8),
                FCButton(
                  onPressed: () {},
                  title: 'Tertiary Action',
                  style: FCButtonStyle.plain,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Section: Themed Examples
            _buildSectionTitle('Themed Button Examples'),
            const SizedBox(height: 8),

            FCButton(
              onPressed: () {},
              title: '❤️ Like',
              style: FCButtonStyle.glass,
              backgroundColor: const Color(0xFFFF2D55),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: '⭐ Favorite',
              style: FCButtonStyle.borderedProminent,
              backgroundColor: const Color(0xFFFFCC00),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: '📧 Send Message',
              style: FCButtonStyle.borderedProminent,
              backgroundColor: const Color(0xFF007AFF),
            ),
            const SizedBox(height: 12),

            FCButton(
              onPressed: () {},
              title: '🚀 Launch',
              style: FCButtonStyle.glassProminent,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.label,
        ),
      ),
    );
  }
}
