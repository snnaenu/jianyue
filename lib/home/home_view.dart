import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/custom/audio_item_widget.dart';
import 'package:weapon/home/home_controller.dart';
import 'package:weapon/home/playlist/play_list_view.dart';
import 'package:weapon/home/ranklist/rank_list_view.dart';
import 'package:weapon/custom/search_widget.dart';
import 'package:weapon/home/songlist/songs_state.dart';
import 'package:weapon/home/songlist/songs_view.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/utils/color_util.dart';
import 'package:weapon/utils/navigator_util.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeConfig.theme.appBarTheme.systemOverlayStyle ??
          SystemUiOverlayStyle.light,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GetBuilder<HomeController>(
            builder: (controller) {
              return BaseScaffold(
                appBar: _appWidget(),
                backgroundColor: ThemeConfig.theme.scaffoldBackgroundColor,
                body: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 30.dp,
                        ),
                        sectionHeader("assets/images/stars.png", "热门歌单",
                            callBack: () {
                          NavigatorUtil.push(context, const PlayListView());
                        }),
                        SizedBox(
                          height: 15.dp,
                        ),

                        /// 歌单
                        Container(
                          height: 170.dp,
                          color: ThemeConfig.theme.cardColor,
                          // padding: EdgeInsets.only(left: 15.dp),
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: 18.dp, horizontal: 20.dp),
                            itemBuilder: (ctx, index) {
                              return _playListItemWidget(index);
                            },
                            shrinkWrap: true,
                            itemCount: controller.state.playList.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (ctx, index) {
                              return SizedBox(
                                width: 20.dp,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.dp,
                        ),
                        sectionHeader("assets/images/rank.png", "排行榜",
                            callBack: () {
                          NavigatorUtil.push(context, const RankListView());
                        }),
                        SizedBox(
                          height: 15.dp,
                        ),
                        ListView.separated(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.dp, horizontal: 0),
                          itemBuilder: (ctx, index) {
                            HistoryPo item = controller.state.ranks[index];
                            String url = item.picUrl;
                            return AudioItemWidget(
                              name: item.name,
                              picUrl: url,
                              duration: item.duration,
                              singer: item.artistStr,
                              isChoose: controller.state.selectedIndex == index,
                              clickCallBack: () =>
                                  controller.chooseSong(item, index),
                              moreCallBack: () {},
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.state.ranks.length,
                          separatorBuilder: (ctx, index) {
                            if (ThemeConfig.isDark) {
                              return Divider(
                                height: 0.1,
                                color: ThemeConfig.theme.dividerColor,
                              );
                            }
                            return SizedBox(
                              height: 1.dp,
                            );
                          },
                        )
                      ],
                    )),
              );
            },
          );
        },
      ),
    );
  }





  /// 搜索
  _appWidget() {
    double top = 15.dp;
    if (Platform.isAndroid || Platform.isIOS) top = kToolbarHeight;
    return MyAppbar(
      height: (MyAppbar.appBarHeight + top).dp,
      child: Padding(
        padding: EdgeInsets.only(left: 15.dp, right: 15.dp, top: top),
        child: SearchWidget(
          start: controller.startSearch,
        ),
      ),
    );
  }

  _playListItemWidget(int index) {
    PlayListItemModel playListItem = controller.state.playList[index];
    double padding =
        (index == 0 || index == controller.state.playList.length - 1)
            ? 5.dp
            : 0.dp;
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            SongsView(
              playListItem: playListItem,
              sourceType: SongSourceType.playList,
            ));
        // NavigatorUtil.push(context, PlayListView());
        // Get.to(()=>SongsView());
      },
      child: SizedBox(
          width: 180.dp,
          // padding: EdgeInsets.only(left: padding),
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8.dp),
          //     boxShadow: [
          //       BoxShadow(
          //           color: const Color(0xffe0e0e0).withAlpha(100),
          //           offset: const Offset(6, 6),
          //           blurRadius: 7.0,
          //           spreadRadius: 0),
          //       BoxShadow(
          //           color: const Color(0xffe0e0e0).withAlpha(100),
          //           offset: const Offset(-6, -6),
          //           blurRadius: 7.0,
          //           spreadRadius: 0),
          //     ]
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  // width: 200.dp,
                  // height: 150.dp,
                  //maxHeightDiskCache: 10,
                  imageUrl: playListItem.coverImgUrl ?? "",
                  // placeholder: (context, url) => const CircleAvatar(
                  //   backgroundColor: Colors.amber,
                  //   radius: 150,
                  // ),
                  imageBuilder: (context, image) {
                    return Container(
                        // width: 200.dp,
                        // height: 150.dp,
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.dp),
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(8.dp),
                      //     topRight: Radius.circular(8.dp)),
                      image: DecorationImage(image: image, fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                            color: ThemeConfig.theme.shadowColor,
                            offset: const Offset(4, 4),
                            blurRadius: 5.0,
                            spreadRadius: 0),
                        BoxShadow(
                            color: ThemeConfig.theme.shadowColor,
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 0)
                      ],
                    ));
                  },
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      color: ColorUtil.randomColor().withAlpha(40),
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                  ),
                  //card_place_image.png
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 1),
                ),
              ),
              SizedBox(
                height: 10.dp,
              ),
              Text(
                playListItem.name ?? "",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeConfig.theme.textTheme.headline1?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(
              //   height: 10.dp,
              // ),
            ],
          )),
    );
  }

  Widget sectionHeader(String icon, String title, {Function? callBack}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.dp, right: 13.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 24.sp,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 13.dp,
              ),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: ThemeConfig.theme.textTheme.headline1?.color,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              if (callBack != null) callBack();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "查看更多",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ThemeConfig.theme.textTheme.subtitle1?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 2.dp,
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 15.sp,
                  color: ThemeConfig.theme.textTheme.subtitle1?.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
