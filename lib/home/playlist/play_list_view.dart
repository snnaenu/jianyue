import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/custom/back_button.dart';
import 'package:weapon/home/playlist/play_list_controller.dart';
import 'package:weapon/home/playlist/play_list_state.dart';
import 'package:weapon/home/songlist/songs_state.dart';
import 'package:weapon/home/songlist/songs_view.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/utils/color_util.dart';
import 'package:weapon/utils/navigator_util.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key}) : super(key: key);

  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final PlayListController controller = Get.put(PlayListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<PlayListController>();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    if (Platform.isAndroid || Platform.isIOS) {
      return BaseScaffold(
          appBar: AppBar(
            centerTitle: ThemeConfig.theme.appBarTheme.centerTitle,
            backgroundColor: ThemeConfig.theme.appBarTheme.backgroundColor,
            systemOverlayStyle:
                ThemeConfig.theme.appBarTheme.systemOverlayStyle,
            elevation: ThemeConfig.theme.appBarTheme.elevation,
            // centerTitle: true,
            title: Text(
              "热门歌单",
              style: ThemeConfig.theme.appBarTheme.titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
            // backgroundColor: ThemeConfig.theme.primaryColor,
            // elevation: 0.0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: ThemeConfig.theme.appBarTheme.iconTheme?.color,
                    size: ThemeConfig.theme.appBarTheme.iconTheme?.size,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          backgroundColor: ThemeConfig.theme.scaffoldBackgroundColor,
          body: EasyRefresh(
              controller: EasyRefreshController(),
              scrollController: ScrollController(),
              header: BallPulseHeader(color: const Color(0xff8E96FF)),
              footer:
                  BallPulseFooter(color: Colors.red, enableInfiniteLoad: false),
              onLoad: null,
              onRefresh: () => controller.loadRefresh(),
              child: GetBuilder<PlayListController>(builder: (controller) {
                return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.separated(
                      // padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 0),
                      itemBuilder: (ctx, index) {
                        return _horizontalItemWidget(index);
                      },
                      shrinkWrap: true,
                      primary: false,
                      itemCount: controller.state.playList.length,
                      controller: controller.state.scrollController,
                      // padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 15.dp),
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
                    ));
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: GridView.builder(
                    padding: EdgeInsets.all(15.dp),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    controller: controller.state.scrollController,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 15.dp,
                        crossAxisSpacing: 15.dp,
                        childAspectRatio: 1.2),
                    itemBuilder: (BuildContext context, int index) {
                      return _horizontalItemWidget(index);
                    },
                    itemCount: controller.state.playList.length,
                  ),
                );
              })));
    }
    return Container(
      color: ThemeConfig.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          GetBuilder<PlayListController>(builder: (controller) {
            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: GridView.builder(
                padding: EdgeInsets.all(20.dp),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: controller.state.scrollController,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 20.dp,
                    crossAxisSpacing: 20.dp,
                    childAspectRatio: 1.4),
                itemBuilder: (BuildContext context, int index) {
                  return itemWidget(index);
                },
                itemCount: controller.state.playList.length,
              ),
            );
          }),
          Positioned(
              bottom: 30,
              right: 30,
              child: BackButtonWidget(
                clickCallBack: () {
                  NavigatorUtil.pop(context, returnData: {});
                },
              )),
        ],
      ),
    );
  }

  Widget _horizontalItemWidget(int index) {
    PlayListItemModel item = controller.state.playList[index];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            SongsView(
              playListItem: item,
              sourceType: SongSourceType.playList,
            ));
      },
      child: Container(
          height: 126.dp,
          padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
          decoration: BoxDecoration(
            color: ThemeConfig.theme.cardColor,
            borderRadius: BorderRadius.circular(8.dp),
            // boxShadow: [
            //   BoxShadow(
            //       color: ThemeConfig.theme.shadowColor,
            //       offset: const Offset(6, 6),
            //       blurRadius: 7.0,
            //       spreadRadius: 0),
            //   BoxShadow(
            //       color: ThemeConfig.theme.shadowColor,
            //       offset: const Offset(-6, -6),
            //       blurRadius: 7.0,
            //       spreadRadius: 0),
            // ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (item.coverImgUrl?.isNotEmpty ?? false)
                  ? CachedNetworkImage(
                      imageUrl: item.coverImgUrl!,
                      imageBuilder: (context, image) {
                        return Container(
                          width: 170.dp,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(8.dp),
                            //     bottomLeft: Radius.circular(8.dp)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.dp)),
                            image: DecorationImage(
                                image: image, fit: BoxFit.cover),
                          ),
                        );
                      },
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: ColorUtil.randomColor().withAlpha(40),
                          borderRadius: BorderRadius.circular(8.dp),
                        ),
                      ),
                      //card_place_image.png
                      errorWidget: (context, url, error) {
                        print("error = $error");
                        return const Icon(Icons.error);
                      },
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 2),
                    )
                  : Container(),
              SizedBox(
                width: 10.dp,
              ),
              Expanded(
                child: Text(
                  item.name ?? "",
                  maxLines: 2,
                  style: ThemeConfig.theme.textTheme.headline1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 15.dp,
              ),
            ],
          )),
    );
  }

  Widget itemWidget(int index) {
    PlayListItemModel item = controller.state.playList[index];
    // print(item.coverImgUrl);
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            SongsView(
              playListItem: item,
              sourceType: SongSourceType.playList,
            ));
      },
      child: Container(
          decoration: BoxDecoration(
              color: ThemeConfig.theme.cardColor,
              borderRadius: BorderRadius.circular(8.dp),
              boxShadow: [
                BoxShadow(
                    color: ThemeConfig.theme.shadowColor,
                    offset: const Offset(6, 6),
                    blurRadius: 7.0,
                    spreadRadius: 0),
                BoxShadow(
                    color: ThemeConfig.theme.shadowColor,
                    offset: const Offset(-6, -6),
                    blurRadius: 7.0,
                    spreadRadius: 0),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: (item.coverImgUrl?.isNotEmpty ?? false)
                    ? CachedNetworkImage(
                        imageUrl: item.coverImgUrl!,
                        imageBuilder: (context, image) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.dp),
                                  topRight: Radius.circular(8.dp)),
                              image: DecorationImage(
                                  image: image, fit: BoxFit.cover),
                            ),
                          );
                        },
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            color: ColorUtil.randomColor().withAlpha(40),
                            borderRadius: BorderRadius.circular(8.dp),
                          ),
                        ),
                        //card_place_image.png
                        errorWidget: (context, url, error) {
                          print("error = $error");
                          return const Icon(Icons.error);
                        },
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 2),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 10.dp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.dp),
                child: Text(
                  item.name ?? "",
                  maxLines: 1,
                  style: ThemeConfig.theme.textTheme.headline1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 15.dp,
              ),
            ],
          )),
    );
  }
}
