import 'package:authentication/model/user_info.dart';

class UserInfoImpl extends UserInfo {
  // test
  final String sdt;
  final String email;

  UserInfoImpl(
      {required super.userGuid,
      required super.userName,
      required this.email,
      required this.sdt});
}
