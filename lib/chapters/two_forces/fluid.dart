import '../one_vectors/vector.dart';
import 'body.dart';

class Fluid {
  final double x;
  final double y;
  final double width;
  final double height;
  final double dragCoefficient;

  const Fluid({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.dragCoefficient,
  });

  bool contains(Body mover) {
    return (mover.position.x > x &&
        mover.position.x < x + width &&
        mover.position.y > y &&
        mover.position.y < y + height);
  }

  // drag/fluid resistance is friction in fluid(air/water)
  // Fd = -1/2 * p * v^2 * A * Cd * v
  // where Fd is a vector for drag force
  // p - density, v = speed(mag of velocity), A(frontal surface area of object)
  // Cd - drag coefficient, v - velocity vector(in our case a unit vector)
  Vector calculateDrag(Body mover) {
    Vector dragForce = Vector.zero;
    final speed = mover.velocity.mag();
    final dragMagnitude = dragCoefficient * speed * speed;
    dragForce = mover.velocity.copyWith();
    dragForce *= -1;
    dragForce = dragForce.setMag(dragMagnitude);

    return dragForce.limit(mover.mass); // limit drag force to mass
  }

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode ^
      width.hashCode ^
      height.hashCode ^
      dragCoefficient.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Fluid) return false;

    return x == other.x &&
        y == other.y &&
        width == other.width &&
        height == other.height &&
        dragCoefficient == other.dragCoefficient;
  }
}
