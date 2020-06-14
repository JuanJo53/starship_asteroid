import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:starshipasteroid/gameController.dart';

class NewGame extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }

}

class _MyApp extends State<NewGame> {
  GameController gameController;
  void Start()async{
    WidgetsFlutterBinding.ensureInitialized();
    Util flameUtil = Util();

    gameController = GameController();

    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);
    
    TapGestureRecognizer tapper = TapGestureRecognizer();
    tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gameController.widget!=null?gameController.widget:Container(child: Text('hola'),));
  }
  void initState() {
    Start();
  }
}