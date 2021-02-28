import 'dart:convert';

import 'package:delala/config/constants.dart';
import 'package:delala/user/models/user.dart';
import 'package:delala/utils/request.maker.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserDataProvider {
  final http.Client httpClient;

  UserDataProvider({@required this.httpClient}) : assert(httpClient != null);

  Future<http.Response> initCreateUser(User user) async {
    var requester = HttpRequester(path: "/oauth/user/register");
    // var response = await http.post(requester.requestURL,
    //     headers: <String, String>{
    //       'Content-Type': 'application/x-www-form-urlencoded',
    //     },
    //     body: json.encode(user.toJson()));

    var response = http.Response("Hello", 200);
    return response;
  }

  Future<User> getUser() async {
    final response = await httpClient.get('$BaseURI/courses');

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body) as User;
      return user;
    } else {
      throw Exception('Failed to load user.');
    }
  }

  Future<void> deleteUser(String id) async {
    final http.Response response = await httpClient.delete(
      '$BaseURI/courses/$id',
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
      '$BaseURI/courses/${user.id}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update user.');
    }
  }

  Future<void> _makeRequest(String userName, String phoneNumber) async {}
}
