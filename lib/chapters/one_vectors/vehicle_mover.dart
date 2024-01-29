import 'mover.dart';
import 'vector.dart';

class VehicleMover extends Mover {
  bool isBreaking = false;
  late double topSpeed;
  static const Vector _deceleration = Vector(0.01, 0);

  VehicleMover(super.canvasSize, this.topSpeed) {
    acceleration = const Vector(0, 0);
  }

  void brake() {
    isBreaking = true;
    // vehicle is still in motion check
    // when the vehicle is in the motion, the velocity isn't zero
    if (velocity.mag() > 1) {
      // negative acceleration, velocity slows down
      acceleration -= _deceleration;
    } else {
      // velocity is zero, break now
      acceleration = Vector.zero;
    }
  }

  @override
  void update() {
    velocity += acceleration;
    velocity = velocity.limit(topSpeed);
    position += velocity;

    acceleration *= 0; // reset acceleration

    if (isBreaking && velocity.mag() < 1) {
      velocity = Vector.zero;
      acceleration = Vector.zero;
    }
  }

  void accelerate() {
    isBreaking = false;
    // accelerates in the x-axis
    acceleration += _deceleration;
  }
}
