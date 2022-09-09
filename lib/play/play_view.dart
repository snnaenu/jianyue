import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/play/lyric_view.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/lyric_util.dart';
import 'package:window_size/window_size.dart' as window_size;

class PlayView extends StatefulWidget {
  PlayView({
    Key? key,
  }) : super(key: key);

  @override
  _PlayViewState createState() {
    return _PlayViewState();
  }
}

class _PlayViewState extends State<PlayView> with TickerProviderStateMixin {
  final PlayController controller = Get.put(PlayController());
  double playViewWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frameSize();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayController>(
      builder: (controller) {
        String url = controller.state.currentPo.picUrl;
        String name = controller.state.currentPo.name;
        double iconSize = 22.dp;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
          decoration: BoxDecoration(color: ThemeConfig.theme.cardColor,
              // borderRadius: const BorderRadius.all(
              //   Radius.circular(40),
              // ),
              boxShadow: [
                BoxShadow(
                    color: ThemeConfig.theme.shadowColor,
                    offset: const Offset(-4, 0.0),
                    blurRadius: 5.0,
                    spreadRadius: 0)
              ]
              // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
              ),
          child: Column(
            children: [
              SizedBox(
                height: 10.dp,
              ),
              _authorWidget(),
              SizedBox(
                height: 10.dp,
              ),
              Container(
                height: 0.2,
                color: Colors.black26,
              ),
              SizedBox(
                height: 20.dp,
              ),
              CachedNetworkImage(
                // width: 200.dp,
                // height: 200.dp,
                imageUrl: url,
                imageBuilder: (context, image) {
                  return Container(
                    // width: playViewWidth,
                    height: 180.dp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.dp),
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                              color: ThemeConfig.theme.shadowColor,
                              offset: const Offset(4, 4),
                              blurRadius: 5.0,
                              spreadRadius: 0)
                        ]),
                  );
                },
                // placeholder: (context, url) => CircleAvatar(
                //   backgroundColor: Colors.blue.shade300,
                //   radius: 20.dp,
                // ),
                errorWidget: (context, url, error) => Container(),
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 1),
              ),
              SizedBox(
                height: 20.dp,
              ),
              Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ThemeConfig.theme.textTheme.headline1?.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  )),
              SizedBox(
                height: 15.dp,
              ),
              _progressWidget(),
              SizedBox(
                height: 20.dp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.previous,
                    child: Container(
                      child: Icon(
                        Icons.skip_previous_rounded,
                        size: iconSize,

                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.stopAndPlay,
                    child: Container(
                      child: controller.isPlaying
                          ? Icon(
                              Icons.pause_circle_outline_rounded,
                              size: iconSize,
                            )
                          : Icon(
                              Icons.play_arrow_rounded,
                              size: iconSize,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.next,
                    child: Container(
                      child: Icon(
                        Icons.skip_next_rounded,
                        size: iconSize,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.collect,
                    child: Container(
                      child: Icon(
                        controller.state.isSaved
                            ? Icons.star_rate_rounded
                            : Icons.star_border_rounded,
                        size: iconSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.dp,
              ),
              _lyricContainerWidget()
            ],
          ),
        );
      },
    );
  }

  void frameSize() async {
    var window = await window_size.getWindowInfo();
    if (window.screen == null) {
      return;
    }
    double width = window.screen!.visibleFrame.width;
    playViewWidth = width / 5 - 20;
  }

  _lyricContainerWidget() {
    if (controller.state.currentPo.lyrics.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          '歌词加载中...',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      );
    }
    int position = controller.state.position.inMilliseconds;
    int duration = controller.state.duration.inMilliseconds;
    var p = position > duration ? duration : position;
    int curLine = LyricUtil.findLyricIndex(
        p.toDouble(), controller.state.currentPo.lyrics);

    // print("_lyricContainerWidget curLine = $curLine");
    bool isDragging = controller.state.lyricWidget?.isDragging ?? true;
    if (controller.state.lyricWidget != null) {
      if (!isDragging) {
        startLineAnim(curLine);
      }
      controller.state.lyricWidget?.curLine = curLine;
    }

    Size size = controller.state.lyricWidget?.canvasSize ?? const Size(0, 0);

    return Expanded(
      child: Container(
        width: playViewWidth-100,
          child: GestureDetector(
        onTapDown: isDragging
            ? (e) {
                int dragLineTime =
                    controller.state.lyricWidget?.dragLineTime ?? 0;
                if (e.localPosition.dx > 0 &&
                    e.localPosition.dx < 100.dp &&
                    e.localPosition.dy > size.height / 2 - 100.dp &&
                    e.localPosition.dy < size.height / 2 + 100.dp) {
                  // AudioPlayerUtil.instance
                  //     .seek(Duration(milliseconds: dragLineTime));
                }
              }
            : null,
        onVerticalDragUpdate: (e) {
          if (!isDragging) {
            setState(() {
              controller.state.lyricWidget?.isDragging = true;
            });
          }
          controller.state.lyricWidget?.offsetY += e.delta.dy;
        },
        onVerticalDragEnd: (e) {
          cancelDragTimer();
        },
        child: CustomPaint(
          // size: Size(50, 0),
          painter: controller.state.lyricWidget,
        ),
      )),
    );
  }

  void cancelDragTimer() {
    // if (controller.state.dragEndTimer != null) {
    //   if (controller.state.dragEndTimer.isActive) {
    //     controller.state.dragEndTimer.cancel();
    //     // controller.state.dragEndTimer.;
    //   }
    // }
    // dragEndTimer = Timer(dragEndDuration, dragEndFunc);
  }

  /// 开始下一行动画
  void startLineAnim(int curLine) {
    // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
    if (controller.state.lyricWidget == null) return;
    LyricView lyricView = controller.state.lyricWidget!;
    if (lyricView.curLine != curLine) {
      var lyricOffsetYController = controller.state.lyricOffsetYController;
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (lyricOffsetYController != null) {
        lyricOffsetYController.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      lyricOffsetYController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lyricOffsetYController?.dispose();
          }
        });
      // 计算出来当前行的偏移量
      var end = lyricView.computeScrollY(curLine) * -1;
      // 起始为当前偏移量，结束点为计算出来的偏移量

      Animation animation = Tween<double>(begin: lyricView.offsetY, end: end)
          .animate(lyricOffsetYController);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      lyricOffsetYController.addListener(() {
        lyricView.offsetY = animation.value;
      });
      // 启动动画
      lyricOffsetYController.forward();
    }
  }

  _progressWidget() {
    double value = 0.0;

    int position = controller.state.position.inMilliseconds;
    int duration = controller.state.duration.inMilliseconds;
    if (position > 0 && position < duration) {
      value = position / duration;
    }
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        //slider modifications
        thumbColor: const Color(0xFFEB1555),
        inactiveTrackColor: const Color(0xFF8D8E98),
        activeTrackColor: Colors.white,
        overlayColor: const Color(0x99EB1555),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 1.0),
        trackHeight: 2,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        // divisions: 5,
        inactiveColor: ThemeConfig.theme.textTheme.subtitle1?.color,
        activeColor: Colors.redAccent,
        onChanged: (v) {
          final curPosition = v * duration;
          // AudioPlayerUtil.instance
          //     .seek(Duration(milliseconds: curPosition.round()));
        },
        value: value,
      ),
    );
  }

  _authorWidget() {
    String url = controller.state.currentPo.picUrl;
    String name = controller.state.currentPo.artistStr;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.dp),
      child: Row(
        children: [
          CachedNetworkImage(
            width: 44.dp,
            height: 44.dp,
            imageUrl: url,
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 22.dp,
            ),
            placeholder: (context, url) => CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 22.dp,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 22.dp,
            ),
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 1),
          ),
          SizedBox(
            width: 10.dp,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ThemeConfig.theme.textTheme.headline1?.color,
                      fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.dp,
                ),
                Text(
                  "ta 好像什么也没有留下~",
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: ThemeConfig.theme.textTheme.subtitle1?.color,
                      fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
