import 'package:delala/user/bloc/user_bloc.dart';
import 'package:delala/user/bloc/user_event.dart';
import 'package:delala/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(Delala());
}

class Delala extends StatelessWidget {
  final UserRepository userRepository;

  Delala({@required this.userRepository}) : assert(userRepository != null);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: this.userRepository,
      child: BlocProvider(
        create: (context) =>
            UserBloc(userRepository: this.userRepository)..add(UserView()),
        child: MaterialApp(
          title: 'Delala',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // onGenerateRoute: DelalaRoute.generateRoute,
        ),
      ),
    );
  }
}
