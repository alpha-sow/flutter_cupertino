import Flutter
import SwiftUI

class FCButtonFactory: NSObject, FlutterPlatformViewFactory {
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
    return FCButtonView(
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

class FCButtonView: NSObject, FlutterPlatformView {
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
      name: "flutter_cupertino/fc_button_\(viewId)",
      binaryMessenger: messenger
    )

    let buttonConfig = Self.parseArguments(args)
    if #available(iOS 15.0, *) {
      let vm = FCButtonViewModel(config: buttonConfig)
      viewModel = vm
      let buttonView = FCButtonSwiftUIView(
        viewModel: vm,
        onPressed: { [weak channel] in
          channel?.invokeMethod("onPressed", arguments: nil)
        }
      )
      hostingController = UIHostingController(rootView: AnyView(buttonView.makeButton()))
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
          let vm = viewModel as? FCButtonViewModel
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

  private static func parseArguments(_ args: Any?) -> FCButtonConfiguration {
    var config = FCButtonConfiguration()

    if let args = args as? [String: Any] {
      config.title = args["title"] as? String ?? config.title
      config.style = args["style"] as? String ?? config.style

      if let bgColorValue = args["backgroundColor"] as? Int {
        config.backgroundColor = UIColor(argb: bgColorValue)
      }
      if let fgColorValue = args["foregroundColor"] as? Int {
        config.foregroundColor = UIColor(argb: fgColorValue)
      }
      if let fontSizeValue = args["fontSize"] as? Double {
        config.fontSize = CGFloat(fontSizeValue)
      }

      config.isEnabled = args["isEnabled"] as? Bool ?? config.isEnabled
      config.controlSize = args["controlSize"] as? String ?? config.controlSize
      config.brightness = args["brightness"] as? String ?? config.brightness
    }

    return config
  }
}

// MARK: - Configuration

struct FCButtonConfiguration {
  var title: String = "Button"
  var style: String = "automatic"
  var backgroundColor: UIColor?
  var foregroundColor: UIColor?
  var fontSize: CGFloat = 17.0
  var isEnabled: Bool = true
  var controlSize: String = "regular"
  var brightness: String = "light"
}

// MARK: - ViewModel

@available(iOS 15.0, *)
class FCButtonViewModel: ObservableObject {
  @Published var brightness: String
  let config: FCButtonConfiguration

  init(config: FCButtonConfiguration) {
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
struct FCButtonSwiftUIView {
  @ObservedObject var viewModel: FCButtonViewModel
  let onPressed: () -> Void

  @ViewBuilder
  func makeButton() -> some View {
    switch viewModel.config.style {
    case "bordered":
      baseButton.buttonStyle(.bordered)
    case "borderedProminent":
      baseButton.buttonStyle(.borderedProminent)
    case "borderless":
      baseButton.buttonStyle(.borderless)
    case "plain":
      baseButton.buttonStyle(.plain)
    case "glass":
      if #available(iOS 26.0, *) {
        baseButton.buttonStyle(.glass)
      } else {
        baseButton.buttonStyle(.bordered)
      }
    case "glassProminent":
      if #available(iOS 26.0, *) {
        baseButton.buttonStyle(.glassProminent)
      } else {
        baseButton.buttonStyle(.borderedProminent)
      }
    default:
      baseButton.buttonStyle(.automatic)
    }
  }

  private var baseButton: some View {
    Button(action: onPressed) {
      Text(viewModel.config.title)
    }
    .controlSize(controlSizeFromConfig)
    .tint(tintColor)
    .foregroundColor(foregroundColor)
    .font(.system(size: viewModel.config.fontSize, weight: .medium))
    .disabled(!viewModel.config.isEnabled)
    .environment(\.colorScheme, viewModel.brightness == "dark" ? .dark : .light)
  }

  // MARK: - Style Helpers

  private var controlSizeFromConfig: ControlSize {
    switch viewModel.config.controlSize {
    case "mini":
      return .mini
    case "small":
      return .small
    case "large":
      return .large
    default:
      return .regular
    }
  }

  private var tintColor: Color? {
    if let bgColor = viewModel.config.backgroundColor {
      return Color(bgColor)
    }
    return nil
  }

  private var foregroundColor: Color? {
    if let fgColor = viewModel.config.foregroundColor {
      return Color(fgColor)
    }
    return nil
  }
}
