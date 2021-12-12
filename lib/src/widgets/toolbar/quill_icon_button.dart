import 'package:flutter/material.dart';

class QuillIconButton extends StatelessWidget {
  const QuillIconButton({
    required this.onPressed,
    this.icon,
    this.size = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget? icon;
  final double size;
  final LinearGradient? fillColor;
  final double hoverElevation;
  final double highlightElevation;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: Container(
        decoration: BoxDecoration(
          gradient: fillColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: RawMaterialButton(
          visualDensity: VisualDensity.compact,
          elevation: 0,
          hoverElevation: hoverElevation,
          highlightElevation: hoverElevation,
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }
}
