import 'dart:convert';

import 'package:delala/user/models/user.dart';
import 'package:delala/utils/request.maker.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserDataProvider {
  final _baseUrl = 'http://192.168.56.1:3000';
  final http.Client httpClient;

  UserDataProvider({@required this.httpClient}) : assert(httpClient != null);

  Future<http.Response> createUser(User user) async {
    var requester = HttpRequester(path: "/oauth/user/register/init");
    try {
      var response =
          await http.post(requester.requestURL, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: <String, String>{
        'user_name': user.userName,
        'phone_number': user.phoneNumber,
      });

      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future<User> getUser() async {
    final response = await httpClient.get('$_baseUrl/courses');

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body) as User;
      return user;
    } else {
      throw Exception('Failed to load user.');
    }
  }

  Future<void> deleteUser(String id) async {
    final http.Response response = await httpClient.delete(
      '$_baseUrl/courses/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user.');
    }
  }

  Future<void> updateUser(User user) async {
    final http.Response response = await httpClient.put(
      '$_baseUrl/courses/${user.id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': user.id,
        'user_name': user.userName,
        'phone_number': user.phoneNumber,
        'category': user.category,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update user.');
    }
  }

  Future<void> _makeRequest(String userName, String phoneNumber) async {}
}
