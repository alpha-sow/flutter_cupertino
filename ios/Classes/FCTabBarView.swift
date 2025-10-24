import Flutter
import SwiftUI

class FCTabBarFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return FCTabBarView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger
    )
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class FCTabBarView: NSObject, FlutterPlatformView {
  private var hostingController: UIHostingController<AnyView>
  private var channel: FlutterMethodChannel

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_tabbar_\(viewId)",
      binaryMessenger: messenger
    )

    let config = Self.parseArguments(args)

    if #available(iOS 18.0, *) {
      let tabBarView = FCTabBarSwiftUIView(
        config: config,
        onTabSelected: { [weak channel] index in
          channel?.invokeMethod("onTabSelected", arguments: index)
        }
      )
      hostingController = UIHostingController(rootView: AnyView(tabBarView))
    } else {
      // Fallback for older iOS versions
      hostingController = UIHostingController(rootView: AnyView(Text("iOS 18.0+ required")))
    }
    hostingController.view.backgroundColor = .clear

    super.init()
  }

  func view() -> UIView {
    return hostingController.view
  }

  // MARK: - Argument Parsing

  private static func parseArguments(_ args: Any?) -> FCTabBarConfiguration {
    var config = FCTabBarConfiguration()

    if let args = args as? [String: Any] {
      if let items = args["items"] as? [[String: Any?]] {
        config.items = items.map { itemData in
          TabItem(
            label: itemData["label"] as? String ?? "",
            icon: itemData["icon"] as? String,
            badge: itemData["badge"] as? String,
            role: itemData["role"] as? String ?? "standard"
          )
        }
      }

      config.selectedIndex = args["selectedIndex"] as? Int ?? config.selectedIndex
      config.style = args["style"] as? String ?? config.style

      if let bgColorValue = args["backgroundColor"] as? Int {
        config.backgroundColor = UIColor(argb: bgColorValue)
      }
      if let selectedColorValue = args["selectedTintColor"] as? Int {
        config.selectedTintColor = UIColor(argb: selectedColorValue)
      }
      if let unselectedColorValue = args["unselectedTintColor"] as? Int {
        config.unselectedTintColor = UIColor(argb: unselectedColorValue)
      }

      config.isTranslucent = args["isTranslucent"] as? Bool ?? config.isTranslucent
    }

    return config
  }
}

// MARK: - Configuration

private struct TabItem {
  let label: String
  let icon: String?
  let badge: String?
  let role: String
}

private struct FCTabBarConfiguration {
  var items: [TabItem] = []
  var selectedIndex: Int = 0
  var style: String = "standard"
  var backgroundColor: UIColor?
  var selectedTintColor: UIColor?
  var unselectedTintColor: UIColor?
  var isTranslucent: Bool = true
}

// MARK: - SwiftUI View

@available(iOS 18.0, *)
private struct FCTabBarSwiftUIView: View {
  @State private var selectedIndex: Int
  let config: FCTabBarConfiguration
  let onTabSelected: (Int) -> Void

  init(config: FCTabBarConfiguration, onTabSelected: @escaping (Int) -> Void) {
    self.config = config
    self.onTabSelected = onTabSelected
    self._selectedIndex = State(initialValue: config.selectedIndex)
  }

  var body: some View {
    TabView(
      selection: Binding(
        get: { selectedIndex },
        set: { newValue in
          selectedIndex = newValue
          onTabSelected(newValue)
        }
      )
    ) {
      ForEach(Array(config.items.enumerated()), id: \.offset) { index, item in
        if item.role == "search" {
          Tab(value: index, role: .search) {
            Color.clear
          } label: {
            if let iconName = item.icon {
              Image(systemName: iconName)
            }
          }
          .badge(item.badge.map { Text($0) })
        } else {
          Tab(value: index) {
            Color.clear
          } label: {
            if let iconName = item.icon {
              Label(item.label, systemImage: iconName)
            } else {
              Text(item.label)
            }
          }
          .badge(item.badge.map { Text($0) })
        }
      }
    }
    .tint(config.selectedTintColor.map { Color($0) })
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
