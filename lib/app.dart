import 'package:flutter/material.dart';
import 'package:flutternetflix/screens/splash.dart';
import 'package:flutternetflix/screens/video.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light(primary: Colors.white, onSurface: Colors.white, secondary: Colors.white),
        canvasColor: Colors.white,
      ),
      initialRoute: "/",
      routes: {
        "/":    (_) => const SplashScreen(),
        "/netflix": (_) => const VideoScreen()
      },
    );
  }
}