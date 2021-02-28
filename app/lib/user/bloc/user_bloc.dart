import 'package:delala/user/bloc/bloc.dart';
import 'package:delala/user/bloc/user_state.dart';
import 'package:delala/user/repository/user_repository.dart';
import 'package:delala/user/repository/user_repository_response.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(UserLoading());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserCreatePauseEvent) {
      yield UserCreatePause(event.user);
      return;
    } else if (event is UserCreateToPage1) {
      yield UserCreatePage1();
      return;
    } else if (event is UserCreateToPage2) {
      yield UserCreatePage2();
      return;
    } else if (event is UserCreateToPage3) {
      yield UserCreatePage3();
      return;
    }

    if (event is UserView) {
      yield UserLoading();
      try {
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure();
      }
    }

    if (event is UserCreateInit) {
      try {
        UserRepositoryResponse response =
            await userRepository.initCreateUser(event.user);
        yield _handleResponse(response);
      } catch (e) {
        yield OperationFailure();
      }
    }

    if (event is UserUpdate) {
      try {
        await userRepository.updateUser(event.user);
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure();
      }
    }

    if (event is UserDelete) {
      try {
        await userRepository.deleteUser(event.user.id);
        // final user = await userRepository.getUser();
        // yield UserLoadSuccess(user);
      } catch (e) {
        yield OperationFailure();
      }
    }
  }

  UserState _handleResponse(UserRepositoryResponse response) {
    UserState state;

    if (response is RUserCreateInitSuccess) {
      state = UserCreateInitSuccess(response.user);
    } else if (response is RUserCreateInitFailure) {
      state = UserCreateInitFailure(response.errorMap);
    }

    return state;
  }
}
