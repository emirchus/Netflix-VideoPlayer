import 'dart:developer';

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

class _ActionsNetflixState extends State<ActionsNetflix> with SingleTickerProviderStateMixin {
  late AnimationController animation = AnimationController(value: 1.0, duration: const Duration(milliseconds: 300), vsync: this);

  @override
  void initState() {
    widget.controller.addListener(updateState);
    super.initState();
  }

  updateState() async {
    if (widget.controller.value.isPlaying) {
      if (widget.controller.value.position.inMilliseconds > 0) {
        if (widget.controller.value.position.inMilliseconds < 0) {
          animation.forward();
        } else {
          animation.reverse();
        }
      }
    } else {
      if(animation.value == 0.0 || widget.controller.value.position.inMilliseconds == widget.controller.value.duration.inMilliseconds) {
        animation.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateState);
    super.dispose();
  }

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
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  Duration? position = await widget.controller.position;
                  if(position == null) return;
                  if (position.inMilliseconds > 10000) {
                    widget.controller.seekTo(position - const Duration(seconds: 10));
                  } else {
                    widget.controller.seekTo(Duration.zero);
                  }
                },
                icon: const Icon(Icons.replay_10_outlined, color: Colors.white),
                iconSize: 53
              )
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  if(widget.controller.value.isPlaying) {
                    await widget.controller.pause();
                    animation.forward();
                  } else {
                    await widget.controller.play();
                    animation.reverse();
                  }
                  setState(() {});
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: animation,
                  color: Colors.white,
                  size: 53,
                ),
              )
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  Duration? position = await widget.controller.position;
                  if(position == null) return;
                  if (position.inMilliseconds < widget.controller.value.duration.inMilliseconds - 10000) {
                    widget.controller.seekTo(position + const Duration(seconds: 10));
                  } else {
                    widget.controller.seekTo(widget.controller.value.duration);
                  }
                },
                icon: const Icon(Icons.forward_10_outlined, color: Colors.white),
                iconSize: 53
              )
            ),
          ],
        ),
      )
    );
  }
}