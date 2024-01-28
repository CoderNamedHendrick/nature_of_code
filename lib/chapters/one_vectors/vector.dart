import 'dart:math';
import 'dart:ui';

class Vector {
  final num x;
  final num y;

  const Vector(this.x, this.y);

  static Vector zero = const Vector(0, 0);

  static Vector random() => Vector(
        Random().nextDouble(),
        Random().nextDouble(),
      ).normalize();

  Offset offset() {
    return Offset(x.toDouble(), y.toDouble());
  }

  double mag() {
    return sqrt(x * x + y * y);
  }

  Vector normalize() {
    final mag = this.mag();
    if (mag < 0) throw Error.safeToString('Cannot divide by zero or less');
    return this / mag;
  }

  Vector limit(num max) {
    if (mag() > max) {
      final v = normalize();
      return v * max;
    }

    return this;
  }

  /// normalizes the vector and scales its magnitude to [newMag]
  Vector setMag(num newMag) {
    Vector newVector = normalize();
    return newVector * newMag;
  }

  Vector operator +(covariant Vector v) {
    return Vector(x + v.x, y + v.y);
  }

  Vector operator -(covariant Vector v) {
    return Vector(x - v.x, y - v.y);
  }

  Vector operator *(num s) {
    return Vector(x * s, y * s);
  }

  Vector operator /(num n) {
    return Vector(x / n, y / n);
  }

  Vector operator ~/(num n) {
    return Vector((x ~/ n).toDouble(), (y ~/ n).toDouble());
  }

  Vector operator -() {
    return Vector(-x, -y);
  }

  bool operator >(Vector v) {
    return mag() > v.mag();
  }

  bool operator <(Vector v) {
    return mag() < v.mag();
  }

  bool operator >=(Vector v) {
    return mag() >= v.mag();
  }

  bool operator <=(Vector v) {
    return mag() <= v.mag();
  }

  Vector copyWith({num? x, num? y}) {
    return Vector(x ?? this.x, y ?? this.y);
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Vector) return false;
    return x == other.x && y == other.y;
  }

  @override
  String toString() {
    return 'Vector(x: $x, y: $y)';
  }
}
