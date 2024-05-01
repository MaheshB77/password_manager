import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final double height;
  final double width;
  const Spinner({
    super.key,
    this.height = 16,
    this.width = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const CircularProgressIndicator(),
    );
  }
}
