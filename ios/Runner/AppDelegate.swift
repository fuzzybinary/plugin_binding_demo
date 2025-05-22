import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "fuzzybinary.binding_demo", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "methodCallChannelTest" {
                result("OK")
            } else if call.method == "detectQrCodes"{
                if let arguments = call.arguments as? Dictionary<String, Any?>,
                   let mat = arguments["mat"] as? Dictionary<String, Any?>,
                   let width = mat["width"] as? Int32,
                   let height = mat["height"] as? Int32,
                   let data = mat["data"] as? FlutterStandardTypedData {
                    let detectResult = OpenCVWrapper.detectMarkers(width, height, data)
                    result(detectResult)
                } else {
                    result([
                        "markerIds": [],
                        "markerCorners": [:]
                    ])
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        OpenCVWrapper.setDebugLogging()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
