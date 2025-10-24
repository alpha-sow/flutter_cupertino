import Cocoa
import FlutterMacOS
import SwiftUI

class FCSliderFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return FCSliderView(
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

// Observable state for slider
class SliderState: ObservableObject {
  @Published var value: Double

  init(value: Double) {
    self.value = value
  }
}

// SwiftUI Slider View
struct FCSliderSwiftUIView: View {
  @ObservedObject var state: SliderState
  let minimumValue: Double
  let maximumValue: Double
  let minimumTrackTintColor: Color?
  let onValueChanged: (Double) -> Void

  var body: some View {
    Slider(
      value: $state.value,
      in: minimumValue...maximumValue
    )
    .padding(.horizontal, 16)
    .accentColor(minimumTrackTintColor ?? .accentColor)
    .onChange(of: state.value) { newValue in
      onValueChanged(newValue)
    }
  }
}

class FCSliderView: NSView {
  private var hostingView: NSHostingView<FCSliderSwiftUIView>
  private var channel: FlutterMethodChannel
  private var sliderState: SliderState

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_slider_\(viewId)",
      binaryMessenger: messenger
    )

    // Parse arguments
    var value: Double = 0.5
    var minimumValue: Double = 0.0
    var maximumValue: Double = 1.0
    var minimumTrackTintColor: Color?

    if let args = args as? [String: Any] {
      value = args["value"] as? Double ?? value
      minimumValue = args["minimumValue"] as? Double ?? minimumValue
      maximumValue = args["maximumValue"] as? Double ?? maximumValue

      if let minColorValue = args["minimumTrackTintColor"] as? Int {
        minimumTrackTintColor = Color(NSColor(argb: minColorValue))
      }
    }

    sliderState = SliderState(value: value)

    // Create SwiftUI view
    let swiftUIView = FCSliderSwiftUIView(
      state: sliderState,
      minimumValue: minimumValue,
      maximumValue: maximumValue,
      minimumTrackTintColor: minimumTrackTintColor
    ) { [weak channel] newValue in
      channel?.invokeMethod("valueChanged", arguments: ["value": newValue])
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

    setupMethodChannel()
  }

  private func setupMethodChannel() {
    channel.setMethodCallHandler {
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "View disposed", details: nil))
        return
      }

      switch call.method {
      case "updateValue":
        if let value = call.arguments as? Double {
          self.sliderState.value = value
          result(nil)
        } else {
          result(
            FlutterError(code: "INVALID_ARGUMENT", message: "Value must be a double", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
