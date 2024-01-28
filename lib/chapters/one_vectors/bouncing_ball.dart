import 'package:flutter/material.dart';
import 'package:the_nature_of_code/chapters/one_vectors/mover.dart';
import 'vehicle_mover.dart';
import 'vector.dart';

class BouncingBall extends StatefulWidget {
  const BouncingBall({super.key});

  @override
  State<BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with SingleTickerProviderStateMixin {
  Mover? mover;

  final vector = ValueNotifier(const Vector(0, 0));

  static const ballSize = 48.0;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    controller.addListener(() {
      setState(() {
        mover?.update();
        mover?.checkEdges();
      });
    });

    controller.repeat();
  }

  @override
  void didChangeDependencies() {
    mover ??= Mover(MediaQuery.sizeOf(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: mover?.position.x.toDouble(),
          top: mover?.position.y.toDouble(),
          height: ballSize,
          width: ballSize,
          child: _ball(),
        ),
        Positioned.fill(
          child: Listener(
            onPointerDown: _goToTouch,
            // onPointerHover: _goToTouch,
            child: SizedBox.fromSize(
              size: MediaQuery.sizeOf(context),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: Listener(
        //     onPointerMove: _detectTouch,
        //     onPointerUp: _detectTouch,
        //     onPointerHover: _detectTouch,
        //     child: ValueListenableBuilder(
        //       valueListenable: vector,
        //       builder: (context, vectorValue, child) {
        //         return CustomPaint(
        //           painter: VectorPainter(vectorValue),
        //           size: MediaQuery.sizeOf(context),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: 20,
        //   left: 20,
        //   right: 20,
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: ElevatedButton(
        //           onPressed: () {},
        //           child: const Text('Brake'),
        //         ),
        //       ),
        //       const SizedBox(width: 20),
        //       Expanded(
        //         child: ElevatedButton(
        //           onPressed: () {},
        //           child: const Text('Accelerate'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  void _detectTouch(PointerEvent event) {
    vector.value = Vector(event.localPosition.dx, event.localPosition.dy);
  }

  void _goToTouch(PointerEvent event) {
    mover?.updatePosition(
      Vector(event.localPosition.dx, event.localPosition.dy),
    );
  }

  Widget _ball() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink,
        border: Border.all(color: Colors.green, width: 2),
      ),
    );
  }
}

class VectorPainter extends CustomPainter {
  Vector vector;

  VectorPainter(this.vector);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Vector(size.width / 2, size.height / 2);

    // vector subtraction
    vector -= center;

    // magnitude
    final mag = vector.mag();
    canvas.drawRect(
      Rect.fromLTRB(0, 0, mag, 10),
      Paint()..color = Colors.green,
    );

    canvas.translate(size.width / 2, size.height / 2);

    canvas.drawLine(
        Offset.zero,
        vector.offset(),
        Paint()
          ..strokeWidth = 2
          ..color = Colors.orange
          ..strokeCap = StrokeCap.round);

    // vector multiplication
    // vector *= 0.5;

    // vector normalization
    vector = vector.normalize();
    vector *= 50; // length of vector will always remain 10
    canvas.drawLine(
        Offset.zero,
        vector.offset(),
        Paint()
          ..strokeWidth = 4
          ..color = Colors.white
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! VectorPainter) return false;

    if (oldDelegate.vector != vector) return true;
    return false;
  }
}
