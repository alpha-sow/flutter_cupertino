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
    let buttonView = FCButtonSwiftUIView(
      config: buttonConfig,
      onPressed: { [weak channel] in
        channel?.invokeMethod("onPressed", arguments: nil)
      }
    )

    hostingController = UIHostingController(rootView: AnyView(buttonView.makeButton()))
    hostingController.view.backgroundColor = .clear

    super.init()
  }

  func view() -> UIView {
    return hostingController.view
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
}

// MARK: - SwiftUI View

@available(iOS 15.0, *)
struct FCButtonSwiftUIView {
  let config: FCButtonConfiguration
  let onPressed: () -> Void

  @ViewBuilder
  func makeButton() -> some View {
    switch config.style {
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
      Text(config.title)
    }
    .controlSize(controlSizeFromConfig)
    .tint(tintColor)
    .foregroundColor(foregroundColor)
    .font(.system(size: config.fontSize, weight: .medium))
    .disabled(!config.isEnabled)
  }

  // MARK: - Style Helpers

  private var controlSizeFromConfig: ControlSize {
    switch config.controlSize {
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
    if let bgColor = config.backgroundColor {
      return Color(bgColor)
    }
    return nil
  }

  private var foregroundColor: Color? {
    if let fgColor = config.foregroundColor {
      return Color(fgColor)
    }
    return nil
  }
}
