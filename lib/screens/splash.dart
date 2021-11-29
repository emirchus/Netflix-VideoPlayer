import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutternetflix/widgets/button.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff161616),
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Image(image: AssetImage("assets/logo.png"), width: 200,),
            Center(child: ButtonComponent("INICIAR", Icons.play_arrow, onTap: () async {
              await Navigator.pushNamed(context, "/netflix");
              await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              await SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }))
          ],
        ),
      ),
    );
  }
}