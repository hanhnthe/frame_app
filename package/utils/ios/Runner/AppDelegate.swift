import UIKit
import Flutter
import FirebaseCore
import LocalAuthentication

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   let controller :FlutterViewController = window?.rootViewController as! FlutterViewController
                 let channel = FlutterMethodChannel(name: "com.bkav.utils/bkav_channel",
                                                                 binaryMessenger: controller.binaryMessenger)

             //chanel
              channel.setMethodCallHandler({ [self]
                  (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                  switch call.method {
                                 case "getBiometricType":
                                   result("\(self.biometricType)")
                                      break
                                 case "getStatusBiometric":
                                  let context = LAContext()
                                     context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: nil)
                                  if let domainState = context.evaluatedPolicyDomainState {
                                         let bData = domainState.base64EncodedData()
                                         if let decodedString = String(data: bData, encoding: .utf8) {
                                             result("\(decodedString)")
                                         }
                                          }else{
                                              result("")
                                          }
                                       break

                                 default : result("86")

                            }
              })

     FirebaseApp.configure()
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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