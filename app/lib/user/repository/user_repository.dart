import 'dart:convert';
import 'dart:io';

import 'package:delala/models/errors.dart';
import 'package:delala/user/data_provider/user_data.dart';
import 'package:delala/user/models/user.dart';
import 'package:delala/user/repository/user_repository_response.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final UserDataProvider dataProvider;

  UserRepository({@required this.dataProvider}) : assert(dataProvider != null);

  Future<UserRepositoryResponse> initCreateUser(User user) async {
    Response response = await dataProvider.initCreateUser(user);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return RUserCreateInitSuccess(response.statusCode, user);
      case HttpStatus.badRequest:
        Map<String, dynamic> jsonData = json.decode(response.body);
        return RUserCreateInitFailure(response.statusCode, jsonData);
      case HttpStatus.internalServerError:
        return RUserCreateInitFailure(
            response.statusCode, {"error": FailedOperationError});
      default:
        return RUserCreateInitFailure(
            response.statusCode, {"error": SomethingWentWrongError});
    }
  }

  Future<User> getUser() async {
    return await dataProvider.getUser();
  }

  Future<void> updateUser(User user) async {
    await dataProvider.updateUser(user);
  }

  Future<void> deleteUser(String id) async {
    await dataProvider.deleteUser(id);
  }
}
