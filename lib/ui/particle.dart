import 'package:flutter/material.dart';
import 'package:sokoban/utilities/utilities.dart';

class Particle {

  static final Paint p = Paint()..color = Colors.white;
  double radius = Utilities.randomDouble(1.0, 10.0, 2);
  double speed = Utilities.randomDouble(50.0, 500.0, 2);
  Offset pos;

  Particle(this.pos);

  void paint(Canvas canvas, Size size, double dt){

    canvas.drawCircle(pos, radius, p);
    pos = pos.translate(0.0, -speed * dt);

    if(pos.dy <= -10.0){
      pos = pos.translate(0.0, size.height + 50.0);
    }

  }

}

class ParticleManager {

  List<Particle> particles = [];
  final int particleCount;

  ParticleManager(this.particleCount){

    for(int i = 0; i < particleCount; ++i){
      particles.add(Particle(Offset(Utilities.randomDouble(0.0, 2000, 2), Utilities.randomDouble(0.0, 1000, 2))));
    }

  }

  void paint(Canvas canvas, Size size, double dt){

    for(var particle in particles){
      particle.paint(canvas, size, dt);
    }

  }

}
