import 'package:flutter/cupertino.dart';
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
            FCButton(
              onPressed: () {},
              title: 'Default Button',
              style: FCButtonStyle.borderedProminent,
            ),
            FCButton(
              onPressed: () {},
              title: 'Glass Button',
              style: FCButtonStyle.glass,
            ),
          ],
        ),
      ),
    );
  }
}
