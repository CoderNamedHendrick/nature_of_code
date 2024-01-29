import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_nature_of_code/chapters/three_oscillation/mover.dart';

class BatonOscillation extends StatefulWidget {
  const BatonOscillation({super.key});

  @override
  State<BatonOscillation> createState() => _BatonOscillationState();
}

class _BatonOscillationState extends State<BatonOscillation>
    with SingleTickerProviderStateMixin {
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
        mover?.update();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        mover ??= Mover(constraints.biggest);
        return Center(
          child: Transform.rotate(
            angle: mover?.angle ?? 0,
            child: _box(80),
          ),
        );
      },
    );
  }

  Widget _box(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.red,
    );
  }
}

class PolarCoordinatesExample extends StatefulWidget {
  const PolarCoordinatesExample({super.key});

  @override
  State<PolarCoordinatesExample> createState() =>
      _PolarCoordinatesExampleState();
}

class _PolarCoordinatesExampleState extends State<PolarCoordinatesExample>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double theta = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    controller.addListener(() {
      setState(() {
        theta += 0.02;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PendulumPainter(
        radius: 80,
        theta: theta,
      ),
      size: MediaQuery.sizeOf(context),
    );
  }
}

class BatonPainter extends CustomPainter {
  final double angle;

  const BatonPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    const center =
        Offset(0, 0); // center is zero offset since origin is now at the center
    const halfOfLengthOffset = Offset(80, 0);
    canvas.drawLine(
      center - halfOfLengthOffset,
      center + halfOfLengthOffset, // length of 120
      Paint()
        ..color = Colors.green
        ..strokeWidth = 3,
    );

    canvas.drawCircle(
      center - halfOfLengthOffset,
      16,
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      center + halfOfLengthOffset,
      16,
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! BatonPainter) return false;

    if (oldDelegate.angle != angle) return true;
    return false;
  }
}

class PendulumPainter extends CustomPainter {
  final double radius;
  final double theta;

  const PendulumPainter({required this.radius, required this.theta});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final x = radius * cos(theta); // CAH => cos(theta) = adjacent/hypotenuse
    final y = radius * sin(theta); // SOH => sing(theta) = opposite/hypotenuse

    canvas.drawLine(
      const Offset(0, 0),
      Offset(x, y),
      Paint()
        ..color = Colors.green
        ..strokeWidth = 3,
    );

    canvas.drawCircle(
      Offset(x, y),
      16,
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! PendulumPainter) return false;

    if (oldDelegate.radius != radius) return true;
    if (oldDelegate.theta != theta) return true;
    return false;
  }
}
