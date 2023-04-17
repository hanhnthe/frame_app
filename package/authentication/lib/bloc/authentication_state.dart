import 'package:equatable/equatable.dart';

import '../authentication_status.dart';
import '../model/user_info.dart';

///Bkav DucLQ khi vao ung dung xe check cac trang thai xac thuc cua tai khoan de
class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [status, userInfo];

  final AuthenticationStatus status;

  final UserInfo? userInfo;

  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown, this.userInfo});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserInfo userInfo)
      : this._(status: AuthenticationStatus.authenticated, userInfo: userInfo);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
}

class BlocState {}
