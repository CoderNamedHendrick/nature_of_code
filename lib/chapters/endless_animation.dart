import 'package:flutter/material.dart';

class EndlessAnimation extends StatefulWidget {
  const EndlessAnimation({
    Key? key,
    required this.child,
    this.onAnimate,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onAnimate;

  @override
  State<EndlessAnimation> createState() => _EndlessAnimationState();
}

class _EndlessAnimationState extends State<EndlessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    )..repeat();

    _controller.addListener(() {
      widget.onAnimate?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
