import 'package:flutter/material.dart';
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
            onPressed: () {
              // Test
              // Utils.launchPhoneUrl("0362326789");
              // Utils.launchMailUrl("hanh@gmail.com");

            },
          ),
        ),
      ),
    );
  }
}
