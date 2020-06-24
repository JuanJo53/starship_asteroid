import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_event.dart';

class GoogleLogInGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      onPressed: (){
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Text('Loggin in...'),
        //         CircularProgressIndicator(),
        //       ],
        //     ),
        //   ),
        // );
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed()
        );
      },
    );
  }
}