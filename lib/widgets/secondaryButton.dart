import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final HeroIcon? icon;
  final Color? borderColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.icon,
    this.borderColor,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor ?? Colors.blueGrey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (icon != null) ...[
            const SizedBox(
              width: 10,
            ),
            icon!,
          ]
        ],
      ),
    );
  }
}
