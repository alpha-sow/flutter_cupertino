import Flutter
import SwiftUI

class FCSwitchButtonFactory: NSObject, FlutterPlatformViewFactory {
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
    return FCSwitchButtonView(
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

class FCSwitchButtonView: NSObject, FlutterPlatformView {
  private var hostingController: UIHostingController<AnyView>
  private var channel: FlutterMethodChannel

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_switch_button_\(viewId)",
      binaryMessenger: messenger
    )

    let config = Self.parseArguments(args)
    let switchView = FCSwitchButtonSwiftUIView(
      config: config,
      onToggle: { [weak channel] isOn in
        channel?.invokeMethod("onToggle", arguments: isOn)
      }
    )

    hostingController = UIHostingController(rootView: AnyView(switchView))
    hostingController.view.backgroundColor = .clear

    super.init()
  }

  func view() -> UIView {
    return hostingController.view
  }

  // MARK: - Argument Parsing

  private static func parseArguments(_ args: Any?) -> FCSwitchButtonConfiguration {
    var config = FCSwitchButtonConfiguration()

    if let args = args as? [String: Any] {
      config.label = args["label"] as? String ?? config.label
      config.isOn = args["isOn"] as? Bool ?? config.isOn

      if let onColorValue = args["onColor"] as? Int {
        config.onColor = UIColor(argb: onColorValue)
      }

      config.isEnabled = args["isEnabled"] as? Bool ?? config.isEnabled
    }

    return config
  }
}

// MARK: - Configuration

private struct FCSwitchButtonConfiguration {
  var label: String = ""
  var isOn: Bool = false
  var onColor: UIColor = .systemGreen
  var isEnabled: Bool = true
}

// MARK: - SwiftUI View

@available(iOS 15.0, *)
private struct FCSwitchButtonSwiftUIView: View {
  @State private var isOn: Bool
  let config: FCSwitchButtonConfiguration
  let onToggle: (Bool) -> Void

  init(config: FCSwitchButtonConfiguration, onToggle: @escaping (Bool) -> Void) {
    self.config = config
    self.onToggle = onToggle
    self._isOn = State(initialValue: config.isOn)
  }

  var body: some View {
    let toggle = Toggle(
      config.label,
      isOn: Binding(
        get: { isOn },
        set: { newValue in
          isOn = newValue
          onToggle(newValue)
        }
      )
    )
    .tint(Color(config.onColor))
    .disabled(!config.isEnabled)
    if config.label.isEmpty {
      toggle
        .labelsHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      toggle
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
