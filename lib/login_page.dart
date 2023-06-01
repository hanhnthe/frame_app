import 'package:flutter/material.dart';
import 'package:utils/biometric_utils.dart';
import 'package:utils/utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          
          child: TextButton(
            child: const Text(" Login Page"),
            onPressed: () async {
              // Test
              // Utils.launchPhoneUrl("0362326789");
              // Utils.launchMailUrl("hanh@gmail.com");
              await Utils.saveUserIdInSharePref(
                  userIdentifier: "userIdentifier");
              bool isSupport = await BiometricUtils.isBiometrics();
              bool check = await BiometricUtils.checkBiometricsFaceIdIos();

              debugPrint(" isSupport = $isSupport  --- check = $check");
            },
          ),
        ),
      ),
    );
  }
}
