import Cocoa
import FlutterMacOS
import SwiftUI

class FCButtonFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return FCButtonView(
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

// SwiftUI Button View
struct FCButtonSwiftUIView: View {
  let title: String
  let style: String
  let backgroundColor: Color?
  let foregroundColor: Color?
  let fontSize: CGFloat
  let cornerRadius: CGFloat
  let isEnabled: Bool
  let onPressed: () -> Void

  var body: some View {
    Button(action: onPressed) {
      Text(title)
        .font(.system(size: fontSize, weight: .medium))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(minWidth: 80, minHeight: 32)
    }
    .buttonStyle(
      FCButtonStyleAdapter(
        style: style,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        cornerRadius: cornerRadius
      )
    )
    .disabled(!isEnabled)
  }
}

// SwiftUI Button Style Adapter
struct FCButtonStyleAdapter: ButtonStyle {
  let style: String
  let backgroundColor: Color?
  let foregroundColor: Color?
  let cornerRadius: CGFloat

  func makeBody(configuration: Configuration) -> some View {
    switch style {
    case "plain":
      plainStyle(configuration)
    case "gray":
      grayStyle(configuration)
    case "tinted":
      tintedStyle(configuration)
    case "bordered":
      borderedStyle(configuration)
    case "borderedProminent":
      borderedProminentStyle(configuration)
    case "glass":
      glassStyle(configuration)
    case "prominentGlass":
      prominentGlassStyle(configuration)
    case "filled":
      filledStyle(configuration)
    default:
      filledStyle(configuration)
    }
  }

  private func plainStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? .accentColor)
      .opacity(configuration.isPressed ? 0.6 : 1.0)
  }

  private func grayStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? Color(.labelColor))
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(backgroundColor ?? Color(.quaternaryLabelColor))
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func tintedStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? .accentColor)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill((backgroundColor ?? .accentColor).opacity(0.2))
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func borderedStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? .accentColor)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(foregroundColor ?? Color(.separatorColor), lineWidth: 1)
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func borderedProminentStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? .white)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(backgroundColor ?? .accentColor)
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func filledStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? .white)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(backgroundColor ?? .accentColor)
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func glassStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? Color(.labelColor))
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(.ultraThinMaterial)
          .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
              .fill(.white.opacity(0.15))
          )
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }

  private func prominentGlassStyle(_ configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(foregroundColor ?? Color(.labelColor))
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(.thinMaterial)
          .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
              .fill(Color(.systemGray).opacity(0.3))
          )
      )
      .opacity(configuration.isPressed ? 0.8 : 1.0)
  }
}

class FCButtonView: NSView {
  private var hostingView: NSHostingView<FCButtonSwiftUIView>
  private var channel: FlutterMethodChannel

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_button_\(viewId)",
      binaryMessenger: messenger
    )

    // Parse arguments
    var title = "Button"
    var style = "filled"
    var backgroundColor: Color?
    var foregroundColor: Color?
    var fontSize: CGFloat = 13.0
    var cornerRadius: CGFloat = 6.0
    var isEnabled = true

    if let args = args as? [String: Any] {
      if let titleValue = args["title"] as? String {
        title = titleValue
      }
      if let styleValue = args["style"] as? String {
        style = styleValue
      }
      if let bgColorValue = args["backgroundColor"] as? Int {
        backgroundColor = Color(NSColor(argb: bgColorValue))
      }
      if let fgColorValue = args["foregroundColor"] as? Int {
        foregroundColor = Color(NSColor(argb: fgColorValue))
      }
      if let fontSizeValue = args["fontSize"] as? Double {
        fontSize = CGFloat(fontSizeValue)
      }
      if let cornerRadiusValue = args["cornerRadius"] as? Double {
        cornerRadius = CGFloat(cornerRadiusValue)
      }
      if let enabledValue = args["isEnabled"] as? Bool {
        isEnabled = enabledValue
      }
    }

    // Create SwiftUI view
    let swiftUIView = FCButtonSwiftUIView(
      title: title,
      style: style,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      cornerRadius: cornerRadius,
      isEnabled: isEnabled
    ) { [weak channel] in
      channel?.invokeMethod("onPressed", arguments: nil)
    }

    // Wrap in NSHostingView
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

extension NSColor {
  convenience init(argb: Int) {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
