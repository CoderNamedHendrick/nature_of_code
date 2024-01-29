import 'dart:math';

import 'package:flutter/material.dart';

import '../one_vectors/vector.dart';
import 'mover.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Mover? mover;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    controller.addListener(() {
      setState(() {
        if (mover != null) {
          final weight = const Vector(0, 0.1) * mover!.mass;
          mover?.applyForce(weight);
          mover?.bounceEdges();
          mover?.applyFriction();

          mover?.angle = mover!.velocity.heading();
          mover?.update();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        mover ??= Mover(constraints.biggest)
          ..position =
              Vector(constraints.maxWidth * 0.05, constraints.maxHeight * 0.9)
          ..mass = 20;
        final width = mover?.bodySize ?? 0;
        final size = Size(width, width / 2);
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: mover?.position.y.toDouble(),
              left: mover?.position.x.toDouble(),
              height: size.height,
              width: size.width,
              child: Transform.rotate(
                angle: mover?.angle ?? 0,
                child: _object(size),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _object(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
    );
  }
}
