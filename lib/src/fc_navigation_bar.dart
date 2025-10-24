import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';

/// Large title display modes for the navigation bar.
enum FCLargeTitleDisplayMode {
  /// Automatically determines whether to show large title.
  automatic,

  /// Always shows large title.
  always,

  /// Never shows large title.
  never,
}

/// {@template fc_navigation_bar}
/// A native Cupertino navigation bar widget.
///
/// This provides a consistent navigation bar across iOS and macOS platforms
/// with native styling and behavior.
/// {@endtemplate}
class FCNavigationBar extends StatelessWidget {
  /// {@macro fc_navigation_bar}
  const FCNavigationBar({
    this.title,
    this.leading,
    this.trailing,
    this.leadingItems,
    this.trailingItems,
    this.backgroundColor,
    this.largeTitleDisplayMode = FCLargeTitleDisplayMode.automatic,
    this.preferredHeight,
    super.key,
  });

  /// The title widget to display in the navigation bar.
  final Widget? title;

  /// A widget to display on the leading side of the navigation bar.
  /// Typically a back button or menu button.
  /// Note: This is only used for Flutter rendering, not native rendering.
  /// For native bar buttons, use [leadingItems].
  final Widget? leading;

  /// A widget to display on the trailing side of the navigation bar.
  /// Typically action buttons.
  /// Note: This is only used for Flutter rendering, not native rendering.
  /// For native bar buttons, use [trailingItems].
  final Widget? trailing;

  /// Native bar button items to display on the leading side.
  /// These are rendered as native UIBarButtonItems on iOS/macOS.
  final List<FCBarButtonItem>? leadingItems;

  /// Native bar button items to display on the trailing side.
  /// These are rendered as native UIBarButtonItems on iOS/macOS.
  final List<FCBarButtonItem>? trailingItems;

  /// The background color of the navigation bar.
  /// If null, uses the system default.
  final Color? backgroundColor;

  /// How the large title should be displayed.
  final FCLargeTitleDisplayMode largeTitleDisplayMode;

  /// The preferred height of the navigation bar.
  /// If null, uses the system default height.
  final double? preferredHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredHeight ?? (Platform.isMacOS ? 52.0 : 44.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Platform.isMacOS ? 16.0 : 8.0,
        ),
        child: Row(
          children: [
            // Leading widget
            if (leading != null)
              SizedBox(
                width: 44,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: leading,
                ),
              ),

            // Title (centered)
            Expanded(
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: Platform.isMacOS ? 15.0 : 17.0,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                  child: title ?? const SizedBox.shrink(),
                ),
              ),
            ),

            // Trailing widget
            if (trailing != null)
              SizedBox(
                width: 44,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
