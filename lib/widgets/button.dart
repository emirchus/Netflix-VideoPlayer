import 'package:flutter/material.dart';


class ButtonComponent extends StatelessWidget {

  final void Function()? onTap;
  final String text;
  final IconData icon;

  const ButtonComponent(this.text, this.icon, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Icon(icon),
          Text(text)
        ],
      ),
    );
  }
}