import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/custom/audio_item_widget.dart';
import 'package:weapon/custom/back_button.dart';
import 'package:weapon/home/songlist/songs_controller.dart';
import 'package:weapon/home/songlist/songs_state.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/rank_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/utils/navigator_util.dart';

class SongsView extends StatefulWidget {
  PlayListItemModel? playListItem;
  RankListItemModel? rankListItem;
  SongSourceType sourceType;

  SongsView(
      {Key? key,
      this.playListItem,
      this.rankListItem,
      required this.sourceType})
      : super(key: key);

  @override
  _SongsViewState createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  final SongsController controller = Get.put(SongsController());

  @override
  void initState() {
    super.initState();

    controller.state.playListItem = widget.playListItem;
    controller.state.rankListItem = widget.rankListItem;
    controller.state.sourceType = widget.sourceType;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SongsController>();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.sourceType == SongSourceType.playList ? "歌单歌曲" : "榜单歌曲",
              style: ThemeConfig.theme.appBarTheme.titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
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
              onRefresh: () => controller.loadRefresh(widget.sourceType),
              child: GetBuilder<SongsController>(builder: (logic) {
                int length = controller.state.songs.length;
                return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.separated(
                      // padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 0),
                      itemBuilder: (ctx, index) {
                        return _itemWidget(index);
                      },
                      shrinkWrap: true,
                      primary: false,
                      itemCount: length,
                      controller: controller.state.scrollController,
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
              })));
    }
    return Container(
      color: ThemeConfig.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          GetBuilder<SongsController>(builder: (logic) {
            int length = controller.state.songs.length;
            return ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.separated(
                  // padding: EdgeInsets.symmetric(vertical: 0.dp, horizontal: 0),
                  itemBuilder: (ctx, index) {
                    return _itemWidget(index);
                  },
                  shrinkWrap: true,
                  primary: false,
                  itemCount: length,
                  controller: controller.state.scrollController,
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

  _itemWidget(index) {
    HistoryPo item = controller.state.songs[index];
    return AudioItemWidget(
      name: item.name,
      picUrl: item.picUrl,
      duration: item.duration,
      singer: item.artistStr,
      isChoose: controller.state.selectedIndex == index,
      clickCallBack: () => controller.chooseSong(item, index),
      moreCallBack: () {},
    );
  }
}
