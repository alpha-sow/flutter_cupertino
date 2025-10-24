import Cocoa
import FlutterMacOS

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

class FCSliderView: NSView {
  private var slider: NSSlider
  private var channel: FlutterMethodChannel

  private struct SliderStyle {
    let value: Double
    let minimumValue: Double
    let maximumValue: Double
    let minimumTrackTintColor: NSColor
    let isContinuous: Bool
  }

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    slider = NSSlider()
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_slider_\(viewId)",
      binaryMessenger: messenger
    )
    super.init(frame: frame)

    let style = parseArguments(args)
    configureSlider(with: style)
    setupLayout()
    setupMethodChannel()
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
          self.slider.doubleValue = value
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

  // MARK: - Argument Parsing

  private func parseArguments(_ args: Any?) -> SliderStyle {
    var value: Double = 0.5
    var minimumValue: Double = 0.0
    var maximumValue: Double = 1.0
    var minimumTrackTintColor = NSColor.controlAccentColor
    var isContinuous = true

    if let args = args as? [String: Any] {
      value = args["value"] as? Double ?? value
      minimumValue = args["minimumValue"] as? Double ?? minimumValue
      maximumValue = args["maximumValue"] as? Double ?? maximumValue

      if let minColorValue = args["minimumTrackTintColor"] as? Int {
        minimumTrackTintColor = NSColor(argb: minColorValue)
      }

      isContinuous = args["isContinuous"] as? Bool ?? isContinuous
    }

    return SliderStyle(
      value: value,
      minimumValue: minimumValue,
      maximumValue: maximumValue,
      minimumTrackTintColor: minimumTrackTintColor,
      isContinuous: isContinuous
    )
  }

  // MARK: - Slider Configuration

  private func configureSlider(with style: SliderStyle) {
    // Set value range
    slider.minValue = style.minimumValue
    slider.maxValue = style.maximumValue
    slider.doubleValue = style.value

    // Set slider type
    slider.sliderType = .linear

    // Set continuous mode
    slider.isContinuous = style.isContinuous

    // Set target and action
    slider.target = self
    slider.action = #selector(onSliderChanged(_:))

    // Set accessibility
    slider.setAccessibilityRole(.slider)
  }

  // MARK: - Layout

  private func setupLayout() {
    slider.translatesAutoresizingMaskIntoConstraints = false
    addSubview(slider)

    NSLayoutConstraint.activate([
      slider.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      slider.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -16
      ),
      slider.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  // MARK: - Actions

  @objc private func onSliderChanged(_ sender: NSSlider) {
    let value = sender.doubleValue
    // Notify Flutter about the value change
    channel.invokeMethod("valueChanged", arguments: ["value": value])
  }
}
