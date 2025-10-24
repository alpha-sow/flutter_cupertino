import Cocoa
import FlutterMacOS

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

class FCSwitchButtonView: NSView {
  private var switchControl: NSSwitch
  private var titleLabel: NSTextField?
  private var stackView: NSStackView
  private var channel: FlutterMethodChannel
  private var style: SwitchButtonStyle?

  private struct SwitchButtonStyle {
    let title: String?
    let isOn: Bool
    let onColor: NSColor
    let isEnabled: Bool
  }

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    switchControl = NSSwitch()
    stackView = NSStackView()
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_switch_button_\(viewId)",
      binaryMessenger: messenger
    )
    super.init(frame: frame)

    // Parse arguments
    let style = parseArguments(args)
    self.style = style
    configureSwitch(with: style)
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Argument Parsing

  private func parseArguments(_ args: Any?) -> SwitchButtonStyle {
    var title: String?
    var isOn = false
    var onColor = NSColor.controlAccentColor
    var isEnabled = true

    if let args = args as? [String: Any] {
      title = args["title"] as? String
      isOn = args["isOn"] as? Bool ?? isOn

      if let onColorValue = args["onColor"] as? Int {
        onColor = NSColor(argb: onColorValue)
      }

      isEnabled = args["isEnabled"] as? Bool ?? isEnabled
    }

    return SwitchButtonStyle(
      title: title,
      isOn: isOn,
      onColor: onColor,
      isEnabled: isEnabled
    )
  }

  // MARK: - Switch Configuration

  private func configureSwitch(with style: SwitchButtonStyle) {
    // Configure the switch
    switchControl.state = style.isOn ? .on : .off
    switchControl.isEnabled = style.isEnabled
    switchControl.target = self
    switchControl.action = #selector(switchValueChanged)

    // Set accessibility
    if #available(macOS 10.14, *) {
      switchControl.setAccessibilityRole(.button)
    } else {
      switchControl.setAccessibilityRole(.button)
    }
    switchControl.setAccessibilityValue(style.isOn ? "On" : "Off")

    // Configure title label if title is provided
    if let titleText = style.title, !titleText.isEmpty {
      let label = NSTextField(labelWithString: titleText)
      label.font = NSFont.systemFont(ofSize: 13)
      label.textColor = .labelColor
      titleLabel = label
    }
  }

  // MARK: - Layout

  private func setupLayout() {
    // Configure stack view
    stackView.orientation = .horizontal
    stackView.alignment = .centerY
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    // Add label if it exists
    if let label = titleLabel {
      stackView.addArrangedSubview(label)
    }

    // Add switch
    stackView.addArrangedSubview(switchControl)

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.leadingAnchor.constraint(
        greaterThanOrEqualTo: leadingAnchor,
        constant: 16
      ),
      stackView.trailingAnchor.constraint(
        lessThanOrEqualTo: trailingAnchor,
        constant: -16
      ),
    ])
  }

  // MARK: - Actions

  @objc private func switchValueChanged() {
    let isOn = switchControl.state == .on

    // Update accessibility
    switchControl.setAccessibilityValue(isOn ? "On" : "Off")

    // Notify Flutter
    channel.invokeMethod("onToggle", arguments: isOn)
  }
}
