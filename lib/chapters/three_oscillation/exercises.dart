import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_nature_of_code/chapters/endless_animation.dart';
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

class SpaceshipAsteroid extends StatefulWidget {
  const SpaceshipAsteroid({super.key});

  @override
  State<SpaceshipAsteroid> createState() => _SpaceshipAsteroidState();
}

class _SpaceshipAsteroidState extends State<SpaceshipAsteroid> {
  final focus = FocusNode();

  Mover? mover;

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focus,
      autofocus: true,
      onKeyEvent: (event) {
        // rotate counter clockwise
        if (mover != null) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            mover?.angle = (mover?.angle ?? 0) - 0.1;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            mover?.angle = (mover?.angle ?? 0) + 0.1;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            // decelerate ship
            Vector deceleration = mover!.velocity.copyWith() * -1;
            deceleration = deceleration;

            mover?.applyForce(deceleration);
          } else if (event.logicalKey.keyLabel == 'Z') {
            // apply force in direction of angle
            final thrust =
                Vector.fromAngle(-pi / 2 + (mover?.angle ?? 0)).setMag(0.5);
            mover?.applyForce(thrust);
          }
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        mover ??= Mover(constraints.biggest)
          ..position =
              Vector(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5)
          ..mass = 20;

        return EndlessAnimation(
          onAnimate: () {
            setState(() {
              if (mover != null) {
                mover?.bounceEdges();
                mover?.applyFriction();
                mover?.thrustUpdate();
              }
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Positioned.fill(
              //   child: CustomPaint(
              //     painter: AsteroidPainter(),
              //   ),
              // ),
              Positioned(
                top: mover?.position.y.toDouble(),
                left: mover?.position.x.toDouble(),
                height: mover?.bodySize,
                width: mover?.bodySize,
                child: CustomPaint(
                  painter: SpaceshipPainter(
                    mover?.angle ?? 0,
                    mover?.bodySize ?? 0,
                  ),
                  size: Size(mover?.bodySize ?? 0, mover?.bodySize ?? 0),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SpaceshipPainter extends CustomPainter {
  const SpaceshipPainter(this.angle, this.spaceshipSize);

  final double angle;
  final double spaceshipSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    final path = Path();

    const position = Vector(0, 0);
    path.moveTo(
      position.x.toDouble(),
      position.y.toDouble() - spaceshipSize / 2,
    );

    final topVertex = Vector(0, -spaceshipSize / 2);
    final leftVertex = Vector(-spaceshipSize / 2, spaceshipSize / 2);
    final rightVertex = Vector(spaceshipSize / 2, spaceshipSize / 2);

    // plan body
    path.addPolygon([
      topVertex.offset(),
      leftVertex.offset(),
      rightVertex.offset(),
    ], true);

    // first ship exhaust
    path.addRect(
      Rect.fromCenter(
        center: leftVertex.offset() + const Offset(10, 1),
        width: 5,
        height: 5,
      ),
    );

    // second ship exhaust
    path.addRect(
      Rect.fromCenter(
        center: rightVertex.offset() + const Offset(-10, 1),
        width: 5,
        height: 5,
      ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.green
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! SpaceshipPainter) return false;

    if (oldDelegate.angle != angle) return true;
    if (oldDelegate.spaceshipSize != spaceshipSize) return true;
    return false;
  }
}

class EndlessSpiral extends StatefulWidget {
  const EndlessSpiral({super.key});

  @override
  State<EndlessSpiral> createState() => _EndlessSpiralState();
}

class _EndlessSpiralState extends State<EndlessSpiral> {
  double theta = 0;
  double radius = 0;

  @override
  Widget build(BuildContext context) {
    return EndlessAnimation(
      onAnimate: () {
        setState(() {
          theta += radiusIncrement;
          radius += thetaIncrement;
        });
      },
      child: CustomPaint(
        painter: SpiralPainter(radius: radius, theta: theta),
        size: MediaQuery.sizeOf(context),
      ),
    );
  }
}

const radiusIncrement = 0.2;
const thetaIncrement = 0.05;

class SpiralPainter extends CustomPainter {
  final double theta;
  final double radius;

  const SpiralPainter({required this.radius, required this.theta});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    Path path = Path();

    // compute previous points
    for (double i = 0; i <= radius; i += radiusIncrement) {
      final index = (i / radiusIncrement).floor();
      final x = i * cos(index * thetaIncrement);
      final y = i * sin(index * thetaIncrement);

      path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.orange
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! SpiralPainter) return false;

    if (oldDelegate.radius != radius) return true;
    if (oldDelegate.theta != theta) return true;
    return false;
  }
}
