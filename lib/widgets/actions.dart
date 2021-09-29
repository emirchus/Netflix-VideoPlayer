import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ActionsNetflix extends StatefulWidget {

  final VideoPlayerController controller;
  final AnimationController animation;
  final Function() toggle;

  const ActionsNetflix({Key? key, required this.controller, required this.animation, required this.toggle}) : super(key: key);

  @override
  State<ActionsNetflix> createState() => _ActionsNetflixState();
}

class _ActionsNetflixState extends State<ActionsNetflix> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.animation.value,
      child: Align(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(flex: 1, child: IconButton(onPressed: () async {
              Duration? position = await widget.controller.position;
              if(position == null) return;
              var minutesTo = position.inSeconds - 10;
              await widget.controller.seekTo(Duration(days: position.inDays, hours: position.inHours, minutes: minutesTo > 0 ? minutesTo : 0, seconds: 0));
            }, icon: const Icon(Icons.replay_10_outlined, color: Colors.white), iconSize: 53, splashRadius: 20,)),
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  widget.controller.value.isPlaying
                      ? await widget.controller.pause()
                      : await widget.controller.play();
                  widget.toggle();
                },
                icon: Icon(widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                iconSize: 53,
                splashRadius: 20,
              )
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  widget.toggle();
                  Duration? position = await widget.controller.position;
                  if(position == null) return;
                  var minutesTo = position.inMinutes + 10;
                  await widget.controller.seekTo(Duration(days: position.inDays, hours: position.inHours, minutes: minutesTo < widget.controller.value.duration.inMinutes ? minutesTo : 0, seconds: position.inSeconds));
                },
                icon: const Icon(Icons.forward_10_outlined, color: Colors.white),
                iconSize: 53,
                splashRadius: 20,)
            ),
          ],
        ),
      )
    );
  }
}