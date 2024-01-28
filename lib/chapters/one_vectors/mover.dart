import 'dart:math';

import 'package:flutter/material.dart';
import 'vector.dart';

class Mover {
  late Vector position;
  late Vector velocity;
  final Size canvasSize;
  late Vector acceleration;
  late double topSpeed;
  late double mass;

  Mover._(
    this.position,
    this.velocity,
    this.canvasSize,
    this.acceleration,
    this.topSpeed,
    this.mass,
  );

  Mover(this.canvasSize) {
    position = Vector(canvasSize.width / 2, canvasSize.height / 2);

    velocity = const Vector(0, 0);

    // constant acceleration initialisation
    acceleration = const Vector(0, 0);

    topSpeed = 10;
    mass = 10;
  }

  void updateRandomAcceleration() {
    acceleration = Vector.random();
    acceleration *= (Random().nextDouble() * 4) - 2;
    velocity += acceleration;
    velocity = velocity.limit(topSpeed);
    position += velocity;
  }

  void updatePosition(Vector mousePosition) {
    final direction = mousePosition - position;

    acceleration = direction.setMag(0.02);
  }

  void update() {
    velocity += acceleration;
    velocity = velocity.limit(topSpeed);
    position += velocity;

    acceleration *= 0; // reset acceleration
  }

  void checkEdges() {
    if (position.x > canvasSize.width) {
      position = position.copyWith(x: 0);
    } else if (position.x < 0) {
      position = position.copyWith(x: canvasSize.width);
    }

    if (position.y > canvasSize.height) {
      position = position.copyWith(y: 0);
    } else if (position.y < 0) {
      position = position.copyWith(y: canvasSize.height);
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
    double? topSpeed,
    double? mass,
  }) {
    return Mover._(
      position ?? this.position,
      velocity ?? this.velocity,
      canvasSize ?? this.canvasSize,
      acceleration ?? this.acceleration,
      topSpeed ?? this.topSpeed,
      mass ?? this.mass,
    );
  }

  @override
  int get hashCode =>
      position.hashCode ^
      velocity.hashCode ^
      canvasSize.hashCode ^
      acceleration.hashCode ^
      topSpeed.hashCode ^
      mass.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Mover) return false;

    return position == other.position &&
        velocity == other.velocity &&
        canvasSize == other.canvasSize &&
        acceleration == other.acceleration &&
        topSpeed == other.topSpeed &&
        mass == other.mass;
  }
}
