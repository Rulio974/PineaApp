import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:pineapp/models/dashboard/cards.dart';
import 'package:unicons/unicons.dart';

class StatusCard extends StatelessWidget {
  final String text;
  final IconData? icon;
  final HeroIcons? heroIcon;
  String data;
  final Color? color;

  StatusCard(
      {required this.text,
      this.icon,
      this.heroIcon,
      required this.data,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (data == "") data = "0";
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      // height: 100,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
              if (heroIcon != null)
                HeroIcon(
                  heroIcon!,
                  color: color ?? Colors.black,
                ),
              if (icon != null)
                Icon(
                  icon!,
                  color: color ?? Colors.black,
                ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${data}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ));
  }
}
