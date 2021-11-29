import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleNetflix extends StatelessWidget {

  final double width;
  final String title;
  final AnimationController animation;
  final Function() toggle;

  const TitleNetflix({Key? key, required this.width, required this.title, required this.animation, required this.toggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, (animation.value - 1) * 10),
      child: Opacity(
        opacity: animation.value,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: width,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(.5)
              ],
              end: Alignment.topCenter, begin: Alignment.bottomCenter)
            ),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: IconButton(onPressed: () async {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.chevron_left_rounded, color: Colors.white), splashRadius: 20,)),
                Flexible(
                  flex: 2,
                  child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),
                ),
                Flexible(flex: 1, child: IconButton(onPressed: () {}, icon: const Icon(Icons.cast, color: Colors.white), splashRadius: 20,)),
              ],
            ),
          ),
        )
      ),
    );
  }
}