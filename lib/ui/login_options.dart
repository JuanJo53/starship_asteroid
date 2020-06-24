import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import 'package:starshipasteroid/bloc/login_bloc/bloc.dart';
import 'package:starshipasteroid/repository/userRepository.dart';
import 'package:starshipasteroid/ui/googleLogInButton.dart';

class LoginOptions extends StatefulWidget {
  final UserRepository _userRepository;

  LoginOptions({Key key,@required UserRepository userRepository}) 
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  LoginBloc _loginBloc;
  UserRepository get _userRepository=>widget._userRepository;
  @override
  void initState() {
    super.initState();
    _loginBloc=BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc,LoginState>(
      listener: (context,state){
        if(state.isFailure){
          Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                children: <Widget>[
                  Text('Login Failed'),
                  Icon(Icons.error),
                ],
              ),
              backgroundColor: Colors.red,
            )
          );
        }
        if(state.isSuccess){
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc,LoginState>(
        builder: (context,state){
          return Center(
            child: GoogleLogInGoogle(),
          );
        }
      ),
    );
  }
}