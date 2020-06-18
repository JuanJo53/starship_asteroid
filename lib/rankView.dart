import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}
    
class _MyApp extends State<RankView>{
  Size size;
  @override
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
          Row(
            children: <Widget>[
              Container(
                width: size.width*0.2,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('Nro.',style: TextStyle(color: Colors.white),)),
              ),
              Container(
                width: size.width*0.6,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('Usuario',style: TextStyle(color: Colors.white),)),
              ),
              Container(
                width: size.width*0.2,
                height: 50,
                color: Colors.white.withOpacity(0.2),
                child: Center(child: Text('Puntuacion'.toString(),style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),
          new StreamBuilder(
            stream: Firestore.instance.collection('usuarios').orderBy('maxPuntuacion',descending: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
              if(snapshot.hasData){
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: <Widget>[
                          Container(
                            width: size.width*0.2,
                            height: 50,
                            child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.white),)),
                          ),
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
                          Container(
                            width: size.width*0.2,
                            height: 50,
                            child: Center(child: Text(snapshot.data.documents[index].data['maxPuntuacion'].toString(),style: TextStyle(color: Colors.white),)),
                          ),
                        ],
                      );
                    },
                  )
                );
              }else{
                return Text('No se pudo obtener los datos');
              }
            },
          ),
        ],
      )
      ),
    );
  }
}
