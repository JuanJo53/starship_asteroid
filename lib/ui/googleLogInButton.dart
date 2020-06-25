import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_bloc.dart';
import 'package:starshipasteroid/bloc/login_bloc/login_event.dart';
/*Un Stateless Widget que separa al boton de para Iniciar 
sesion con una cuenta de Google, separada del resto del 
diseño y las vistas de la aplicacion.*/
class GoogleLogInGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(//Boton de la libreria flutter_auth_buttons para Google en Default
      onPressed: (){
        //Al presionar el boton muestra un Snackbar de carga al iniciar sesion.
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Loggin in...'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
        //BlocProvider que nos permite usar el evento a LoginWithGooglePressed.
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed()//Cambia el evento, para luego cambiar al estado usando parton BLOC
        );
      },
    );
  }
}