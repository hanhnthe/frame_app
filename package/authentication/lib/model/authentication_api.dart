import 'dart:async';

import 'package:authentication/model/user_info.dart';

import '../authentication_status.dart';

abstract class AuthenticationApi {
  final controllerAuthentication = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future.delayed(const Duration(seconds: 2));
    bool isExpToken;
    try {
      isExpToken = await checkExpToken();
    } catch (_) {
      isExpToken = true;
    }
    yield !isExpToken
        ? AuthenticationStatus.unauthenticated
        : AuthenticationStatus.authenticated;
    yield* controllerAuthentication.stream;
  }

  Future<bool> checkExpToken();

  Future<UserInfo> getUserInfo();

  void dispose() {
    controllerAuthentication.close();
  }
}
