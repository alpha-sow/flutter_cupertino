import 'dart:async';

import 'package:example/components/components.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Cupertino Example',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: HomePage(),
    );
  }
}

/// Home page with navigation to component examples.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter Cupertino Examples'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildExampleTile(
              context,
              title: 'FCButton',
              subtitle: 'Native Cupertino button examples',
              icon: CupertinoIcons.rectangle_on_rectangle,
              onTap: () {
                unawaited(
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const ButtonPage(),
                    ),
                  ),
                );
              },
            ),
            _buildExampleTile(
              context,
              title: 'FCSlider',
              subtitle: 'Native Cupertino slider examples',
              icon: CupertinoIcons.slider_horizontal_3,
              onTap: () {
                unawaited(
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const SliderPage(),
                    ),
                  ),
                );
              },
            ),
            _buildExampleTile(
              context,
              title: 'FCSwitchButton',
              subtitle: 'Native Cupertino switch button examples',
              icon: CupertinoIcons.circle_lefthalf_fill,
              onTap: () {
                unawaited(
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const SwitchButtonPage(),
                    ),
                  ),
                );
              },
            ),
            _buildExampleTile(
              context,
              title: 'FCTabBar',
              subtitle: 'Native Cupertino tab bar examples',
              icon: CupertinoIcons.square_grid_2x2,
              onTap: () {
                unawaited(
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const TabBarPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CupertinoListTile(
      leading: Icon(icon, color: CupertinoColors.systemBlue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        color: CupertinoColors.systemGrey,
      ),
      onTap: onTap,
    );
  }
}
