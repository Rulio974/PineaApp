import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:timeago/timeago.dart' as timeago;

class HandshakeCard extends StatelessWidget {
  final Map<String, dynamic> handshake;

  const HandshakeCard({
    Key? key,
    required this.handshake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(right: 16),
              child: SizedBox(
                height: 60,
                child: Align(
                  alignment: Alignment.center,
                  child: handshake["type"] == "partial"
                      ? const HeroIcon(
                          HeroIcons.exclamationCircle,
                          size: 30,
                          color: Colors.deepOrange,
                        )
                      : const HeroIcon(
                          HeroIcons.checkCircle,
                          color: Colors.lightGreen,
                        ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mac address: ${handshake["mac"]}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Client: ${handshake["client"]}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Type: ${handshake["type"]}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Text(
            timeago.format(DateTime.parse(handshake["timestamp"])),
          ),
        ],
      ),
    );
  }
}
