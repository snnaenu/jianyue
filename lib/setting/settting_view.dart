import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/config/theme_config.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return BaseScaffold(
          appBar: AppBar(
            centerTitle: ThemeConfig.theme.appBarTheme.centerTitle,
            title: Text(
              "设置",
              style: ThemeConfig.theme.appBarTheme.titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: ThemeConfig.theme.appBarTheme.backgroundColor,
            systemOverlayStyle:
                ThemeConfig.theme.appBarTheme.systemOverlayStyle,
            elevation: ThemeConfig.theme.appBarTheme.elevation,
          ),
          // backgroundColor: const Color(0xffF6F8F9),
          backgroundColor: ThemeConfig.theme.scaffoldBackgroundColor,
          body: ListView.separated(
            // padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 0),
            itemBuilder: (ctx, index) {
              return _itemWidget();
            },
            // shrinkWrap: false,
            // primary: false,
            itemCount: 1,
            // controller: controller.state.scrollController,
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: 1.dp,
              );
            },
          ));
    }
    return Container(
      color: ThemeConfig.theme.scaffoldBackgroundColor,
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.separated(
            // padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 0),
            itemBuilder: (ctx, index) {
              return _itemWidget();
            },
            shrinkWrap: true,
            primary: false,
            itemCount: 1,
            // controller: controller.state.scrollController,
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: 1.dp,
              );
            },
          )),
    );
  }

  Widget _itemWidget() {
    return GestureDetector(
      onTap: () {
        Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
        Future.delayed(Duration(milliseconds: 250), () {
          Get.forceAppUpdate();
        });
      },
      child: Container(
        color: ThemeConfig.theme.cardColor,
        height: 68.dp,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.dp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/theme.png",
                  width: 22.dp,
                  height: 22.dp,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  width: 10.dp,
                ),
                Text(
                  "换主题",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ThemeConfig.theme.textTheme.headline1?.color,
                  ),
                ),
              ],
            ),
            Text(
              ThemeConfig.isDark ? "浅色" : "深色",
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeConfig.theme.textTheme.subtitle1?.color,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _darkWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "DARK",
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 25.sp,
            color: const Color(0xFF9C9C9C),
            fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _fontItemWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Aa",
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 33.sp,
          color: const Color(0xFF9C9C9C),
          fontFamily: 'ZCOOLXiaoWei',
          letterSpacing: 1.1,
          wordSpacing: 1.2,
          height: 1.4,
          fontStyle: FontStyle.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _font2ItemWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Aa",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 33.sp,
          color: const Color(0xFF9C9C9C),
          fontFamily: 'JasonHandwriting2',
          letterSpacing: 1.1,
          wordSpacing: 1.2,
          height: 1.4,
        ),
      ),
    );
  }
}
