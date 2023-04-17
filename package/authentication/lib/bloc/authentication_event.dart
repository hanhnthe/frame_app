import 'package:equatable/equatable.dart';

import '../authentication_status.dart';

class AuthenticationEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {

  final AuthenticationStatus status;

  AuthenticationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}





