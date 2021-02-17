import 'package:delala/user/data_provider/user_data.dart';
import 'package:delala/user/models/user.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final UserDataProvider userProvider;

  UserRepository({@required this.userProvider}) : assert(userProvider != null);

  Future<Response> createUser(User user) async {
    return await userProvider.createUser(user);
  }

  Future<User> getUser() async {
    return await userProvider.getUser();
  }

  Future<void> updateUser(User user) async {
    await userProvider.updateUser(user);
  }

  Future<void> deleteUser(String id) async {
    await userProvider.deleteUser(id);
  }
}
