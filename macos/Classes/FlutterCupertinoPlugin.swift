import FlutterMacOS
import Cocoa

public class FlutterCupertinoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Register FCButton platform view
    let fcButtonFactory = FCButtonFactory(messenger: registrar.messenger)
    registrar.register(
      fcButtonFactory,
      withId: "flutter_cupertino/fc_button"
    )

    // Register FCTabBar platform view
    let fcTabBarFactory = FCTabBarFactory(messenger: registrar.messenger)
    registrar.register(
      fcTabBarFactory,
      withId: "flutter_cupertino/fc_tabbar"
    )

    // Register FCSwitchButton platform view
    let fcSwitchButtonFactory = FCSwitchButtonFactory(messenger: registrar.messenger)
    registrar.register(
      fcSwitchButtonFactory,
      withId: "flutter_cupertino/fc_switch_button"
    )

    // Register FCSlider platform view
    let fcSliderFactory = FCSliderFactory(messenger: registrar.messenger)
    registrar.register(
      fcSliderFactory,
      withId: "flutter_cupertino/fc_slider"
    )
  }
}
