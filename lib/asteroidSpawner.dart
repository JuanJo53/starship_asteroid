import 'package:starshipasteroid/asteroid.dart';
import 'package:starshipasteroid/gameController.dart';

class AsteroidSpawner{
  final GameController gameController;
  final int intervaloMaximo=300;
  final int cambioIntervalo=700;
  final int maxAsteroids=2;
  final int intervaloMinimo=3;
  int nextSpawn;
  int intervaloActual;

  AsteroidSpawner(this.gameController){
    initialize();
  }
    
  void initialize() {
    despawnAsts();
    intervaloActual=intervaloMaximo;
    nextSpawn=DateTime.now().millisecondsSinceEpoch+intervaloActual;
  }
    
  void despawnAsts() {
    gameController.asts.forEach((Asteroid asteroid)=>asteroid.destruido=true);
  }
  void update(double t){
    int now= DateTime.now().millisecondsSinceEpoch;
    if(gameController.asts.length<maxAsteroids&&now>=nextSpawn){
      gameController.spawnAsteroid();
      if(intervaloActual>intervaloMinimo){
        intervaloActual-=cambioIntervalo;
        intervaloActual-=(intervaloActual*0.1).toInt();
      }
      nextSpawn=now+intervaloActual;
    }
  }
  
}