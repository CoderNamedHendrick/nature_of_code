import 'package:flutter/material.dart';
import 'walker.dart';

class RandomnessView extends StatefulWidget {
  const RandomnessView({super.key});

  @override
  State<RandomnessView> createState() => _RandomnessViewState();
}

class _RandomnessViewState extends State<RandomnessView> {
  @override
  Widget build(BuildContext context) {
    return const Walker();
  }
}
