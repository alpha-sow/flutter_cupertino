import Cocoa
import FlutterMacOS
import SwiftUI

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

// Observable state for tab bar
class TabBarState: ObservableObject {
  @Published var selectedIndex: Int

  init(selectedIndex: Int) {
    self.selectedIndex = selectedIndex
  }
}

// SwiftUI Tab Bar View
struct FCTabBarSwiftUIView: View {
  let items: [[String: Any?]]
  @ObservedObject var state: TabBarState
  let style: String
  let backgroundColor: Color?
  let selectedTintColor: Color?
  let unselectedTintColor: Color?
  let onTabSelected: (Int) -> Void

  var body: some View {
    HStack(spacing: 0) {
      ForEach(0..<items.count, id: \.self) { index in
        tabItem(for: index)
      }
    }
    .padding(.horizontal, 8)
    .background(backgroundColor?.opacity(0.1) ?? Color.clear)
  }

  private func tabItem(for index: Int) -> some View {
    let itemData = items[index]
    let label = itemData["label"] as? String ?? ""
    let icon = itemData["icon"] as? String
    let isSelected = state.selectedIndex == index

    return Button(action: {
      state.selectedIndex = index
      onTabSelected(index)
    }) {
      VStack(spacing: 4) {
        if let iconName = icon {
          Image(systemName: iconName)
            .font(.system(size: 16))
        }

        if !label.isEmpty {
          Text(label)
            .font(.system(size: 11))
        }
      }
      .foregroundColor(
        isSelected ? (selectedTintColor ?? .accentColor) : (unselectedTintColor ?? .secondary)
      )
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

class FCTabBarView: NSObject {
  private(set) var view: NSView
  private var hostingView: NSHostingView<FCTabBarSwiftUIView>
  private var channel: FlutterMethodChannel
  private var tabBarState: TabBarState

  init(
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    view = NSView()
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_tabbar_\(viewId)",
      binaryMessenger: messenger
    )

    // Parse arguments
    var items: [[String: Any?]] = []
    var selectedIndex = 0
    var style = "standard"
    var backgroundColor: Color?
    var selectedTintColor: Color?
    var unselectedTintColor: Color?

    if let args = args as? [String: Any] {
      items = args["items"] as? [[String: Any?]] ?? items
      selectedIndex = args["selectedIndex"] as? Int ?? selectedIndex
      style = args["style"] as? String ?? style

      if let bgColorValue = args["backgroundColor"] as? Int {
        backgroundColor = Color(NSColor(argb: bgColorValue))
      }
      if let selectedColorValue = args["selectedTintColor"] as? Int {
        selectedTintColor = Color(NSColor(argb: selectedColorValue))
      }
      if let unselectedColorValue = args["unselectedTintColor"] as? Int {
        unselectedTintColor = Color(NSColor(argb: unselectedColorValue))
      }
    }

    tabBarState = TabBarState(selectedIndex: selectedIndex)

    // Create SwiftUI view
    let swiftUIView = FCTabBarSwiftUIView(
      items: items,
      state: tabBarState,
      style: style,
      backgroundColor: backgroundColor,
      selectedTintColor: selectedTintColor,
      unselectedTintColor: unselectedTintColor
    ) { [weak channel] index in
      channel?.invokeMethod("onTabSelected", arguments: index)
    }

    hostingView = NSHostingView(rootView: swiftUIView)

    super.init()

    // Add hosting view
    hostingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingView)

    NSLayoutConstraint.activate([
      hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingView.topAnchor.constraint(equalTo: view.topAnchor),
      hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
