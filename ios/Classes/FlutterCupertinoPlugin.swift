import Flutter
import UIKit

// MARK: - UIColor Extension

extension UIColor {
  /// Creates a UIColor from an ARGB integer value (Flutter format)
  convenience init(argb: Int) {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

// MARK: - Plugin

public class FlutterCupertinoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    NSLog("FlutterCupertinoPlugin: register() called")

    // Register FCButton platform view
    let fcButtonFactory = FCButtonFactory(messenger: registrar.messenger())
    registrar.register(
      fcButtonFactory,
      withId: "flutter_cupertino/fc_button"
    )

    // Register FCTabBar platform view
    let fcTabBarFactory = FCTabBarFactory(messenger: registrar.messenger())
    registrar.register(
      fcTabBarFactory,
      withId: "flutter_cupertino/fc_tabbar"
    )

    // Register FCSwitchButton platform view
    let fcSwitchButtonFactory = FCSwitchButtonFactory(messenger: registrar.messenger())
    registrar.register(
      fcSwitchButtonFactory,
      withId: "flutter_cupertino/fc_switch_button"
    )

    // Register FCSlider platform view
    let fcSliderFactory = FCSliderFactory(messenger: registrar.messenger())
    registrar.register(
      fcSliderFactory,
      withId: "flutter_cupertino/fc_slider"
    )
  }
}
