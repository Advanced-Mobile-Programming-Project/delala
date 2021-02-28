import 'package:delala/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserView extends UserEvent {
  const UserView();

  @override
  List<Object> get props => [];
}

class UserCreateInit extends UserEvent {
  final User user;

  const UserCreateInit(this.user);

  @override
  List<Object> get props => [user];
}

class UserCreateFinishPause extends UserEvent {
  final User user;
  const UserCreateFinishPause(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdate extends UserEvent {
  final User user;

  const UserUpdate(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'User Updated {user: $user}';
}

class UserDelete extends UserEvent {
  final User user;

  const UserDelete(this.user);

  @override
  List<Object> get props => [user];

  @override
  toString() => 'User Deleted {user: $user}';
}
