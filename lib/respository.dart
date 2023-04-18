import 'package:authentication/model/authentication_api.dart';
import 'package:bkav_hrm_app/data/user_info_impl.dart';

class Repository extends AuthenticationApi {
  @override
  Future<bool> checkExpToken() {
    // TODO: implement checkExpToken
    throw UnimplementedError();
  }

  @override
  Future<UserInfoImpl> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }
}
