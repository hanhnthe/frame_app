package com.example.utils

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.bkav.utils/bkav_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // This method is invoked on the main thread.
            // TODO
            if (call.method == "getBiometricType") {
                println(" is call ok ------------------ ")
//                val batteryLevel = getBatteryLevel()
//
//                if (batteryLevel != -1) {
//                    result.success(batteryLevel)
//                } else {
//                    result.error("UNAVAILABLE", "Battery level not available.", null)
//                }

            } else {
                println(" is call false =====================")
                result.notImplemented()
            }
        }
    }
}
