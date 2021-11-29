import 'package:flutter/material.dart';
import 'package:flutternetflix/dialogs/speed_dialog.dart';
import 'package:flutternetflix/widgets/button.dart';
import 'package:video_player/video_player.dart';

class NavigationNetflix extends StatefulWidget {

  final double width;
  final VideoPlayerController controller;
  final AnimationController animation;

  const NavigationNetflix({Key? key, required this.width, required this.controller, required this.animation}) : super(key: key);

  @override
  State<NavigationNetflix> createState() => _NavigationNetflixState();
}

class _NavigationNetflixState extends State<NavigationNetflix> {

  Duration currentPosition = const Duration();
  Duration videoDuration = const Duration();

  double videoSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateState);
    super.dispose();
  }

  updateState() {
    setState(() {
      videoDuration = widget.controller.value.duration;
      currentPosition = widget.controller.value.position;
    });
  }

  @override
  Widget build(BuildContext context) {

    var _lastConso = DateTime.now().subtract(currentPosition);

    var diff = DateTime.now().subtract(videoDuration).difference(_lastConso).abs();

    var totalBuffered = widget.controller.value.buffered.map((e) => e.end.inMilliseconds);
    var bufferedSize = totalBuffered.isEmpty ? 0 : totalBuffered.reduce((a, b) => a + b);

    var buffered = ((100 * bufferedSize) / videoDuration.inMilliseconds).clamp(0, 100);

    final size = MediaQuery.of(context).size;

    return Transform.translate(
      offset: Offset(0,  (1 - widget.animation.value) * 10),
      child: Opacity(
        opacity: widget.animation.value,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: widget.width,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.black.withOpacity(.8),
                Colors.transparent
              ],
              end: Alignment.topCenter, begin: Alignment.bottomCenter)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 10,
                            width: (size.width * (buffered / 100)).clamp(0.0, size.width - 110),
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                          ),
                          SliderTheme(
                            data: const SliderThemeData(
                              overlayColor: Colors.transparent,
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                            ),
                            child: Slider(
                              value: widget.controller.value.isInitialized ? ((100 * currentPosition.inMilliseconds) / videoDuration.inMilliseconds).clamp(0.0, 100.0) : 0,
                              min: 0,
                              max: 100,
                              activeColor: const Color(0xffE50914),
                              onChanged: (value) {
                                widget.controller.seekTo(Duration(milliseconds: ((videoDuration.inMilliseconds / 100) * value).round()));
                                if(!widget.controller.value.isPlaying) {
                                  widget.controller.play();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(durationString(diff), style: const TextStyle(color: Colors.white),)
                  ],
                ),
                const SizedBox(height: 10,),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonComponent('Speed (${widget.controller.value.playbackSpeed}x)', Icons.speed_sharp, onTap: changeSpeed),
                    ButtonComponent('Lock', Icons.lock_open_sharp, onTap: lockVideo),
                    ButtonComponent('Episodes', Icons.layers_outlined, onTap: episodes),
                    ButtonComponent('Audio & Subtitles', Icons.subtitles_outlined, onTap: subtitles),
                    ButtonComponent('Next Episode', Icons.skip_next, onTap: nextEpsiode),
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  String durationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  changeSpeed() async {
    double speed = await SpeedSelectorDialog.show(context) ?? videoSpeed;
    await widget.controller.setPlaybackSpeed(speed);
  }

  lockVideo() {

  }

  episodes() {

  }

  subtitles() {

  }

  nextEpsiode() {
  }
}