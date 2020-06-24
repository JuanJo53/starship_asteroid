import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_event.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:starshipasteroid/ui/googleLogInButton.dart';
class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key,@required UserRepository userRepository })
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key:key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider<LoginBloc>(
        create: (context)=>LoginBloc(userRepository: _userRepository),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: GoogleLogInGoogle(),
        )
      ),
    );
  }
}