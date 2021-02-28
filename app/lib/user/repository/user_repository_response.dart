import 'package:delala/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserRepositoryResponse extends Equatable {
  const UserRepositoryResponse();
}

class RUserCreateInitSuccess extends UserRepositoryResponse {
  final int statusCode;
  final User user;

  RUserCreateInitSuccess([this.statusCode, this.user]);

  @override
  List<Object> get props => [statusCode, user];
}

class RUserCreateInitFailure extends UserRepositoryResponse {
  final int statusCode;
  final Map<String, dynamic> errorMap;

  RUserCreateInitFailure([this.statusCode, this.errorMap]);

  @override
  List<Object> get props => [statusCode, errorMap];
}
