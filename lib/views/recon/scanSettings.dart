import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ScanSettingsPage extends StatefulWidget {
  final String initialDuration;
  final bool initialCaptureHandshakes;

  ScanSettingsPage({
    required this.initialDuration,
    required this.initialCaptureHandshakes,
  });

  @override
  _ScanSettingsPageState createState() => _ScanSettingsPageState();
}

class _ScanSettingsPageState extends State<ScanSettingsPage> {
  late String scanDuration;
  late bool alwaysCaptureHandshakes;

  @override
  void initState() {
    super.initState();
    scanDuration = widget.initialDuration;
    alwaysCaptureHandshakes = widget.initialCaptureHandshakes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("Scan Settings"),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              leading: IconButton(
                icon: HeroIcon(HeroIcons.arrowLeft),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Scan Duration"),
                trailing: DropdownButton<String>(
                  value: scanDuration,
                  items: ['10 Seconds', '1 Minute', '5 Minutes', '10 Minutes']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      scanDuration = value!;
                    });
                  },
                ),
              ),
              MergeSemantics(
                child: ListTile(
                  title: const Text('Always Capture Handshakes'),
                  trailing: CupertinoSwitch(
                    value: alwaysCaptureHandshakes,
                    onChanged: (bool value) {
                      setState(() {
                        alwaysCaptureHandshakes = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      alwaysCaptureHandshakes = !alwaysCaptureHandshakes;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                  child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(16),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Save Settings",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ))
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.pop(context, {
              //         "duration": scanDuration,
              //         "alwaysCaptureHandshakes": alwaysCaptureHandshakes
              //       });
              //     },
              //     child: Text("Save Settings"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
