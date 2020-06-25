import 'package:flutter/material.dart';
/*Pantalla simple que muestra al centro "Cargando..."
Esta pantalla se muestra cuando la aplicacion esta iniciando, 
mas concretamente cuando en el BLOC tiene estado de Uninitialized.
*/
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Cargando...',style: TextStyle(color: Colors.white)) ,
        ),
    );
  }
}