import Cocoa
import FlutterMacOS

// Custom view that passes through all mouse events to views beneath it
private class PassThroughView: NSView {
  override func hitTest(_ point: NSPoint) -> NSView? {
    // Return nil to pass mouse events through to views beneath
    return nil
  }
}

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

class FCButtonView: NSView {
  private var button: NSButton
  private var channel: FlutterMethodChannel

  init(
    frame: NSRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    button = NSButton(frame: frame)
    channel = FlutterMethodChannel(
      name: "flutter_cupertino/fc_button_\(viewId)",
      binaryMessenger: messenger
    )
    super.init(frame: frame)

    // Parse arguments
    var title = "Button"
    var style = "filled"
    var backgroundColor: NSColor?
    var foregroundColor: NSColor?
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
        backgroundColor = NSColor(argb: bgColorValue)
      }
      if let fgColorValue = args["foregroundColor"] as? Int {
        foregroundColor = NSColor(argb: fgColorValue)
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

    // Configure button
    button.title = title
    button.font = NSFont.systemFont(ofSize: fontSize, weight: .medium)
    button.isEnabled = isEnabled
    // Ensure the button behaves like a normal push button so it receives clicks
    button.setButtonType(.momentaryPushIn)
    button.target = self
    button.action = #selector(buttonTapped)
    // Allow button to accept first mouse click
    button.acceptsFirstMouse(for: nil)

    // Layout button BEFORE applying style (important for glass effect constraints)
    button.translatesAutoresizingMaskIntoConstraints = false
    addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
      button.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
    ])

    // Apply button style AFTER adding button to view hierarchy
    configureButtonStyle(
      style: style, backgroundColor: backgroundColor, foregroundColor: foregroundColor,
      cornerRadius: cornerRadius)
  }

  private func configureButtonStyle(
    style: String, backgroundColor: NSColor?, foregroundColor: NSColor?, cornerRadius: CGFloat
  ) {
    // Ensure button has layer for all custom styling
    button.wantsLayer = true

    // Clear any default styling
    button.layer?.backgroundColor = NSColor.clear.cgColor
    button.layer?.borderWidth = 0
    button.layer?.borderColor = nil

    switch style {
    case "plain":
      // Plain style - minimal, text-only appearance
      button.isBordered = false
      button.bezelStyle = .inline
      button.layer?.backgroundColor = NSColor.clear.cgColor

      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.controlAccentColor)
      }

    case "gray":
      // Gray style - subtle gray background
      button.bezelStyle = .inline  // Use inline to prevent default bezel drawing
      button.isBordered = false

      if let bgColor = backgroundColor {
        button.layer?.backgroundColor = bgColor.cgColor
      } else {
        // Use a subtle gray background
        if #available(macOS 10.14, *) {
          button.layer?.backgroundColor = NSColor.quaternaryLabelColor.cgColor
        } else {
          button.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.2).cgColor
        }
      }
      button.layer?.cornerRadius = cornerRadius

      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.labelColor)
      }

    case "tinted":
      // Tinted style - accent-colored with subtle background
      button.bezelStyle = .inline  // Use inline to prevent default bezel drawing
      button.isBordered = false

      if let bgColor = backgroundColor {
        button.layer?.backgroundColor = bgColor.withAlphaComponent(0.2).cgColor
      } else {
        button.layer?.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
      }
      button.layer?.cornerRadius = cornerRadius

      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.controlAccentColor)
      }

    case "bordered":
      // Bordered style - outline button
      button.bezelStyle = .inline  // Use inline to prevent default bezel drawing
      button.isBordered = false  // Use custom border via layer
      button.layer?.borderWidth = 1.0
      button.layer?.cornerRadius = cornerRadius

      if let fgColor = foregroundColor {
        button.layer?.borderColor = fgColor.cgColor
        setTitleColor(fgColor)
      } else {
        button.layer?.borderColor = NSColor.separatorColor.cgColor
        setTitleColor(.controlAccentColor)
      }

    case "borderedProminent":
      // Bordered Prominent style - filled accent-colored button
      button.bezelStyle = .inline  // Use inline to prevent default bezel drawing
      button.isBordered = false

      if let bgColor = backgroundColor {
        button.layer?.backgroundColor = bgColor.cgColor
      } else {
        button.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
      }
      button.layer?.cornerRadius = cornerRadius

      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.white)
      }

    case "filled":
      // Filled style - solid background button (default)
      button.bezelStyle = .inline  // Use inline to prevent default bezel drawing
      button.isBordered = false

      if let bgColor = backgroundColor {
        button.layer?.backgroundColor = bgColor.cgColor
      } else {
        button.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
      }
      button.layer?.cornerRadius = cornerRadius

      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.white)
      }

    case "glass":
      // Glass style - true vibrancy effect with blur
      button.bezelStyle = .rounded
      button.isBordered = false
      setupGlassEffect(
        style: style,
        cornerRadius: cornerRadius,
        foregroundColor: foregroundColor
      )

    case "prominentGlass":
      // Prominent Glass style - more visible blur effect
      button.bezelStyle = .rounded
      button.isBordered = false
      setupGlassEffect(
        style: style,
        cornerRadius: cornerRadius,
        foregroundColor: foregroundColor
      )

    default:
      // Default fallback
      button.bezelStyle = .rounded
      button.isBordered = true
      if let fgColor = foregroundColor {
        setTitleColor(fgColor)
      } else {
        setTitleColor(.controlAccentColor)
      }
    }
  }

  private func setTitleColor(_ color: NSColor) {
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color,
      .font: button.font ?? NSFont.systemFont(ofSize: 13, weight: .medium),
    ]
    button.attributedTitle = NSAttributedString(string: button.title, attributes: attributes)
  }

  private func setupGlassEffect(
    style: String,
    cornerRadius: CGFloat,
    foregroundColor: NSColor?
  ) {
    // Store the button's existing constraints before removing
    let existingConstraints = button.constraints

    // Remove the button from superview temporarily to reorder views
    button.removeFromSuperview()

    // Create visual effect view for glass/blur effect (like iOS ultraThinMaterial)
    let visualEffectView = NSVisualEffectView()

    // Use materials that match iOS glass appearance
    if #available(macOS 10.14, *) {
      // contentBackground gives the closest match to iOS .ultraThinMaterial
      visualEffectView.material = .contentBackground
    } else {
      visualEffectView.material = .light
    }

    // Use withinWindow to blend with content behind the button
    visualEffectView.blendingMode = .withinWindow
    visualEffectView.state = .active
    visualEffectView.translatesAutoresizingMaskIntoConstraints = false
    visualEffectView.wantsLayer = true
    visualEffectView.layer?.cornerRadius = cornerRadius
    visualEffectView.layer?.masksToBounds = true

    // Add visual effect view first. Make it ignore mouse events so it doesn't block the button.
    // According to Apple docs, NSVisualEffectView should allow subviews to handle events
    if #available(macOS 10.12.2, *) {
      visualEffectView.allowedTouchTypes = []
    }
    visualEffectView.postsBoundsChangedNotifications = false
    visualEffectView.canDrawConcurrently = true
    addSubview(visualEffectView)

    // Create a tinted overlay layer (like iOS glass buttons have)
    // Use PassThroughView so it doesn't intercept mouse events
    let tintOverlay = PassThroughView()
    tintOverlay.translatesAutoresizingMaskIntoConstraints = false
    tintOverlay.wantsLayer = true
    tintOverlay.layer?.cornerRadius = cornerRadius
    tintOverlay.layer?.masksToBounds = true

    // Apply tint based on style - iOS glass buttons have a subtle white/gray tint
    if style == "prominentGlass" {
      // More visible tint for prominent style
      if #available(macOS 10.14, *) {
        tintOverlay.layer?.backgroundColor = NSColor.systemGray.withAlphaComponent(0.3).cgColor
      } else {
        tintOverlay.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.3).cgColor
      }
    } else {
      // Subtle white tint for regular glass style
      tintOverlay.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.15).cgColor
    }

    // Make overlay not receive mouse events so button remains clickable
    // PassThroughView's hitTest already handles this, but set these for good measure
    tintOverlay.canDrawConcurrently = true
    addSubview(tintOverlay)

    // Constrain tint overlay to visual effect view
    NSLayoutConstraint.activate([
      tintOverlay.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
      tintOverlay.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
      tintOverlay.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
      tintOverlay.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
    ])

    // Add button on top - it will maintain its constraints to parent view
    button.translatesAutoresizingMaskIntoConstraints = false
    addSubview(button)

    // Re-apply button's positioning constraints
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
      button.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
    ])

    // Constrain visual effect view to match button position
    NSLayoutConstraint.activate([
      visualEffectView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
      visualEffectView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
      visualEffectView.topAnchor.constraint(equalTo: button.topAnchor),
      visualEffectView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
    ])

    // Make button background completely transparent
    button.wantsLayer = true
    button.layer?.backgroundColor = NSColor.clear.cgColor
    button.layer?.cornerRadius = cornerRadius
    button.layer?.masksToBounds = false

    // Ensure button doesn't draw its own background
    button.isBordered = false
    button.bezelStyle = .inline

    // Set text color - iOS glass buttons typically use dark text
    if let fgColor = foregroundColor {
      setTitleColor(fgColor)
    } else {
      // Use dark text like iOS glass buttons
      if #available(macOS 10.14, *) {
        setTitleColor(.labelColor)
      } else {
        setTitleColor(.black)
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Allow the view to receive mouse events on first click even when window isn't key
  override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
    return true
  }

  @objc private func buttonTapped() {
    channel.invokeMethod("onPressed", arguments: nil)
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
