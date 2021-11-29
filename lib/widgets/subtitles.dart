import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class Subtitles extends StatefulWidget {

  final VideoPlayerController controller;
  final bool isFixedBottom;

  const Subtitles({Key? key, required this.controller, required this.isFixedBottom}) : super(key: key);

  @override
  State<Subtitles> createState() => _SubtitlesState();
}

class _SubtitlesState extends State<Subtitles> {

  Caption currentCaption = const Caption(end: Duration.zero, text: '', start: Duration.zero, number: -1);

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
      currentCaption = widget.controller.value.caption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: widget.isFixedBottom ? 100 : 20,
      width: size.width,
      child: Text(currentCaption.text, softWrap: true, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, backgroundColor: Colors.black38),)
    );
  }
}