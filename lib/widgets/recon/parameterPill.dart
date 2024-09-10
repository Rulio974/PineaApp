import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Parameterpill extends StatelessWidget {
  String? title;
  HeroIcons icon;
  Color? color;
  double? height;

  Parameterpill(
      {this.title, required this.icon, this.color, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          HeroIcon(
            icon!,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title ?? "parameter pills",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
