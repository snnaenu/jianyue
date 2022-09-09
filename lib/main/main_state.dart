import 'package:flutter/material.dart';
import 'package:flutter_toolkit_easy/flutter_toolkit.dart';
import 'package:weapon/favorite/favorite_view.dart';
import 'package:weapon/home/home_view.dart';
import 'package:weapon/model/btn_info.dart';
import 'package:weapon/search/search_view.dart';
import 'package:weapon/setting/settting_view.dart';

class MainState {
  ///选择index
  late int selectedIndex;

  ///控制是否展开
  late bool isUnfold;

  ///是否缩放
  late bool isScale;

  ///分类按钮数据源
  late List<BtnInfo> list;

  ///Navigation的item信息
  late List<BtnInfo> itemList;

  ///PageView页面
  late List<Widget> pageList;
  late PageController pageController;

  String? oneWord;

  MainState() {
    //初始化index
    selectedIndex = 0;
    //默认不展开
    isUnfold = false;
    //默认不缩放
    isScale = false;
    //PageView页面
    pageList = [
      KeepAlivePage(const HomeView()),
      KeepAlivePage(SearchView()),
      KeepAlivePage(FavoriteView()),
      KeepAlivePage(SettingView())
    ];
    //item栏目
    itemList = [
      BtnInfo(
        title: "首页",
        icon: "home",
      ),
      BtnInfo(
        title: "搜索",
        icon: "search",
      ),
      BtnInfo(
        title: "收藏",
        icon: "favorite",
      ),
      BtnInfo(
        title: "设置",
        icon: "setting",
      ),
    ];
    //页面控制器
    pageController = PageController();
  }
}
