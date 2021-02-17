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

class UserOperationFailure extends UserState {
  final Response response;

  UserOperationFailure(this.response);
}

class OperationFailure extends UserState {
  final Exception e;

  OperationFailure(this.e);
}
