import 'package:flutter/material.dart';
import 'package:starshipasteroid/repository/userRepository.dart';

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