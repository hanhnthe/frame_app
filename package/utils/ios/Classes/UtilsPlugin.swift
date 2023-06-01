import Flutter
import UIKit
import LocalAuthentication

public class UtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.bkav.utils/bkav_channel", binaryMessenger: registrar.messenger())
    let instance = UtilsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   switch call.method {
            case "getBiometricType":
                  result("\(self.biometricType)")
              break
            default:
                result(nil)
            }
   }
      enum BiometricType: String {
              case none = ""
              case touchID = "Touch ID"
              case faceID = "Face ID"
          }

          var biometricType: BiometricType {
              var error: NSError?

              let context = LAContext()

              _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

              if error?.code == LAError.Code.touchIDNotAvailable.rawValue {
                  return .none
              }

              if #available(iOS 11.0, *) {
                  switch context.biometryType {
                  case .none:
                      return .none
                  case .touchID:
                      return .touchID
                  case .faceID:
                      return .faceID
                  }
              } else {
                  return  context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
              }
      }
}
