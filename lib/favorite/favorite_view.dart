import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/custom/audio_item_widget.dart';
import 'package:weapon/custom/back_button.dart';
import 'package:weapon/favorite/favorite_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_list_item.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({Key? key}) : super(key: key);
  final FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return BaseScaffold(
          appBar: AppBar(
            title: Text(
              "我的收藏",
              style: ThemeConfig.theme.appBarTheme.titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: ThemeConfig.theme.appBarTheme.centerTitle,
            backgroundColor: ThemeConfig.theme.appBarTheme.backgroundColor,
            systemOverlayStyle:
                ThemeConfig.theme.appBarTheme.systemOverlayStyle,
            elevation: ThemeConfig.theme.appBarTheme.elevation,
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
              child: GetBuilder<FavoriteController>(builder: (logic) {
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.dp, horizontal: 0),
                    itemBuilder: (ctx, index) {
                      HistoryPo item = controller.state.histories[index];
                      return AudioItemWidget(
                        name: item.name,
                        picUrl: item.picUrl,
                        duration: item.duration,
                        singer: item.artistStr,
                        isChoose: controller.state.selectedIndex == index,
                        clickCallBack: () => controller.chooseSong(item, index),
                        moreCallBack: () {
                        },
                      );
                    },
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.state.histories.length,
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
                  ),
                );
              })));
    }
    return Container(
      color: ThemeConfig.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          GetBuilder<FavoriteController>(builder: (logic) {
            return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 1.dp, horizontal: 0),
                  itemBuilder: (ctx, index) {
                    HistoryPo item = controller.state.histories[index];
                    return AudioItemWidget(
                      name: item.name,
                      picUrl: item.picUrl,
                      duration: item.duration,
                      singer: item.artistStr,
                      isChoose: controller.state.selectedIndex == index,
                      clickCallBack: () => controller.chooseSong(item, index),
                      moreCallBack: () {
                        // showModalBottomSheet(
                        //     context: ctx,
                        //     backgroundColor: Colors.white,
                        //     enableDrag: false,
                        //     builder: (BuildContext context) {
                        //       return Container(height: 200,width: 300, color: Colors.white,);
                        //     });

                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                              );
                            });
                      },
                    );
                  },
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.state.histories.length,
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
                icon: Icons.refresh_rounded,
                clickCallBack: controller.fetchData,
              )),
        ],
      ),
    );
  }
}
