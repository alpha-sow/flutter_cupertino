import Flutter
import SwiftUI

/// Configuration for a bar button item
struct FCBarButtonConfiguration {
    var style: String = "plain"
    var systemItem: String?
    var systemIconName: String?
    var imageName: String?
    var title: String?
    var tintColor: UIColor?
    var width: CGFloat?
    var isEnabled: Bool = true
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var tag: Int?
    var landscapeImagePhone: String?
}

/// A SwiftUI button that mimics UIBarButtonItem functionality
@available(iOS 15.0, *)
struct FCBarButtonItemView: View {
    let config: FCBarButtonConfiguration
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            buttonContent
        }
        .disabled(!config.isEnabled)
        .tint(config.tintColor.map { Color($0) })
        .frame(width: config.width)
        .accessibilityLabel(config.accessibilityLabel ?? "")
        .accessibilityHint(config.accessibilityHint ?? "")
        .tag(config.tag ?? 0)
    }

    @ViewBuilder
    private var buttonContent: some View {
        if let systemIconName = config.systemIconName {
            Image(systemName: systemIconName)
        } else if let imageName = config.imageName {
            Image(imageName)
        } else if let title = config.title {
            Text(title)
        } else if let systemItem = config.systemItem {
            systemItemContent(systemItem)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func systemItemContent(_ item: String) -> some View {
        switch item {
        case "done":
            Text("Done")
        case "cancel":
            Text("Cancel")
        case "edit":
            Text("Edit")
        case "save":
            Text("Save")
        case "add":
            Image(systemName: "plus")
        case "compose":
            Image(systemName: "square.and.pencil")
        case "reply":
            Image(systemName: "arrowshape.turn.up.left")
        case "action":
            Image(systemName: "square.and.arrow.up")
        case "organize":
            Image(systemName: "folder")
        case "bookmarks":
            Image(systemName: "book")
        case "search":
            Image(systemName: "magnifyingglass")
        case "refresh":
            Image(systemName: "arrow.clockwise")
        case "stop":
            Image(systemName: "xmark")
        case "camera":
            Image(systemName: "camera")
        case "trash":
            Image(systemName: "trash")
        case "play":
            Image(systemName: "play")
        case "pause":
            Image(systemName: "pause")
        case "rewind":
            Image(systemName: "backward")
        case "fastForward":
            Image(systemName: "forward")
        case "undo":
            Image(systemName: "arrow.uturn.backward")
        case "redo":
            Image(systemName: "arrow.uturn.forward")
        case "close":
            Image(systemName: "xmark")
        default:
            EmptyView()
        }
    }
}

/// A custom UIBarButtonItem that can be configured from Flutter (UIKit compatibility)
class FCUIBarButtonItem: UIBarButtonItem {

    // MARK: - Properties

    /// Target object that handles the tap action
    /// Must be stored to prevent deallocation
    private var buttonTarget: BarButtonTarget?

    // MARK: - Initialization from Flutter Parameters

    /// Creates a bar button item from Flutter parameters
    convenience init?(params: [String: Any], onTap: @escaping () -> Void) {
        // Determine button style
        let styleString = params["style"] as? String ?? "plain"
        let style: UIBarButtonItem.Style = {
            switch styleString {
            case "done":
                return .done
            case "plain":
                return .plain
            default:
                return .plain
            }
        }()

        // Initialize with a temporary target/action - will be set properly below
        // Check if we have a system item
        if let systemItemString = params["systemItem"] as? String {
            let systemItem = FCUIBarButtonItem.systemItem(from: systemItemString)
            self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        }
        // Check if we have a system icon name (SF Symbol)
        else if let systemIconName = params["systemIconName"] as? String {
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: systemIconName)
                self.init(image: image, style: style, target: nil, action: nil)
            } else {
                // Fallback to title for older iOS
                self.init(title: systemIconName, style: style, target: nil, action: nil)
            }
        }
        // Check if we have an image name
        else if let imageName = params["imageName"] as? String {
            let image = UIImage(named: imageName)
            self.init(image: image, style: style, target: nil, action: nil)
        }
        // Check if we have a title
        else if let title = params["title"] as? String {
            self.init(title: title, style: style, target: nil, action: nil)
        }
        // Default: create empty button
        else {
            self.init()
        }

        // Create target object that will handle the tap
        // IMPORTANT: Store it as a property to prevent deallocation
        let target = BarButtonTarget(callback: onTap)
        self.buttonTarget = target

        // Setup target and action
        self.target = target
        self.action = #selector(BarButtonTarget.handleTap)

        // Configure additional properties
        configureProperties(from: params)
    }

    // MARK: - Configuration

    private func configureProperties(from params: [String: Any]) {
        // Tint color
        if let tintColorValue = params["tintColor"] as? Int {
            self.tintColor = UIColor(argb: tintColorValue)
        }

        // Width
        if let width = params["width"] as? CGFloat {
            self.width = width
        }

        // Enabled state
        if let isEnabled = params["isEnabled"] as? Bool {
            self.isEnabled = isEnabled
        }

        // Accessibility label
        if let accessibilityLabel = params["accessibilityLabel"] as? String {
            self.accessibilityLabel = accessibilityLabel
        }

        // Accessibility hint
        if let accessibilityHint = params["accessibilityHint"] as? String {
            self.accessibilityHint = accessibilityHint
        }

        // Tag
        if let tag = params["tag"] as? Int {
            self.tag = tag
        }

        // Landscape image phone (compact width)
        if #available(iOS 13.0, *) {
            if let landscapeIconName = params["landscapeImagePhone"] as? String {
                self.landscapeImagePhone = UIImage(systemName: landscapeIconName)
            }
        }

        // Possibile future: custom view
        // Note: Custom views from Flutter would need special handling
    }

    // MARK: - System Item Mapping

    private static func systemItem(from string: String) -> UIBarButtonItem.SystemItem {
        switch string {
        case "done":
            return .done
        case "cancel":
            return .cancel
        case "edit":
            return .edit
        case "save":
            return .save
        case "add":
            return .add
        case "flexibleSpace":
            return .flexibleSpace
        case "fixedSpace":
            return .fixedSpace
        case "compose":
            return .compose
        case "reply":
            return .reply
        case "action":
            return .action
        case "organize":
            return .organize
        case "bookmarks":
            return .bookmarks
        case "search":
            return .search
        case "refresh":
            return .refresh
        case "stop":
            return .stop
        case "camera":
            return .camera
        case "trash":
            return .trash
        case "play":
            return .play
        case "pause":
            return .pause
        case "rewind":
            return .rewind
        case "fastForward":
            return .fastForward
        case "undo":
            if #available(iOS 13.0, *) {
                return .undo
            }
            return .action
        case "redo":
            if #available(iOS 13.0, *) {
                return .redo
            }
            return .action
        case "close":
            if #available(iOS 13.0, *) {
                return .close
            }
            return .done
        default:
            return .done
        }
    }

    // MARK: - Lifecycle

    deinit {
        print("FCUIBarButtonItem: deinit")
    }

    // MARK: - Static Configuration Parser

    static func parseConfiguration(from params: [String: Any]) -> FCBarButtonConfiguration {
        var config = FCBarButtonConfiguration()

        config.style = params["style"] as? String ?? "plain"
        config.systemItem = params["systemItem"] as? String
        config.systemIconName = params["systemIconName"] as? String
        config.imageName = params["imageName"] as? String
        config.title = params["title"] as? String

        if let tintColorValue = params["tintColor"] as? Int {
            config.tintColor = UIColor(argb: tintColorValue)
        }

        config.width = params["width"] as? CGFloat
        config.isEnabled = params["isEnabled"] as? Bool ?? true
        config.accessibilityLabel = params["accessibilityLabel"] as? String
        config.accessibilityHint = params["accessibilityHint"] as? String
        config.tag = params["tag"] as? Int
        config.landscapeImagePhone = params["landscapeImagePhone"] as? String

        return config
    }
}

/// Target object for handling bar button actions
private class BarButtonTarget: NSObject {
    let callback: () -> Void

    init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init()
    }

    @objc func handleTap() {
        NSLog("BarButtonTarget: handleTap called")
        callback()
    }
}
