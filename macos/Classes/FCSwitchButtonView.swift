import Cocoa
import FlutterMacOS
import SwiftUI

class FCSwitchButtonFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return FCSwitchButtonView(
      frame: .zero,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger
    )
  }

  func createArgsCodec() -> (any FlutterMessageCodec & NSObjectProtocol)? {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

// Observable state for switch
class SwitchState: ObservableObject {
  @Published var isOn: Bool

  init(isOn: Bool) {
    self.isOn = isOn
  }
}

// SwiftUI Switch View
struct FCSwitchSwiftUIView: View {
  let title: String?
  @ObservedObject var state: SwitchState
  let onColor: Color?
  let isEnabled: Bool
  let onToggle: (Bool) -> Void

  var body: some View {
    HStack(spacing: 8) {
      if let title = title, !title.isEmpty {
        Text(title)
          .font(.system(size: 13))
      }

      Toggle("", isOn: $state.isOn)
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle(tint: onColor ?? .accentColor))
        .disabled(!isEnabled)
        .onChange(of: state.isOn) { newValue in
          onToggle(newValue)
        }
    }
    .padding(.horizontal, 16)
  }
}

class FCSwitchButtonView: NSView {
  private var hostingView: NSHostingView<FCSwitchSwiftUIView>
  private var channel: FlutterMethodChannel
  private var switchState: SwitchState

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_switch_button_\(viewId)",
      binaryMessenger: messenger
    )

    // Parse arguments
    var title: String?
    var isOn = false
    var onColor: Color?
    var isEnabled = true

    if let args = args as? [String: Any] {
      title = args["title"] as? String
      isOn = args["isOn"] as? Bool ?? isOn

      if let onColorValue = args["onColor"] as? Int {
        onColor = Color(NSColor(argb: onColorValue))
      }

      isEnabled = args["isEnabled"] as? Bool ?? isEnabled
    }

    switchState = SwitchState(isOn: isOn)

    // Create SwiftUI view
    let swiftUIView = FCSwitchSwiftUIView(
      title: title,
      state: switchState,
      onColor: onColor,
      isEnabled: isEnabled
    ) { [weak channel] newValue in
      channel?.invokeMethod("onToggle", arguments: newValue)
    }

    hostingView = NSHostingView(rootView: swiftUIView)

    super.init(frame: frame)

    // Add hosting view
    hostingView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hostingView)

    NSLayoutConstraint.activate([
      hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
      hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
      hostingView.topAnchor.constraint(equalTo: topAnchor),
      hostingView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
