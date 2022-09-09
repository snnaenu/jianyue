import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/custom/search_widget.dart';

class PlayViewAppBar extends StatelessWidget {
  const PlayViewAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: 88.dp,
      padding: EdgeInsets.only(left: 15.dp, right: 15.dp, top: 24.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.arrow_downward_rounded,
            size: 24.sp,
            color: const Color(0xFF404040),
          ),

          Text(
            "正在播放",
            maxLines: 1,
            style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF404040),),
            overflow: TextOverflow.ellipsis,
          ),

          Icon(
            Icons.more_horiz_rounded,
            size: 25.sp,
            color: const Color(0xFF404040),
          ),
        ],
      ),
    );
  }
}
