import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}
    
class _MyApp extends State<RankView>{
  Size size;//Usaremos esto para definir tamaños de pantalla.
  String userId='';//Aqui se almacena el ID del usuario autenticado.
  @override
  void initState(){
    //Asignamos el ID del usuario autenticado a nuestra variable de userID
    setUserId().then((value){
      setState(() {
        userId=value;
      });
    });
  }
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Ranking'),
      ),
      body:new Container(
      decoration: BoxDecoration(  
        image: DecorationImage(
        image: AssetImage('assets/images/background.jpg'), 
        fit: BoxFit.cover)
      ),  
      child: Column(
        children: <Widget>[
          //Cabeceras de la lista, donde tenemos los titulos de los valores que se muestran.
          Row(
            children: <Widget>[
              //Titulo del rank del jugadores
              Container(
                width: size.width*0.2,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('Num.',style: TextStyle(color: Colors.white),)),
              ),
              //Titulo del nombre de los usuarios.
              Container(
                width: size.width*0.6,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('User',style: TextStyle(color: Colors.white),)),
              ),
              //Titulo del puntaje maximo de los jugadores.
              Container(
                width: size.width*0.2,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('HighScore'.toString(),style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),
          new StreamBuilder(
            //Stream para capturar los datos de Firebase de todos los usuarios.
            stream: Firestore.instance.collection('usuarios').orderBy('score',descending: true).snapshots(),
            //Ponemos los datos en una lista.
            builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
              //Verificamos si nuestro query a Firestore devolvio datos o no.
              if(snapshot.hasData){
                return Expanded(
                  child: ListView.builder(//Aqui enlistamos a todos los usuarios en el ranking.
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index)  {
                      //Si el usuario es el autenticado actualmente, lo marca con otro color.
                      if(userId==snapshot.data.documents[index].documentID){
                        return Row(
                          children: <Widget>[
                            //Posicion en el Ranking del juego.
                            Container(
                              color: Colors.lightBlue.withOpacity(0.2),
                              width: size.width*0.2,
                              height: 50,
                              child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.white),)),
                            ),
                            //Nombre del jugador en el juego.
                            Container(
                              width: size.width*0.6,
                              height: 50,
                              color: Colors.lightBlue.withOpacity(0.2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.data.documents[index].data['nombre'],style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            //Maximo puntaje del jugador.
                            Container(
                              width: size.width*0.2,
                              height: 50,
                              color: Colors.lightBlue.withOpacity(0.2),
                              child: Center(child: Text(snapshot.data.documents[index].data['score'].toString(),style: TextStyle(color: Colors.white),)),
                            ),
                          ],
                        );
                      }else{
                        //Si no es el usuario autenticado actualmente, lo muestra sin fondo.
                        return Row(
                          children: <Widget>[
                            //Posicion en el Ranking del juego.
                            Container(
                              width: size.width*0.2,
                              height: 50,
                              child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.white),)),
                            ),
                            //Nombre del jugador en el juego.
                            Container(
                              width: size.width*0.6,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.data.documents[index].data['nombre'],style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            //Maximo puntaje del jugador.
                            Container(
                              width: size.width*0.2,
                              height: 50,
                              child: Center(child: Text(snapshot.data.documents[index].data['score'].toString(),style: TextStyle(color: Colors.white),)),
                            ),
                          ],
                        );
                      }
                    },
                  )
                );
              }else{
                //Si no captura datos imprimimos un error.
                return Text('No se pudo obtener los datos');
              }
            },
          ),
        ],
      )
      ),
    );
  }
  //Verifica y devuelve un booleano si existe un usuario autenticado.
  Future<bool> signedIn() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(user!=null){
      return true;
    }else{
      return false;
    }
  }
  //Devuelve el ID del usuario autenticado.
  Future<String> setUserId() async {
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    if(await signedIn()){
      return user.uid;
    }
  }
}
