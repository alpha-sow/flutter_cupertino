import 'dart:async';

import 'package:example/components/components.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatefulWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _themeMode = Brightness.light;

  void _cycleTheme() {
    setState(() {
      if (_themeMode == Brightness.light) {
        _themeMode = Brightness.dark;
      } else {
        _themeMode = Brightness.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Cupertino Example',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemYellow,
        brightness: _themeMode,
      ),
      home: HomePage(
        onThemeToggle: _cycleTheme,
        currentBrightness: _themeMode,
      ),
    );
  }
}

/// Home page with navigation to component examples.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage].
  const HomePage({
    required this.onThemeToggle,
    required this.currentBrightness,
    super.key,
  });

  /// Callback to toggle the theme.
  final VoidCallback onThemeToggle;

  /// Current brightness mode.
  final Brightness currentBrightness;

  @override
  Widget build(BuildContext context) {
    final icon = currentBrightness == Brightness.light
        ? CupertinoIcons.moon_fill
        : CupertinoIcons.sun_max_fill;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Flutter Cupertino Examples'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onThemeToggle,
          child: Icon(icon),
        ),
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
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(CupertinoIcons.chevron_right),
      onTap: onTap,
    );
  }
}
