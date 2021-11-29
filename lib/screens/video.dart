import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutternetflix/widgets/video.dart';


class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: FlutterVideo()
    );
  }
}