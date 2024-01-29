import 'dart:math';

import 'package:flutter/material.dart';
import '../one_vectors/vector.dart';

class Mover {
  late Vector position;
  late Vector velocity;
  final Size canvasSize;
  late Vector acceleration;
  late double mass;
  late double angle;
  late double angleVelocity;
  late double angleAcceleration;

  final normal = 1.0; // normal force
  final coefFriction = 0.01; // coefficient of friction

  Mover._(
    this.position,
    this.velocity,
    this.canvasSize,
    this.acceleration,
    this.mass,
    this.angle,
    this.angleVelocity,
    this.angleAcceleration,
  );

  Mover(this.canvasSize) {
    position = Vector(canvasSize.width / 2, canvasSize.height / 2);

    velocity = const Vector(0, 0);

    // constant acceleration initialisation
    acceleration = const Vector(0, 0);

    mass = 1.0;

    angle = 0;
    angleVelocity = 0;
    angleAcceleration = 0;
  }

  void updateRandomAcceleration() {
    acceleration = Vector.random();
    acceleration *= (Random().nextDouble() * 4) - 2;
    velocity += acceleration;
    position += velocity;
  }

  void updatePosition(Vector mousePosition, num acc) {
    final direction = mousePosition - position;

    final f = direction.setMag(acc.toDouble()) * mass;
    applyForce(f);
  }

  void update() {
    velocity += acceleration;
    position += velocity;

    angleAcceleration = acceleration.x / 10;
    angleVelocity += angleAcceleration;
    angleVelocity = angleVelocity.clamp(-0.1, 0.1); // limit angle velocity
    angle += angleVelocity;

    acceleration *= 0; // reset acceleration
  }

  double get bodySize => mass * 2;

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

  void applyForce(Vector force) {
    final f = force.copyWith() / mass;
    acceleration += f;
  }

  // ignore: unused_element
  Mover _copyWith({
    Vector? position,
    Vector? velocity,
    Size? canvasSize,
    Vector? acceleration,
    double? mass,
    double? angle,
    double? angleVelocity,
    double? angleAcceleration,
  }) {
    return Mover._(
      position ?? this.position,
      velocity ?? this.velocity,
      canvasSize ?? this.canvasSize,
      acceleration ?? this.acceleration,
      mass ?? this.mass,
      angle ?? this.angle,
      angleVelocity ?? this.angleVelocity,
      angleAcceleration ?? this.angleAcceleration,
    );
  }

  @override
  int get hashCode =>
      position.hashCode ^
      velocity.hashCode ^
      canvasSize.hashCode ^
      acceleration.hashCode ^
      mass.hashCode ^
      angle.hashCode ^
      angleVelocity.hashCode ^
      angleAcceleration.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Mover) return false;

    return position == other.position &&
        velocity == other.velocity &&
        canvasSize == other.canvasSize &&
        acceleration == other.acceleration &&
        mass == other.mass &&
        angle == other.angle &&
        angleVelocity == other.angleVelocity &&
        angleAcceleration == other.angleAcceleration;
  }
}
