import 'package:flutter/material.dart';

class BannerWithImage extends StatelessWidget {
  final double width;

  const BannerWithImage({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Image(
        image: AssetImage('images/demo.png'),
      ),
    );
  }
}
