import 'package:flutter/material.dart';

class WebLandView extends StatelessWidget {
  const WebLandView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Stack(
      children: [
        _buildBackground(),
        Container(color: const Color(0xFF000000).withAlpha(150),)
      ],
    ),);
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg_cover.jpeg'),
            fit: BoxFit.cover),
        // borderRadius: BorderRadius.only(
        //     bottomRight: Radius.circular(400),
        //     topLeft: Radius.circular(400))
      ),
    );
  }
}
