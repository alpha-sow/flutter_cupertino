import 'package:flutter/cupertino.dart';

/// System bar button items available on iOS/macOS.
enum FCBarButtonSystemItem {
  /// Done button
  done,

  /// Cancel button
  cancel,

  /// Edit button
  edit,

  /// Save button
  save,

  /// Add (+) button
  add,

  /// Flexible space
  flexibleSpace,

  /// Fixed space
  fixedSpace,

  /// Compose button
  compose,

  /// Reply button
  reply,

  /// Action button
  action,

  /// Organize button
  organize,

  /// Bookmarks button
  bookmarks,

  /// Search button
  search,

  /// Refresh button
  refresh,

  /// Stop button
  stop,

  /// Camera button
  camera,

  /// Trash button
  trash,

  /// Play button
  play,

  /// Pause button
  pause,

  /// Rewind button
  rewind,

  /// Fast forward button
  fastForward,

  /// Undo button (iOS 13+)
  undo,

  /// Redo button (iOS 13+)
  redo,

  /// Close button (iOS 13+)
  close,
}

/// Bar button styles.
enum FCBarButtonStyle {
  /// Plain style
  plain,

  /// Done style (bold)
  done,
}

/// {@template fc_bar_button_item}
/// A configuration for a native bar button item in the navigation bar.
///
/// This maps directly to UIBarButtonItem on iOS/macOS and allows
/// full customization of navigation bar buttons.
/// {@endtemplate}
class FCBarButtonItem {
  /// {@macro fc_bar_button_item}
  const FCBarButtonItem({
    this.title,
    this.systemIconName,
    this.systemItem,
    this.imageName,
    this.style = FCBarButtonStyle.plain,
    this.tintColor,
    this.width,
    this.isEnabled = true,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.tag,
    this.onTap,
  }) : assert(
         title != null ||
             systemIconName != null ||
             systemItem != null ||
             imageName != null,
         'At least one of title, systemIconName, systemItem, '
         'or imageName must be provided',
       );

  /// System bar button item (e.g., done, cancel, edit).
  const FCBarButtonItem.system({
    required this.systemItem,
    this.style = FCBarButtonStyle.plain,
    this.tintColor,
    this.isEnabled = true,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.tag,
    this.onTap,
  }) : title = null,
       systemIconName = null,
       imageName = null,
       width = null;

  /// Text-only bar button item.
  const FCBarButtonItem.text({
    required this.title,
    this.style = FCBarButtonStyle.plain,
    this.tintColor,
    this.width,
    this.isEnabled = true,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.tag,
    this.onTap,
  }) : systemIconName = null,
       systemItem = null,
       imageName = null;

  /// SF Symbol bar button item.
  const FCBarButtonItem.icon({
    required this.systemIconName,
    this.style = FCBarButtonStyle.plain,
    this.tintColor,
    this.width,
    this.isEnabled = true,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.tag,
    this.onTap,
  }) : title = null,
       systemItem = null,
       imageName = null;

  /// Custom image bar button item.
  const FCBarButtonItem.image({
    required this.imageName,
    this.style = FCBarButtonStyle.plain,
    this.tintColor,
    this.width,
    this.isEnabled = true,
    this.accessibilityLabel,
    this.accessibilityHint,
    this.tag,
    this.onTap,
  }) : title = null,
       systemIconName = null,
       systemItem = null;

  /// Text title for the button.
  final String? title;

  /// SF Symbol name (iOS 13+).
  final String? systemIconName;

  /// System bar button item type.
  final FCBarButtonSystemItem? systemItem;

  /// Custom image name from asset catalog.
  final String? imageName;

  /// Button style.
  final FCBarButtonStyle style;

  /// Tint color for the button.
  final Color? tintColor;

  /// Fixed width for the button.
  final double? width;

  /// Whether the button is enabled.
  final bool isEnabled;

  /// Accessibility label.
  final String? accessibilityLabel;

  /// Accessibility hint.
  final String? accessibilityHint;

  /// Tag for identifying the button.
  final int? tag;

  /// Callback when button is tapped.
  final VoidCallback? onTap;

  /// Converts to a map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (systemIconName != null) 'systemIconName': systemIconName,
      if (systemItem != null) 'systemItem': systemItem!.name,
      if (imageName != null) 'imageName': imageName,
      'style': style.name,
      if (tintColor != null) 'tintColor': tintColor!.toARGB32(),
      if (width != null) 'width': width,
      'isEnabled': isEnabled,
      if (accessibilityLabel != null) 'accessibilityLabel': accessibilityLabel,
      if (accessibilityHint != null) 'accessibilityHint': accessibilityHint,
      if (tag != null) 'tag': tag,
    };
  }
}
