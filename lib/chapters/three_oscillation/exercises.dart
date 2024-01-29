import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_nature_of_code/chapters/one_vectors/vector.dart';
import 'package:the_nature_of_code/chapters/three_oscillation/mover.dart';

class CannonExercise extends StatefulWidget {
  const CannonExercise({super.key});

  @override
  State<CannonExercise> createState() => _CannonExerciseState();
}

class _CannonExerciseState extends State<CannonExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Mover? mover;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();

    controller.addListener(() {
      setState(() {
        if (mover != null) {
          final weight = const Vector(0, 0.1) * mover!.mass;
          mover?.applyForce(weight);
          mover?.bounceEdges();
          mover?.applyFriction();
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
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: mover?.position.y.toDouble(),
              left: mover?.position.x.toDouble(),
              height: mover?.bodySize,
              width: mover?.bodySize,
              child: Transform.rotate(
                angle: mover?.angle ?? 0,
                child: _cannonBall(mover?.bodySize ?? 1),
              ),
            ),
            Positioned.fill(
              child: Listener(
                onPointerDown: (event) {
                  final force = Vector(
                      constraints.maxWidth * 0.4, constraints.maxHeight * 0.6);

                  mover?.applyForce(force);
                },
                child: SizedBox.fromSize(
                  size: MediaQuery.sizeOf(context),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _cannonBall(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Center(
        child: Icon(
          Icons.star,
          color: Colors.white,
          size: size / 2,
        ),
      ),
    );
  }
}

class VehicleSimulation extends StatefulWidget {
  const VehicleSimulation({super.key});

  @override
  State<VehicleSimulation> createState() => _VehicleSimulationState();
}

class _VehicleSimulationState extends State<VehicleSimulation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Mover? mover;
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();

    controller.addListener(() {
      setState(() {
        if (mover != null) {
          mover?.bounceEdges();
          mover?.applyFriction();
          mover?.angle = mover?.velocity.heading() ?? 0;
          mover?.update();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focus,
      autofocus: true,
      onKeyEvent: (event) {
        const axisSpeed = 1;
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          mover?.applyForce(const Vector(0, -axisSpeed));
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          mover?.applyForce(const Vector(0, axisSpeed));
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          mover?.applyForce(const Vector(-axisSpeed, 0));
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          mover?.applyForce(const Vector(axisSpeed, 0));
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          mover ??= Mover(constraints.biggest)
            ..position =
                Vector(constraints.maxWidth * 0.05, constraints.maxHeight * 0.9)
            ..mass = 20;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: mover?.position.y.toDouble(),
                left: mover?.position.x.toDouble(),
                height: mover?.bodySize,
                width: mover?.bodySize,
                child: Transform.rotate(
                  angle: mover?.angle ?? 0,
                  child: _cannonBall(mover?.bodySize ?? 1),
                ),
              ),
              Positioned.fill(
                child: Listener(
                  // onPointerDown: _driveHere,
                  // onPointerMove: _driveHere,
                  child: SizedBox.fromSize(
                    size: MediaQuery.sizeOf(context),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    _directionButton(
                      const Icon(Icons.arrow_upward),
                      () {
                        mover?.applyForce(const Vector(0, -3));
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _directionButton(
                          const Icon(Icons.arrow_back),
                          () {
                            mover?.applyForce(const Vector(-3, 0));
                          },
                        ),
                        const SizedBox(width: 10),
                        _directionButton(
                          const Icon(Icons.arrow_downward),
                          () {
                            mover?.applyForce(const Vector(0, 3));
                          },
                        ),
                        const SizedBox(width: 10),
                        _directionButton(
                          const Icon(Icons.arrow_forward),
                          () {
                            mover?.applyForce(const Vector(3, 0));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _directionButton(Icon icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      onTapDown: (_) {
        onTap();
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: IconButton(
            icon: icon,
            onPressed: () {},
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _cannonBall(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
      child: Center(
        child: Icon(
          Icons.star,
          color: Colors.white,
          size: size / 2,
        ),
      ),
    );
  }
}
