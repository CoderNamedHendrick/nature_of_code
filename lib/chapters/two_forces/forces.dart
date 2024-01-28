import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_nature_of_code/chapters/one_vectors/vector.dart';
import 'package:the_nature_of_code/chapters/two_forces/attractor.dart';
import 'package:the_nature_of_code/chapters/two_forces/fluid.dart';
import 'package:the_nature_of_code/chapters/two_forces/body.dart';

class Forces extends StatefulWidget {
  const Forces({super.key});

  @override
  State<Forces> createState() => _ForcesState();
}

class _ForcesState extends State<Forces> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool mouseIsPress = false;
  Offset? dragPosition;
  Fluid? fluid;
  List<Body> movers = [];
  Attractor? attractor;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    controller.addListener(() {
      setState(() {
        // applying a bunch of forces to the mover
        // gravity, wind on mouse press and friction plus elastic forces due to bounce

        for (int i = 0; i < movers.length; i++) {
          // is the mover in the fluid?
          // if (fluid?.contains(movers[i]) ?? false) {
          //   final dragForce = fluid?.calculateDrag(movers[i]);
          //
          //   if (dragForce != null) {
          //     movers[i].applyForce(dragForce);
          //   }
          // }

          final force = attractor?.attract(movers[i]);
          if (force != null) {
            movers[i].applyForce(force);
          }

          // gravity scaled by mass - weight
          // final weight = const Vector(0, 0.1) * movers[i].mass;
          // movers[i].applyForce(weight);
          movers[i].update();
          movers[i].checkEdges();

          // if (mouseIsPress) {
          //   const wind = Vector(0.01, 0);
          //   mover?.applyForce(wind);
          // }

          // mover?.applyFriction();
          // movers[i].bounceEdges();
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (movers.isEmpty) {
          movers = List.generate(
            1,
            (index) {
              final mass = Random().nextDouble() * 350 + 300;
              // final mass =
              //     Random().nextDouble() * 4.5 + 0.5; // random from 0.5 - 5
              return Body(
                Size(constraints.maxWidth, constraints.maxHeight),
                position: Vector(constraints.maxWidth * index * 70,
                    constraints.maxHeight * 0.2 * index + 70),
                mass: 400.0,
              );
            },
          );
        }

        fluid ??= Fluid(
          x: 0,
          y: constraints.maxHeight / 2,
          width: constraints.maxWidth,
          height: constraints.maxHeight / 2,
          dragCoefficient: 0.2,
        );

        attractor ??= Attractor(
          position: Vector(constraints.maxWidth / 2, constraints.maxHeight / 2),
          mass: 1500,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: attractor?.position.y.toDouble(),
              left: attractor?.position.x.toDouble(),
              width: attractor?.size,
              height: attractor?.size,
              child: Visibility(
                visible: true,
                child: _ball(Size.square(sqrt(attractor?.mass ?? 0) * 2)),
              ),
            ),
            // Positioned(
            //   left: fluid?.x,
            //   top: fluid?.y,
            //   width: fluid?.width,
            //   height: fluid?.height,
            //   child: _fluid(),
            // ),
            for (var mover in movers)
              Positioned(
                left: mover.position.x.toDouble(),
                top: mover.position.y.toDouble(),
                height: mover.bodySize,
                width: mover.bodySize,
                child: _ball(Size.square(mover.bodySize)),
              ),
            Positioned.fill(
              child: Listener(
                onPointerDown: (event) {
                  setState(() {
                    mouseIsPress = true;
                  });
                },
                onPointerUp: (event) {
                  setState(() {
                    mouseIsPress = false;
                  });
                },
                child: GestureDetector(
                  dragStartBehavior: DragStartBehavior.start,
                  onPanUpdate: (details) {
                    dragPosition = details.localPosition;
                  },
                  onPanEnd: (details) {
                    _onDragEnd();
                  },
                  child: SizedBox.fromSize(
                    size: MediaQuery.sizeOf(context),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDragEnd() {
    if (dragPosition != null) {
      final dragVector = Vector(dragPosition!.dx, dragPosition!.dy);
      // mover?.updatePosition(dragVector, 10);
    }
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

  Widget _fluid() {
    return Container(
      decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
    );
  }
}
