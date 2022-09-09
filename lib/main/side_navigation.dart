import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/model/btn_info.dart';
import 'package:weapon/model/one_word_model.dart';
import 'package:weapon/typedef/function.dart';
import 'package:weapon/utils/color_util.dart';

///NavigationRail组件为侧边栏
class SideNavigation extends StatelessWidget {
  const SideNavigation(
      {required this.onItem,
      required this.selectedIndex,
      required this.sideItems,
      required this.isUnfold,
      required this.onUnfold,
      required this.isScale,
      required this.onScale,
      required this.oneWord,
      required this.oneWordClicked});

  ///侧边栏item
  final List<BtnInfo> sideItems;

  ///选择的index
  final int selectedIndex;
  final ParamSingleCallback onItem;

  ///是否展开  点击展开事件
  final bool isUnfold;
  final ParamSingleCallback<bool> onUnfold;

  ///缩放事件
  final bool isScale;
  final ParamSingleCallback<bool> onScale;

  final String oneWord;
  final ParamVoidCallback oneWordClicked;

  @override
  Widget build(BuildContext context) {
    // getOneWord();
    return Container(
      color: ThemeConfig.theme.cardColor,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopLeading(),
                _buildItem(0),
                _buildItem(1),
                _buildItem(2),
                _buildItem(3),
              ],
            ),
          ),
          buildOneWord(),
          SizedBox(
            height: 15.dp,
          )
        ],
      ),
    );
  }

  Widget buildOneWord() {
    return GestureDetector(
      onTap: oneWordClicked,
      child: Container(
        height: 70.dp,
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Text(
          oneWord,
          maxLines: 4,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF9C9C9C),
              fontFamily: 'ZCOOLXiaoWei',
              letterSpacing: 1.1,
              wordSpacing: 1.2,
              height: 1.4,
              fontStyle: FontStyle.normal,),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTopLeading() {
    return Center(
      child: Container(
        width: 50.dp,
        height: 50.dp,
        margin: EdgeInsets.only(top: 30.0.dp, bottom: 25.dp),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/images/app_icon.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    var item = sideItems[index];
    bool choose = selectedIndex == index;
    Image icon = choose
        ? Image.asset("assets/images/${item.icon}.png")
        : Image.asset("assets/images/${item.icon}_normal.png");
    Color color = choose ? const Color(0xFF0007F6) : const Color(0xFF697380);
    return GestureDetector(
      onTap: () => onItem(index),
      child: Container(
        height: 68.dp,
        color: Colors.transparent,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 64.dp,
              // color: ColorUtil.randomColor(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: 20.dp,
                      height: 20.dp,
                      child: icon),
                  SizedBox(
                    width: 14.dp,
                  ),
                  Text(
                    item.title ?? "",
                    style: TextStyle(color: color, fontSize: 16.sp, fontWeight: FontWeight.w300,),

                  ),
                ],
              ),
            ),
            choose
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(4.dp),
                                topRight: Radius.circular(4.dp)),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFABAEFF),
                                Color(0xFF686BFA),
                                Color(0xFF0007F6)
                              ],
                              tileMode: TileMode.repeated,
                            )
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: const Color(0xFFF5F5F5).withAlpha(255),
                            //       offset: const Offset(-4, 0.0),
                            //       blurRadius: 5.0,
                            //       spreadRadius: 0)
                            // ],
                            // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
                            ),
                        width: 7.dp,
                        height: 46.dp,
                      ),
                    ],
                  )
                : Container(
                    width: 7.dp,
                  ),
          ],
        ),
      ),
    );
  }
}
