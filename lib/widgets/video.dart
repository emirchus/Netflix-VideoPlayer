import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutternetflix/services/services.dart';
import 'package:flutternetflix/widgets/actions.dart';
import 'package:flutternetflix/widgets/brightness.dart';
import 'package:flutternetflix/widgets/fast_actions.dart';
import 'package:flutternetflix/widgets/navigation.dart';
import 'package:flutternetflix/widgets/subtitles.dart';
import 'package:flutternetflix/widgets/title.dart';
import 'package:video_player/video_player.dart';

class FlutterVideo extends StatefulWidget {

  const FlutterVideo({Key? key}) : super(key: key);

  @override
  State<FlutterVideo> createState() => _FlutterVideoState();
}

class _FlutterVideoState extends State<FlutterVideo> with TickerProviderStateMixin{
  late VideoPlayerController _controller;
  bool showControls = false;
  late AnimationController animations = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

  late double aspectRatio;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    // TODO: PONER URL DEL VIDEO ACÁ UWU
    _controller = VideoPlayerController.network('URL DEL VIDEO', closedCaptionFile: getClosedCaptions());

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _controller.initialize();
      aspectRatio = _controller.value.aspectRatio;
      setState(() {});
    });
  }

  Future<ClosedCaptionFile> getClosedCaptions() async {
    // SIRVE PARA USAR DESDE LOS ASSETS
    // final String fileContents = await rootBundle.loadString('assets/captions.srt');
    // return SubRipCaptionFile(fileContents);

    //TODO: PONER URL DEL CLOSED CAPTIONS ACÁ UWU
    String captions = await Services.getSRTData('URL DE LOS USBS');

    //TODO: EN CASO QUE SEA UN ARCHIVO SRT, SINO USAR WebVTTCaptionFile
    return SubRipCaptionFile(captions);
  }


  bool get isBlocked {
    return animations.value == 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        GestureDetector(
          onTap: toggleControls,
          onScaleUpdate: (details) {
            toggleAspectRatio(details.scale);
          },
          child: Stack(
            children: [
              SizedBox(
                child: Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              FastActions(controller: _controller,),
              AnimatedBuilder(
                animation: animations,
                builder: (_, __) => IgnorePointer(
                  ignoring: isBlocked,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: animations.value,
                        child: Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black.withOpacity(.4),
                        ),
                      ),
                      TitleNetflix(width: size.width, title: Uri.parse(_controller.dataSource).pathSegments.last, animation: animations, toggle: (){}),
                      ActionsNetflix(controller: _controller, animation: animations, toggle: (){}),
                      NavigationNetflix(width: size.width, controller: _controller, animation: animations)
                    ],
                  ),
                )
              )
            ],
          ),
        ),
        Subtitles(controller: _controller, isFixedBottom: showControls,),
        if(showControls)
          BrightnessBar(height: size.height / 4),
      ],
    );
  }

  toggleAspectRatio(details) {
    //Device aspect ratio
    final deviceAspectRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    setState(() {
      aspectRatio = details > 1 ? deviceAspectRatio : _controller.value.aspectRatio;
    });
  }

  toggleControls () {
    setState(() => showControls = !showControls);
    if(showControls) {
      animations.forward(from: 0.0);
      shoudHideControls();
    }else {
      animations.reverse();
    }
  }

  shoudHideControls() {
    if(_timer != null && _timer!.isActive) _timer!.cancel();

    _timer = Timer(const Duration(seconds: 3), () {
      if(showControls) {
        animations.reverse();
        setState(() {
          showControls = false;
        });
      }
    });
  }

  void positionBehavior(TapDownDetails details) async {
    log('Double tap');
    final size = MediaQuery.of(context).size;
    if(details.localPosition.dx < size.width / 2) {
      //Avanzar 10 segundos
      Duration? position = await _controller.position;
      if(position == null) return;
      if (position.inMilliseconds > 10000) {
        _controller.seekTo(position - const Duration(seconds: 10));
      } else {
        _controller.seekTo(Duration.zero);
      }
    }else{
      Duration? position = await _controller.position;
      if(position == null) return;
      if (position.inMilliseconds <_controller.value.duration.inMilliseconds - 10000) {
        _controller.seekTo(position + const Duration(seconds: 10));
      } else {
        _controller.seekTo(_controller.value.duration);
      }
    }
  }
}