import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/model/btn_info.dart';
import 'package:weapon/play/mobile_play_view.dart';

class MainMobileView extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (logic) {
        SystemUiOverlayStyle style = const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xffFFFFFF),
          systemNavigationBarDividerColor: Color(0xffFFFFFF),
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: style,
          child: OrientationBuilder(
            builder: (context, orientation) {
              return BaseScaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar: bottomBar(),
                body: PageView(
                  controller: controller.state.pageController,
                  onPageChanged: (index) {
                    controller.switchTap(index);
                  },
                  children: controller.state.pageList,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static const double iconWH = 21.0;

  Widget _buildBottomItem(int index) {
    BtnInfo btnInfo = controller.state.itemList[index];
    bool choose = controller.state.selectedIndex == index;
    Color color = choose ? const Color(0xFF0007F6) : const Color(0xFF697380);
    Image icon = choose
        ? Image.asset(
            "assets/images/${btnInfo.icon}.png",
            width: iconWH,
          )
        : Image.asset("assets/images/${btnInfo.icon}_normal.png",
            width: iconWH);
    String title = btnInfo.title ?? "";
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.state.pageController.jumpToPage(index);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: icon,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    title,
                    key: Key(title),
                    style: TextStyle(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
        ),
        // onPressed: () {
        //   controller.state.pageController.jumpToPage(index);
        // }
      ),
    );
  }

  Widget bottomBar() {
    List<Widget> tabs = [];
    for (var i = 0; i < controller.state.itemList.length; i++) {
      tabs.add(_buildBottomItem(i));
    }
    return Container(
      color: ThemeConfig.theme.primaryColor,
      child: SafeArea(
          bottom: true,
          //   maintainBottomViewPadding: false,
          child: SizedBox(
            height: 140.5.dp,
            child: Card(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(),
                margin: const EdgeInsets.all(0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(color: ThemeConfig.theme.dividerColor, height: 0.5),
                      const MobilePlayView(),
                      SizedBox(
                        height: 60.dp,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: tabs),
                      )
                    ])),
          )),
    );
  }
}
