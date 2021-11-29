import 'package:flutter/material.dart';
import 'package:brightness_volume/brightness_volume.dart';


class BrightnessBar extends StatefulWidget {

  final double height;

  const BrightnessBar({Key? key, required this.height}) : super(key: key);

  @override
  State<BrightnessBar> createState() => _BrightnessBarState();
}

class _BrightnessBarState extends State<BrightnessBar> {

  double brightness = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      brightness = ((await BVUtils.brightness).clamp(0.0, 1.0) * 100);
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: widget.height,
      child: Column(
        children: [
          const Icon(Icons.wb_sunny, color: Colors.white),
          const SizedBox(height: 10,),
          RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: const SliderThemeData(
                valueIndicatorColor: Colors.transparent,
                rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 0),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0, elevation: 0, disabledThumbRadius: 0, pressedElevation: 0),
                thumbColor: Colors.transparent,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0)
              ),
              child: Slider(
                value: brightness,
                min: 0,
                max: 100,
                label: "0",
                onChanged: (double value) async {
                  setState(() {
                    brightness = value;
                  });
                  BVUtils.setBrightness(value / 100);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}