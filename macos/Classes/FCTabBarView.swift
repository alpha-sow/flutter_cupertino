import Cocoa
import FlutterMacOS

class FCTabBarFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return FCTabBarView(
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger
    ).view
  }

  func createArgsCodec() -> (any FlutterMessageCodec & NSObjectProtocol)? {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class FCTabBarView: NSObject {
  private(set) var view: NSView
  private var segmentedControl: NSSegmentedControl
  private var channel: FlutterMethodChannel
  private var tabItems: [[String: Any?]] = []

  // Tab bar styling properties
  private struct TabBarStyle {
    let items: [[String: Any?]]
    let selectedIndex: Int
    let style: String
    let backgroundColor: NSColor?
    let selectedTintColor: NSColor?
    let unselectedTintColor: NSColor?
    let isTranslucent: Bool
  }

  init(
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    view = NSView()
    segmentedControl = NSSegmentedControl()
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_tabbar_\(viewId)",
      binaryMessenger: messenger
    )
    super.init()

    let tabBarStyle = parseArguments(args)
    configureTabBar(with: tabBarStyle)
    setupTabBarLayout()
  }

  // MARK: - Argument Parsing

  private func parseArguments(_ args: Any?) -> TabBarStyle {
    var items: [[String: Any?]] = []
    var selectedIndex = 0
    var style = "standard"
    var backgroundColor: NSColor?
    var selectedTintColor: NSColor?
    var unselectedTintColor: NSColor?
    var isTranslucent = true

    if let args = args as? [String: Any] {
      items = args["items"] as? [[String: Any?]] ?? items
      selectedIndex = args["selectedIndex"] as? Int ?? selectedIndex
      style = args["style"] as? String ?? style

      if let bgColorValue = args["backgroundColor"] as? Int {
        backgroundColor = NSColor(argb: bgColorValue)
      }
      if let selectedColorValue = args["selectedTintColor"] as? Int {
        selectedTintColor = NSColor(argb: selectedColorValue)
      }
      if let unselectedColorValue = args["unselectedTintColor"] as? Int {
        unselectedTintColor = NSColor(argb: unselectedColorValue)
      }

      isTranslucent = args["isTranslucent"] as? Bool ?? isTranslucent
    }

    return TabBarStyle(
      items: items,
      selectedIndex: selectedIndex,
      style: style,
      backgroundColor: backgroundColor,
      selectedTintColor: selectedTintColor,
      unselectedTintColor: unselectedTintColor,
      isTranslucent: isTranslucent
    )
  }

  // MARK: - Tab Bar Configuration

  private func configureTabBar(with style: TabBarStyle) {
    tabItems = style.items

    // Set segment count
    segmentedControl.segmentCount = style.items.count

    // Configure each segment
    for (index, itemData) in style.items.enumerated() {
      let label = itemData["label"] as? String ?? ""
      let icon = itemData["icon"] as? String
      let role = itemData["role"] as? String ?? "standard"

      // Set label
      segmentedControl.setLabel(label, forSegment: index)

      // Set image based on role
      if role == "search" {
        // Use system search icon for search role
        if let searchImage = loadImage(named: "magnifyingglass") {
          segmentedControl.setImage(searchImage, forSegment: index)
          segmentedControl.setImageScaling(.scaleProportionallyDown, forSegment: index)
        }
      } else if let iconName = icon {
        // Set image if provided
        if let image = loadImage(named: iconName) {
          segmentedControl.setImage(image, forSegment: index)
          segmentedControl.setImageScaling(.scaleProportionallyDown, forSegment: index)
        }
      }

      // Set width to auto
      segmentedControl.setWidth(0, forSegment: index)
    }

    // Apply styling
    configureTabBarAppearance(with: style)

    // Set selected segment
    if style.selectedIndex >= 0 && style.selectedIndex < style.items.count {
      segmentedControl.selectedSegment = style.selectedIndex
    }

    // Set up action
    segmentedControl.target = self
    segmentedControl.action = #selector(segmentChanged(_:))
  }

  private func configureTabBarAppearance(with style: TabBarStyle) {
    // Set tracking mode
    segmentedControl.trackingMode = .selectOne

    // Apply style
    switch style.style {
    case "compact":
      if #available(macOS 10.13, *) {
        segmentedControl.segmentStyle = .rounded
      }
    case "scrollable":
      // macOS doesn't have scrollable segmented control, use default
      if #available(macOS 10.13, *) {
        segmentedControl.segmentStyle = .automatic
      }
    default:
      if #available(macOS 10.13, *) {
        segmentedControl.segmentStyle = .automatic
      }
    }

    // Apply custom colors if provided
    if let selectedColor = style.selectedTintColor {
      // Note: NSSegmentedControl color customization is limited on macOS
      // This requires subclassing or custom drawing for full color control
      if #available(macOS 10.14, *) {
        // Use appearance proxy or layer-based customization instead
        segmentedControl.layer?.backgroundColor = selectedColor.withAlphaComponent(0.1).cgColor
      }
    }

    // Set control size
    if #available(macOS 11.0, *) {
      segmentedControl.controlSize = .large
    } else {
      segmentedControl.controlSize = .regular
    }
  }

  // MARK: - Image Loading

  private func loadImage(named name: String?) -> NSImage? {
    guard let name = name else { return nil }

    // Try SF Symbol first (macOS 11+)
    if #available(macOS 11.0, *) {
      if let sfImage = NSImage(systemSymbolName: name, accessibilityDescription: nil) {
        return sfImage
      }
    }

    // Fall back to asset catalog
    return NSImage(named: name)
  }

  // MARK: - Layout

  private func setupTabBarLayout() {
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(segmentedControl)

    NSLayoutConstraint.activate([
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      segmentedControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
    ])
  }

  // MARK: - Actions

  @objc private func segmentChanged(_ sender: NSSegmentedControl) {
    let selectedIndex = sender.selectedSegment
    channel.invokeMethod("onTabSelected", arguments: selectedIndex)
  }
}
