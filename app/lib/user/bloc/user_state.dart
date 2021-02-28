import 'package:delala/user/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoadSuccess extends UserState {
  final Response response;

  UserLoadSuccess([this.response]);
}

class UserCreatePause extends UserState {
  final User user;

  UserCreatePause([this.user]);
}

class UserCreatePage1 extends UserState {}

class UserCreatePage2 extends UserState {}

class UserCreatePage3 extends UserState {}

class UserCreateInitSuccess extends UserState {
  final User user;

  UserCreateInitSuccess([this.user]);
}

class UserCreateInitFailure extends UserState {
  final Map<String, String> errorMap;

  UserCreateInitFailure([this.errorMap]);
}

class UserOperationFailure extends UserState {
  final Response response;

  UserOperationFailure(this.response);
}

class OperationFailure extends UserState {
  OperationFailure();
}
