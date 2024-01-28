import 'dart:math';

import 'package:flutter/material.dart';

import '../one_vectors/vector.dart';
import 'body.dart';

class Bodies extends StatefulWidget {
  const Bodies({super.key});

  @override
  State<Bodies> createState() => _BodiesState();
}

class _BodiesState extends State<Bodies> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Body? bodyA;
  Body? bodyB;
  List<Body> bodies = <Body>[];
  Body? centerOfAttraction;

  static const _invalidPosition = Vector(-1, -1);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    controller.addListener(() {
      setState(() {
        for (int i = 0; i < bodies.length; i++) {
          for (int j = 0; j < bodies.length; j++) {
            if (i != j) {
              // a body can't attract itself
              // final force = bodies[j].attract(bodies[i]);
              // bodies[j].applyForce(force);

              // attraction to mouse point and repulsion from other bodies

              if (centerOfAttraction != null &&
                  (centerOfAttraction?.position ?? _invalidPosition) >
                      _invalidPosition) {
                // attraction to mouse point
                final force = bodies[j].attract(centerOfAttraction!);

                // repulsion from other bodies, repulsion would be negative attraction.
                bodies[i].applyForce(-force);
              }
            }
          }

          bodies[i].checkEdges();
          bodies[i].update();
        }
      });

      // if (bodyA != null && bodyB != null) {
      //   bodyA?.attract(bodyB!);
      //   bodyB?.attract(bodyA!);
      //
      //   bodyA?.update();
      //   bodyB?.update();
      //
      //   setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bodyA ??= Body(
        constraints.biggest,
        position: Vector(
            constraints.biggest.width * 0.6, constraints.biggest.height * 0.4),
        mass: 150,
      )..velocity = const Vector(1, 0);

      bodyB ??= Body(constraints.biggest,
          position: Vector(constraints.biggest.width * 0.2,
              constraints.biggest.height * 0.2),
          mass: 100)
        ..velocity = const Vector(-1, 0);

      if (bodies.isEmpty) {
        bodies = List.generate(
          3,
          (index) => Body(
            constraints.biggest,
            position: Vector(
              constraints.maxWidth * Random().nextDouble(),
              constraints.maxHeight * Random().nextDouble(),
            ),
            mass: 200,
          ),
        );
      }

      centerOfAttraction ??=
          Body(constraints.biggest, position: _invalidPosition, mass: 1000);

      return Stack(
        fit: StackFit.expand,
        children: [
          for (final body in bodies)
            Positioned(
              left: body.position.x.toDouble(),
              top: body.position.y.toDouble(),
              width: body.bodySize,
              height: body.bodySize,
              child: _ball(Size.square(body.bodySize)),
            ),
          Positioned(
            left: centerOfAttraction?.position.x.toDouble(),
            top: centerOfAttraction?.position.y.toDouble(),
            width: centerOfAttraction?.bodySize,
            height: centerOfAttraction?.bodySize,
            child: _mousePosition(),
          ),
          Positioned.fill(
            child: Listener(
              onPointerDown: _attractToPoint,
              child: SizedBox.fromSize(
                size: constraints.biggest,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _attractToPoint(PointerEvent event) {
    final point = Vector(event.localPosition.dx, event.localPosition.dy);
    centerOfAttraction?.position = point;
  }

  Widget _ball(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink,
        border: Border.all(color: Colors.green, width: 2),
      ),
    );
  }

  Widget _mousePosition() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        border: Border.all(color: Colors.yellowAccent, width: 2),
      ),
    );
  }
}
