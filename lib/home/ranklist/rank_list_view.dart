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
import 'package:weapon/home/ranklist/rank_list_controller.dart';
import 'package:weapon/home/ranklist/rank_list_state.dart';
import 'package:weapon/home/songlist/songs_state.dart';
import 'package:weapon/home/songlist/songs_view.dart';
import 'package:weapon/model/rank_list_item_model.dart';
import 'package:weapon/utils/color_util.dart';
import 'package:weapon/utils/navigator_util.dart';

class RankListView extends StatefulWidget {
  const RankListView({Key? key}) : super(key: key);

  @override
  _RankListViewState createState() => _RankListViewState();
}

class _RankListViewState extends State<RankListView> {
  final RankListController controller = Get.put(RankListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<RankListController>();
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
              "排行榜",
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
              child: GetBuilder<RankListController>(builder: (controller) {
                return ScrollConfiguration(
                  behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: GridView.builder(
                    padding: EdgeInsets.all(15.dp),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    controller: controller.state.scrollController,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 15.dp,
                        crossAxisSpacing: 15.dp,
                        childAspectRatio: 1.2),
                    itemBuilder: (BuildContext context, int index) {
                      return itemWidget(index);
                    },
                    itemCount: controller.state.rankList.length,
                  ),
                );
              })));
    }
    return Container(
      color: ThemeConfig.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          GetBuilder<RankListController>(builder: (controller) {
            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: GridView.builder(
                padding: EdgeInsets.all(20.dp),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 20.dp,
                    crossAxisSpacing: 20.dp,
                    childAspectRatio: 1.2),
                itemBuilder: (BuildContext context, int index) {
                  return itemWidget(index);
                },
                itemCount: controller.state.rankList.length,
              ),
            );

            // return EasyRefresh(
            //     controller: EasyRefreshController(),
            //     scrollController: ScrollController(),
            //     header: ClassicalHeader(refreshedText: "开始刷新"),
            //     footer:
            //         BallPulseFooter(color: Colors.red, enableInfiniteLoad: false),
            //     onLoad: () => controller.loadMore(),
            //     onRefresh: () => controller.loadRefresh(),
            //     child: ScrollConfiguration(
            //       behavior:
            //           ScrollConfiguration.of(context).copyWith(scrollbars: false),
            //       child: GridView.builder(
            //         padding: EdgeInsets.all(20.dp),
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //             maxCrossAxisExtent: 300,
            //             mainAxisSpacing: 20.dp,
            //             crossAxisSpacing: 20.dp,
            //             childAspectRatio: 1.4),
            //         itemBuilder: (BuildContext context, int index) {
            //           return itemWidget(index);
            //         },
            //         itemCount: controller.state.playList.length,
            //       ),
            //     ));
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

  Widget itemWidget(int index) {
    RankListItemModel item = controller.state.rankList[index];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            SongsView(
              rankListItem: item,
              sourceType: SongSourceType.rankList,
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
                    spreadRadius: 0)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: item.imgurl ?? "",
                  imageBuilder: (context, image) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.dp),
                            topRight: Radius.circular(8.dp)),
                        image: DecorationImage(image: image, fit: BoxFit.cover),
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 2),
                ),
              ),
              SizedBox(
                height: 10.dp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.dp),
                child: Text(
                  item.rankname ?? "",
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
