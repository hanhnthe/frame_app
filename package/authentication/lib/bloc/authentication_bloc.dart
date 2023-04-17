import 'dart:async';

import 'package:authentication/model/authentication_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication_status.dart';
import '../model/user_info.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authenticationApiImpl)
      : super(const AuthenticationState.unknown()) {
    // Dang ky de xu ly cac event, khi nhan event thi goi ham de xu ly
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    // Thuc hien xu ly de lang nghe status luon ngay khi vao app, sau khi nhan duoc
    // status tu repository thi emit event AuthenticationStatusChanged voi data = status
    _authenticationStatusSubscription = _authenticationApiImpl.status
        .listen((status) => add(AuthenticationStatusChanged(status)));
  }

  final AuthenticationApi _authenticationApiImpl;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  void _onAuthenticationStatusChanged(AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit) async {
    debugPrint("nhungltk onAuthenticationStatusChanged: ${event.status}");
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        final userInfo = await _getUserinfo();
        return emit(userInfo != null
            ? AuthenticationState.authenticated(userInfo)
            : const AuthenticationState.unauthenticated());
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  @override
  Future<void> close() {
    //Huy dang ky steam
    _authenticationStatusSubscription.cancel();
    _authenticationApiImpl.dispose();
    return super.close();
  }

  Future<UserInfo?> _getUserinfo() async {
    try {
      return _authenticationApiImpl.getUserInfo();
    } catch (_) {
      return null;
    }
  }
}
