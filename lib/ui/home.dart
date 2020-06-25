import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:starshipasteroid/bloc/authentication_bloc/authentication_event.dart';
import '../gameController.dart';
import '../newGame.dart';
import '../rankView.dart';

class Home extends StatefulWidget{  
  final String userName;//Parametro del nombre de usuario
  final String userImage;//Parametro del URL de la imagen del usuario

  //Constructor de la clase con los dos parametros especificados.
  const Home({Key key, this.userName, this.userImage}) : super(key: key);
  //Al ser un StatefulWidget debemos pasar los mismos parametros a otra clase.
  @override
  State<StatefulWidget> createState() {
    return _Home(userName: userName, userImage: userImage);
  }
}
//
class _Home extends State<Home> {
  final String userName;//Parametro del nombre de usuario
  final String userImage;//Parametro del URL de la imagen del usuario
  
  Size size;//Lo usaremos para determinar tamaños en base al tamaño de la pantalla.
  GameController gameController;//GameController para cuando iniciemos nueva partida.
  AudioPlayer menuAudio;//Para la musica de fondo que estara en loop.
  bool playingMenuAudio=true;//Indica si se esta reproduciendo la musica de fondo o no.
  IconData musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');//Icono inicial del boton para mutear la musica de fondo
  @override
  void initState(){
    gameController=GameController();
    startMnuAudio();//Funcion que inicia el loop de la cancion de fondo.
  }
  _Home({Key key, @required this.userName,@required this.userImage});

  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;//Determinamos el tamaño de toda la pantalla del dispositivo.
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), 
                fit: BoxFit.cover
              )
            ),  
            child: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,//Centramos todo los elementos del Column
                  //Aqui creamos los elementos del menu principal del juego.
                  children: <Widget>[
                    //Titulo Starship Asteroid
                    new Image.asset('assets/images/titulo1.png',fit: BoxFit.cover,),
                    //Boton de "Play" para iniciar juego nuevo.
                    new RaisedButton(
                      splashColor: Colors.lightBlue,
                      color: Colors.black,
                      child: new Text("Play",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: ()async{
                        gameController.newGame=true;//Iniciamos nuevo juego.
                        menuAudio.stop();//Detenemos la musica de fondo.
                        playingMenuAudio=false;//Ya no se esta reproduciendo la musica de fondo

                        //Navegamos a la Pantalla "NewGame" donde tenemos nuestro juego.
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=>new NewGame()));
                      },
                    ),
                    //Boton para mostrar el Ranking de los jugadores en el juego.
                    new RaisedButton(
                      splashColor: Colors.lightBlue,
                      color: Colors.black,
                      child: new Text("Rank",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: ()async{
                        //Navegamos a la pantalla del rank de los jugadores.
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=>RankView()));
                      },
                    ),
                    //Boton para cambiar de cuenta.
                    new RaisedButton(
                      splashColor: Colors.lightBlue,
                      color: Colors.black,
                      child: new Text("Change Account",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: (){                        
                        menuAudio.stop();//Se detiene la cancion de fondo
                        playingMenuAudio=false;//Ya no se esta reproduciendo la musica de fondo

                        //Por medio del BlocProvider, cambiamos de evento de Autenticacion a LoggedOut, para luego tambien cambiar su estado.
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                      },
                    ),
                    //Boton para salir del juego.
                    new RaisedButton(
                      splashColor: Colors.lightBlue,
                      color: Colors.black,
                      child: new Text("Quit Game",style: new TextStyle(fontSize: 20.0,color: Colors.lightGreenAccent),),
                      onPressed: (){
                        menuAudio.stop();//Se detiene la cancion de fondo
                        playingMenuAudio=false;//Ya no se esta reproduciendo la musica de fondo

                        //Por medio del BlocProvider, cambiamos de evento de Autenticacion a LoggedOut, para luego tambien cambiar su estado.
                        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());

                        SystemNavigator.pop();//Cerramos la apliacion.
                      },
                    ),
                  ],
                ),
            ),
          ),
          //Container que tiene el nombre y la imagen del jugador autenticado actualmente. 
          Container(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),                  
                  child: Image(
                    width: size.width/8,
                    image: NetworkImage(userImage!=null?userImage:''),
                  ),
                ),
                Text(userName,style: TextStyle(color: Colors.lightGreenAccent),),
              ],
            ),
          ),
        ],
      ),
      //Boton para mutear o desmutear la musica de fondo.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            if (playingMenuAudio) {          
              //Al presionar el boton, si la musica esta sonando, se mutea y el icono cambia.
              musicIcon=IconData(0xe04f, fontFamily: 'MaterialIcons');
              menuAudio.pause();
              playingMenuAudio=false;
            }else{   
              //Al presionar el boton, si la musica no esta sonando, se desmutea y el icono cambia.       
              musicIcon=IconData(0xe050, fontFamily: 'MaterialIcons');  
              menuAudio.resume();
              playingMenuAudio=true;
            }
          });
        },        
        child: Icon(
          musicIcon,
          size: 20,
        ),
      ),
    );
  }
  void startMnuAudio() async {
    playingMenuAudio=true;//La musica ahora si se esta reproduciendo

    //Iniciamos el loop de la musica de fondo , indicando el volumen y la cancion en los assets/audio.
    menuAudio = await Flame.audio.loopLongAudio('Space_Game_Loop.mp3', volume: .25);
  }
}