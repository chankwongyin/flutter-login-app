import 'package:flutter/material.dart';

import 'components.dart';

class ForgotPasswordButton extends StatefulWidget {
  final String username;

  const ForgotPasswordButton({Key? key, required this.username})
      : super(key: key);
  @override
  _ForgotPasswordButtonState createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blue[200];
              } else
                return Colors.blue;
            },
          ),
        ),
        onPressed: () {},
        child: CustomTextButton(
          title: 'Forgot Password',
          onPressed: () {
            Navigator.pushNamed(context, '/reset', arguments: widget.username);
          },
        ),
      ),
    );
  }
}
