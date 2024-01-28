import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Walker extends StatefulWidget {
  const Walker({super.key});

  @override
  State<Walker> createState() => _WalkerState();
}

class _WalkerState extends State<Walker> {
  late Offset walkerPosition;

  @override
  void didChangeDependencies() {
    final size = MediaQuery.sizeOf(context);
    walkerPosition = Offset(size.width / 2, size.height / 2);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: step,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: WalkerPainter(walkerPosition),
          size: MediaQuery.sizeOf(context),
        ),
      ),
    );
  }

  void step() {
    final latency = Random().nextDouble();
    final xStep = Random().nextInt(3) - 1; // ranges from -1 to 1
    final yStep = Random().nextInt(3) - 1;

    const stepFactor = 10.0;

    // increase probability of moving right or down by increasing step by 1
    // which takes the range to 0-2 instead of -1 - 1 which allows left and upwards movements
    if (latency <= 0.7) {
      _updateWalkerPosition(
        Offset(stepFactor * (xStep + 1), stepFactor * (yStep + 1)),
      );
    }
    _updateWalkerPosition(Offset(stepFactor * xStep, stepFactor * yStep));
  }

  void _updateWalkerPosition(Offset positionDistance) {
    setState(() {
      walkerPosition = walkerPosition + positionDistance;
    });
  }
}

class WalkerPainter extends CustomPainter {
  final Offset position;

  const WalkerPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20;

    canvas.drawPoints(PointMode.points, [position], paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! WalkerPainter) return false;

    return true;
  }
}
