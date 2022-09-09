import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/theme_config.dart';

class BackButtonWidget extends StatelessWidget {
  Function clickCallBack;
  IconData icon = Icons.arrow_back_sharp;

  BackButtonWidget({Key? key, required this.clickCallBack, this.icon = Icons.arrow_back_sharp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clickCallBack();
      },
      child: Container(
        height: 60.dp,
        width: 60.dp,
        decoration: BoxDecoration(
            color: ThemeConfig.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(60.dp),
            boxShadow: [
              BoxShadow(
                  color: ThemeConfig.theme.shadowColor,
                  offset: const Offset(4, 4),
                  blurRadius: 5.0,
                  spreadRadius: 0)
            ]),
        child: Icon(
          icon,
          size: 22.sp,
          color: const Color(0xffc1c1c1),
        ),
      ),
    );
  }
}
