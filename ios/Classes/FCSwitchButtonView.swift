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
  private var viewModel: Any?

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
    if #available(iOS 15.0, *) {
      let vm = FCSwitchButtonViewModel(config: config)
      viewModel = vm
      let switchView = FCSwitchButtonSwiftUIView(
        viewModel: vm,
        onToggle: { [weak channel] isOn in
          channel?.invokeMethod("onToggle", arguments: isOn)
        }
      )
      hostingController = UIHostingController(rootView: AnyView(switchView))
    } else {
      hostingController = UIHostingController(rootView: AnyView(Text("iOS 15.0+ required")))
    }
    hostingController.view.backgroundColor = .clear

    super.init()

    channel.setMethodCallHandler { [weak self] (call, result) in
      self?.handleMethodCall(call, result: result)
    }
  }

  func view() -> UIView {
    return hostingController.view
  }

  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "updateBrightness":
      if #available(iOS 15.0, *) {
        if let args = call.arguments as? [String: Any],
          let brightness = args["brightness"] as? String,
          let vm = viewModel as? FCSwitchButtonViewModel
        {
          vm.updateBrightness(brightness)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
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
      config.brightness = args["brightness"] as? String ?? config.brightness
    }

    return config
  }
}

// MARK: - Configuration

fileprivate struct FCSwitchButtonConfiguration {
  var label: String = ""
  var isOn: Bool = false
  var onColor: UIColor = .systemGreen
  var isEnabled: Bool = true
  var brightness: String = "light"
}

// MARK: - ViewModel

@available(iOS 15.0, *)
fileprivate class FCSwitchButtonViewModel: ObservableObject {
  @Published var brightness: String
  let config: FCSwitchButtonConfiguration

  init(config: FCSwitchButtonConfiguration) {
    self.config = config
    self.brightness = config.brightness
  }

  func updateBrightness(_ brightness: String) {
    DispatchQueue.main.async {
      self.brightness = brightness
    }
  }
}

// MARK: - SwiftUI View

@available(iOS 15.0, *)
private struct FCSwitchButtonSwiftUIView: View {
  @State private var isOn: Bool
  @ObservedObject var viewModel: FCSwitchButtonViewModel
  let onToggle: (Bool) -> Void

  init(viewModel: FCSwitchButtonViewModel, onToggle: @escaping (Bool) -> Void) {
    self.viewModel = viewModel
    self.onToggle = onToggle
    self._isOn = State(initialValue: viewModel.config.isOn)
  }

  var body: some View {
    let toggle = Toggle(
      viewModel.config.label,
      isOn: Binding(
        get: { isOn },
        set: { newValue in
          isOn = newValue
          onToggle(newValue)
        }
      )
    )
    .tint(Color(viewModel.config.onColor))
    .disabled(!viewModel.config.isEnabled)
    .environment(\.colorScheme, viewModel.brightness == "dark" ? .dark : .light)

    if viewModel.config.label.isEmpty {
      toggle
        .labelsHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      toggle
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
