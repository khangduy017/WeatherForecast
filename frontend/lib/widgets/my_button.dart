import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      required this.onPressed,
      required this.color,
      required this.size,
      required this.content})
      : super(key: key);
  final void Function() onPressed;
  final Color color;
  final double size;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, size),
      ),
      child: content,
    );
  }
}
