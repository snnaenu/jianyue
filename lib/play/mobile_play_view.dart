import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/play/lyric_view.dart';
import 'package:weapon/play/play_control_view.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/lyric_util.dart';
import 'package:weapon/utils/navigator_util.dart';
import 'package:window_size/window_size.dart' as window_size;

class MobilePlayView extends StatefulWidget {
  const MobilePlayView({
    Key? key,
  }) : super(key: key);

  @override
  _MobilePlayViewState createState() {
    return _MobilePlayViewState();
  }
}

class _MobilePlayViewState extends State<MobilePlayView>
    with TickerProviderStateMixin {
  final PlayController controller = Get.put(PlayController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayController>(
      builder: (controller) {
        String url = controller.state.currentPo.picUrl;
        String name = controller.state.currentPo.name;
        String artist = controller.state.currentPo.artistStr;
        double iconSize = 22.dp;
        return Container(
          // height: 81.dp,
          padding: EdgeInsets.symmetric(horizontal: 5.dp),
          // decoration: BoxDecoration(
          //     border: Border(
          //   top: BorderSide(width: 0.5, color: Color(0xff999999)),
          // )),
          child: SizedBox(
            height: 80.dp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.dp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.dp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            NavigatorUtil.push(
                                context, const PlayControlView());
                          },
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: url,
                                imageBuilder: (context, image) {
                                  return Container(
                                    height: 50.dp,
                                    width: 50.dp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.dp),
                                      image: DecorationImage(
                                          image: image, fit: BoxFit.cover),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Colors.blue.shade300,
                                  radius: 20.dp,
                                ),
                                errorWidget: (context, url, error) =>
                                    Container(),
                                fadeOutDuration: const Duration(seconds: 1),
                                fadeInDuration: const Duration(seconds: 1),
                              ),
                              SizedBox(
                                width: 15.dp,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ThemeConfig
                                              .theme.textTheme.headline1?.color,
                                          fontSize: 15.sp,
                                        )),
                                    SizedBox(
                                      height: 10.dp,
                                    ),
                                    Text(artist,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ThemeConfig
                                              .theme.textTheme.subtitle1?.color,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.dp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: controller.previous,
                            child: Icon(
                              Icons.skip_previous_rounded,
                              size: iconSize,
                              color: const Color(0xff2d2d2d),
                            ),
                          ),
                          SizedBox(
                            width: 20.dp,
                          ),
                          GestureDetector(
                            onTap: controller.stopAndPlay,
                            child: Container(
                              child: controller.isPlaying
                                  ? Icon(
                                      Icons.pause_circle_outline_rounded,
                                      size: iconSize,
                                      color: const Color(0xff2d2d2d),
                                    )
                                  : Icon(
                                      Icons.play_arrow_rounded,
                                      size: iconSize,
                                      color: const Color(0xff2d2d2d),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 20.dp,
                          ),
                          GestureDetector(
                            onTap: controller.next,
                            child: Container(
                              child: Icon(
                                Icons.skip_next_rounded,
                                size: iconSize,
                                color: const Color(0xff2d2d2d),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _progressWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  _progressWidget() {
    double value = 0.0;

    int position = controller.state.position.inMilliseconds;
    int duration = controller.state.duration.inMilliseconds;
    if (position > 0 && position < duration) {
      value = position / duration;
    }

    value = value * (MediaQuery.of(context).size.width - 10);
    // print("duration:$duration; position:$position; value:$value");
    // background-image: linear-gradient(90deg, #8E96FF 0%, #2C33F9 57%, #C145DB 100%);
    return Container(
      width: value,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff8E96FF),
              Color(0xff2C33F9),
              Color(0xffC145DB),
            ],
            stops: [0.0, 0.57, 1],
            tileMode: TileMode.repeated,
          )),
      height: 2,
    );
  }
}
