import 'dart:io';

import 'package:delala/user/bloc/bloc.dart';
import 'package:delala/user/bloc/user_state.dart';
import 'package:delala/user/repository/user_repository.dart';
import 'package:http/http.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(UserLoading());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserView) {
      yield UserLoading();
      try {
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure(e);
      }
    }

    if (event is UserCreate) {
      try {
        Response response = await userRepository.createUser(event.user);
        yield _handleResponse(response);
      } catch (e) {
        yield OperationFailure(e);
      }
    }

    if (event is UserUpdate) {
      try {
        await userRepository.updateUser(event.user);
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure(e);
      }
    }

    if (event is UserDelete) {
      try {
        await userRepository.deleteUser(event.user.id);
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure(e);
      }
    }
  }

  UserState _handleResponse(Response response) {
    UserState state;
    if (response.statusCode == HttpStatus.ok) {
      state = UserLoadSuccess(response);
    } else {
      state = UserOperationFailure(response);
    }

    return state;
  }
}
