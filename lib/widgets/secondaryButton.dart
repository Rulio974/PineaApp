import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final HeroIcon? icon;
  final Color? borderColor;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.icon,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor ?? Colors.blueGrey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (icon != null) ...[
            icon!,
            const SizedBox(
              width: 10,
            ),
          ]
        ],
      ),
    );
  }
}
