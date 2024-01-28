import 'dart:math';

import 'package:flutter/material.dart';
import '../one_vectors/vector.dart';

class Body {
  late Vector position;
  late Vector velocity;
  final Size canvasSize;
  late Vector acceleration;
  late double mass;
  late double coefFriction; // coefficient of friction

  final normal = 1.0; // normal force
  static const double G = 1;

  Body._(
    this.position,
    this.velocity,
    this.canvasSize,
    this.acceleration,
    this.mass,
  );

  Body(
    this.canvasSize, {
    required this.position,
    required this.mass,
    this.coefFriction = 0.01,
  }) {
    velocity = const Vector(0, 0);

    // constant acceleration initialisation
    acceleration = const Vector(0, 0);
  }

  void updatePosition(Vector mousePosition, num acc) {
    final direction = mousePosition - position;

    // a = dv/dt =
    final f = direction.setMag(acc.toDouble()) * mass;
    applyForce(f);
  }

  void update() {
    velocity += acceleration;
    position += velocity;

    acceleration *= 0; // reset acceleration
  }

  double get bodySize => sqrt(mass) * 2;

  void checkEdges() {
    if (position.x > (canvasSize.width - bodySize)) {
      position = position.copyWith(x: (canvasSize.width - bodySize));
      velocity = velocity.copyWith(x: -velocity.x);
    } else if (position.x < 0) {
      velocity = velocity.copyWith(x: -velocity.x);
      position = position.copyWith(x: 0);
    }

    if (position.y > (canvasSize.height - bodySize)) {
      velocity = velocity.copyWith(y: -velocity.y);
      position = position.copyWith(y: (canvasSize.height - bodySize));
    } else if (position.y < 0) {
      velocity = velocity.copyWith(y: -velocity.y);
      position = position.copyWith(y: 0);
    }
  }

  // inelastic collision
  void bounceEdges() {
    const bounce = -0.9; // percentage speed loss on bounce
    if (position.y > canvasSize.height - bodySize) {
      position = position.copyWith(y: canvasSize.height - bodySize);
      velocity = velocity.copyWith(y: velocity.y * bounce);
    } else if (position.y < 0) {
      position = position.copyWith(y: 0);
      velocity = velocity.copyWith(y: velocity.y * bounce);
    }

    if (position.x > canvasSize.width - bodySize) {
      position = position.copyWith(x: canvasSize.width - bodySize);
      velocity = velocity.copyWith(x: velocity.x * bounce);
    } else if (position.x < 0) {
      position = position.copyWith(x: 0);
      velocity = velocity.copyWith(x: velocity.x * bounce);
    }
  }

  // the mover is in contact with the bottom edge
  bool contactEdge() {
    return (position.y > (canvasSize.height - bodySize) - 1);
  }

  void applyFriction() {
    if (contactEdge()) {
      final frictionMag = coefFriction * normal; // u * N
      Vector friction = velocity.copyWith() * -1; // reverse the direction
      friction = friction.setMag(frictionMag);

      applyForce(friction);
    }
  }

  // here we calculate the gravitational force of attraction
  // between the mover and the attractor
  // F = G * (m1 * m2) / r^2 the scalar form.
  // for F(vector) we multiply the magnitude by the normalised distance between
  // the two objects
  // F-> = (G * (m1 * m2) / r^2) * r->
  Vector attract(Body body) {
    Vector force = position - body.position;
    double d = force.mag().clamp(5,
        25); // the shortest distance between the difference of the two position vectors, clamp the distance to avoid division by 0
    final strength = (G * (mass * body.mass)) / (d * d);

    force = force.setMag(strength);
    body.applyForce(force);

    return force;
  }

  // representing distance from the closest edge in percentage 0 - 1
  Vector distanceFromEdge() {
    Vector v = Vector.zero;
    late final double x;
    late final double y;

    // x is closer to the right edge
    if (position.x > (canvasSize.width - bodySize) / 2) {
      x = (canvasSize.width - bodySize) - position.x;
    } else {
      x = position.x.toDouble(); // x is closer to the left edge
    }

    // y is closer to the bottom edge
    if (position.y > (canvasSize.height - bodySize) / 2) {
      y = (canvasSize.height - bodySize) - position.y;
    } else {
      y = position.y.toDouble(); // y is closer to the top edge
    }

    v = Vector(x, y).normalize();
    return v;
  }

  void applyForce(Vector force) {
    final f = force.copyWith() / mass;
    acceleration += f;
  }

  // ignore: unused_element
  Body _copyWith({
    Vector? position,
    Vector? velocity,
    Size? canvasSize,
    Vector? acceleration,
    double? mass,
  }) {
    return Body._(
      position ?? this.position,
      velocity ?? this.velocity,
      canvasSize ?? this.canvasSize,
      acceleration ?? this.acceleration,
      mass ?? this.mass,
    );
  }

  @override
  int get hashCode =>
      position.hashCode ^
      velocity.hashCode ^
      canvasSize.hashCode ^
      acceleration.hashCode ^
      mass.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Body) return false;

    return position == other.position &&
        velocity == other.velocity &&
        canvasSize == other.canvasSize &&
        acceleration == other.acceleration &&
        mass == other.mass;
  }
}
