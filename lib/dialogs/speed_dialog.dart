import 'package:flutter/material.dart';


class SpeedSelectorDialog extends StatelessWidget {
  const SpeedSelectorDialog({Key? key}) : super(key: key);


  static Future<double?> show (context) async {
    double? response = await showDialog(context: context, builder: (_) => const SpeedSelectorDialog()) as double?;

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff161616),
      contentTextStyle: const TextStyle(color: Colors.white),
      title: const Text("Select speed", style: TextStyle(color: Colors.white),),
      contentPadding: const EdgeInsets.only(top: 5, left: 24, right: 24),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [0.25, 0.5, 1.0, 1.25, 1.5].map<Widget>((e) => ListTile(
            title: Text("${e}x", style: const TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context, e)
          )).toList(),
        ),
      )
    );
  }
}