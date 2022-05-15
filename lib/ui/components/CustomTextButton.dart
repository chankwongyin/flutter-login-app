import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Color? color;
  final Function() onPressed;

  const CustomTextButton(
      {Key? key,
      required this.title,
      this.color = Colors.blue,
      required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return color!.withOpacity(0.2);
            } else
              return color;
          },
        ),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
