import Flutter
import SwiftUI

class FCSliderFactory: NSObject, FlutterPlatformViewFactory {
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
    return FCSliderView(
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

class FCSliderView: NSObject, FlutterPlatformView {
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
      name: "flutter_cupertino/fc_slider_\(viewId)",
      binaryMessenger: messenger
    )

    let config = Self.parseArguments(args)
    if #available(iOS 15.0, *) {
      let vm = FCSliderViewModel(config: config)
      viewModel = vm
      let sliderView = FCSliderSwiftUIView(
        viewModel: vm,
        onValueChanged: { [weak channel] value in
          channel?.invokeMethod("valueChanged", arguments: ["value": value])
        }
      )
      hostingController = UIHostingController(rootView: AnyView(sliderView))
    } else {
      hostingController = UIHostingController(rootView: AnyView(Text("iOS 15.0+ required")))
    }
    hostingController.view.backgroundColor = .clear

    super.init()

    setupMethodChannel()
  }

  func view() -> UIView {
    return hostingController.view
  }

  // MARK: - Method Channel Setup

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
          // Update the slider value through the SwiftUI view
          // Note: This requires passing the value to the SwiftUI view
          result(nil)
        } else {
          result(
            FlutterError(code: "INVALID_ARGUMENT", message: "Value must be a double", details: nil))
        }
      case "updateBrightness":
        if #available(iOS 15.0, *) {
          if let args = call.arguments as? [String: Any],
            let brightness = args["brightness"] as? String,
            let vm = viewModel as? FCSliderViewModel
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
  }

  // MARK: - Argument Parsing

  private static func parseArguments(_ args: Any?) -> FCSliderConfiguration {
    var config = FCSliderConfiguration()

    if let args = args as? [String: Any] {
      if let valueDouble = args["value"] as? Double {
        config.value = valueDouble
      }
      if let minDouble = args["minimumValue"] as? Double {
        config.minimumValue = minDouble
      }
      if let maxDouble = args["maximumValue"] as? Double {
        config.maximumValue = maxDouble
      }
      if let minColorValue = args["minimumTrackTintColor"] as? Int {
        config.minimumTrackTintColor = UIColor(argb: minColorValue)
      }
      if let maxColorValue = args["maximumTrackTintColor"] as? Int {
        config.maximumTrackTintColor = UIColor(argb: maxColorValue)
      }
      if let thumbColorValue = args["thumbTintColor"] as? Int {
        config.thumbTintColor = UIColor(argb: thumbColorValue)
      }
      if let continuous = args["isContinuous"] as? Bool {
        config.isContinuous = continuous
      }
      config.brightness = args["brightness"] as? String ?? config.brightness
    }

    return config
  }
}

// MARK: - Configuration

fileprivate struct FCSliderConfiguration {
  var value: Double = 0.5
  var minimumValue: Double = 0.0
  var maximumValue: Double = 1.0
  var minimumTrackTintColor: UIColor = .systemBlue
  var maximumTrackTintColor: UIColor?
  var thumbTintColor: UIColor?
  var isContinuous: Bool = true
  var brightness: String = "light"
}

// MARK: - ViewModel

@available(iOS 15.0, *)
fileprivate class FCSliderViewModel: ObservableObject {
  @Published var brightness: String
  let config: FCSliderConfiguration

  init(config: FCSliderConfiguration) {
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
private struct FCSliderSwiftUIView: View {
  @State private var value: Double
  @ObservedObject var viewModel: FCSliderViewModel
  let onValueChanged: (Double) -> Void

  init(viewModel: FCSliderViewModel, onValueChanged: @escaping (Double) -> Void) {
    self.viewModel = viewModel
    self.onValueChanged = onValueChanged
    self._value = State(initialValue: viewModel.config.value)
  }

  var body: some View {
    Slider(
      value: Binding(
        get: { value },
        set: { newValue in
          value = newValue
          if viewModel.config.isContinuous {
            onValueChanged(newValue)
          }
        }
      ),
      in: viewModel.config.minimumValue...viewModel.config.maximumValue,
      onEditingChanged: { editing in
        if !editing && !viewModel.config.isContinuous {
          onValueChanged(value)
        }
      }
    )
    .tint(Color(viewModel.config.minimumTrackTintColor))
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .environment(\.colorScheme, viewModel.brightness == "dark" ? .dark : .light)
  }
}
