import 'mover.dart';
import 'vector.dart';

class VehicleMover extends Mover {
  bool isBreaking = false;
  static const Vector _deceleration = Vector(0.01, 0);

  VehicleMover(super.canvasSize, double topSpeed) {
    acceleration = const Vector(0, 0);
    this.topSpeed = topSpeed;
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
    super.update();

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
