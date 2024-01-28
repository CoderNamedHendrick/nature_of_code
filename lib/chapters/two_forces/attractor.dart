import 'dart:math';

import 'package:the_nature_of_code/chapters/one_vectors/vector.dart';
import 'package:the_nature_of_code/chapters/two_forces/body.dart';

class Attractor {
  final Vector position;
  final double mass;

  static const double G = 1;

  const Attractor({required this.position, required this.mass});

  double get size => sqrt(mass) * 2;

  // here we calculate the gravitational force of attraction
  // between the mover and the attractor
  // F = G * (m1 * m2) / r^2 the scalar form.
  // for F(vector) we multiply the magnitude by the normalised distance between
  // the two objects
  // F-> = (G * (m1 * m2) / r^2) * r->
  Vector attract(Body mover) {
    Vector force = position - mover.position;
    double distance = force
        .mag(); // the shortest distance between the difference of the two position vectors
    distance =
        distance.clamp(5, 25); // clamp the distance to avoid division by 0
    final forceMagnitude = (G * mass * mover.mass) / (distance * distance);

    return force.setMag(forceMagnitude);
  }
}
