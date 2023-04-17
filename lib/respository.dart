import 'package:authentication/model/authentication_api.dart';
import 'package:authentication/model/user_info.dart';

class Repository extends AuthenticationApi {
  @override
  Future<bool> checkExpToken() {
    // TODO: implement checkExpToken
    throw UnimplementedError();
  }

  @override
  Future<UserInfo> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }
}
