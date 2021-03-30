import Flutter
import UIKit

public class SwiftNewFlutterHtmlViewerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.bleuxstrife/new_flutter_html_viewer", binaryMessenger: registrar.messenger())
    let instance = SwiftNewFlutterHtmlViewerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
