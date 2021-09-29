import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutternetflix/widgets/actions.dart';
import 'package:flutternetflix/widgets/brightness.dart';
import 'package:flutternetflix/widgets/navigation.dart';
import 'package:flutternetflix/widgets/title.dart';
import 'package:video_player/video_player.dart';

class NetflixVideoPlayer extends StatefulWidget {

  const NetflixVideoPlayer({Key? key}) : super(key: key);

  @override
  State<NetflixVideoPlayer> createState() => _NetflixVideoPlayerState();
}

class _NetflixVideoPlayerState extends State<NetflixVideoPlayer> with TickerProviderStateMixin{
  late VideoPlayerController _controller;
  bool showControls = false;
  late AnimationController animations = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    _controller = VideoPlayerController.network('URL') //URL Al video
      ..initialize().then((_) {
        setState(() {});
      });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: toggleControls,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const SizedBox(),
                  ),
                ),
                AnimatedBuilder(
                  animation: animations,
                  builder: (_, __) => Stack(
                    children: [
                      Opacity(
                        opacity: animations.value,
                        child: Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black.withOpacity(.4),
                        ),
                      ),
                      TitleNetflix(width: size.width, title: "Kobayashi", animation: animations, toggle: toggleControls),
                      ActionsNetflix(controller: _controller, animation: animations, toggle: toggleControls),
                      NavigationNetflix(width: size.width, controller: _controller, animation: animations)
                    ],
                  )
                )
              ],
            ),
          ),

          if(showControls)
            BrightnessBar(height: size.height / 4)
        ],
      ),
    );
  }

  toggleControls () {
    setState(() => showControls = !showControls);
    if(showControls) {
      animations.forward(from: 0.0);
    }else {
      animations.reverse();
    }
  }
}