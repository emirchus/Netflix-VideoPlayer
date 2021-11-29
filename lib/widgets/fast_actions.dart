import 'package:flutter/material.dart';
import 'package:flutternetflix/ripples/ripple_painter.dart';
import 'package:video_player/video_player.dart';


class FastActions extends StatefulWidget {

  final VideoPlayerController controller;

  const FastActions({Key? key, required this.controller}) : super(key: key);

  @override
  State<FastActions> createState() => _FastActionsState();
}

class _FastActionsState extends State<FastActions> with TickerProviderStateMixin {

  late AnimationController leftAnimation = AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 500));
  late AnimationController rightAnimation = AnimationController(value: 1, vsync: this, duration: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Flex(
      mainAxisSize: MainAxisSize.max,
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: leftAnimation,
          builder: (context, child) {
            return SizedBox(
              width: size.width * 0.5,
              height: size.height,
              child: CustomPaint(
                size: Size(size.width * 0.5, size.height),
                painter: RipplePainter(leftAnimation.value, true),
                child: GestureDetector(
                  onDoubleTap: () async {
                     Duration? position = await widget.controller.position;
                    if(position == null) return;
                    if (position.inMilliseconds > 10000) {
                      widget.controller.seekTo(position - const Duration(seconds: 10));
                      if(leftAnimation.isAnimating) {
                        leftAnimation.reset();
                      }
                      leftAnimation.forward(from: 0.0);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        Icons.fast_rewind,
                        color: Colors.white.withOpacity(((1 - leftAnimation.value) / .3).clamp(0.0, 1.0)),
                        size: 50,
                      ),
                    )
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: rightAnimation,
          builder: (context, child) {
            return SizedBox(
              width: size.width * 0.5,
              height: size.height,
              child: CustomPaint(
                size: Size(size.width * 0.5, size.height),
                painter: RipplePainter(rightAnimation.value, false),
                child: GestureDetector(
                  onDoubleTap: () async {
                    Duration? position = await widget.controller.position;
                    if(position == null) return;
                    if (position.inMilliseconds < widget.controller.value.duration.inMilliseconds - 10000) {
                      widget.controller.seekTo(position + const Duration(seconds: 10));
                      if(rightAnimation.isAnimating) {
                        rightAnimation.reset();
                      }
                      rightAnimation.forward(from: 0.0);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        Icons.fast_forward,
                        color: Colors.white.withOpacity(((1 - rightAnimation.value) / .3).clamp(0.0, 1.0)),
                        size: 50,
                      ),
                    )
                  ),
                ),
              ),
            );
          }
        )
      ],
    );
  }
}