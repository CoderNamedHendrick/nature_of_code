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
