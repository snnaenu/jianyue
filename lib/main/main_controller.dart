import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/config/init_config.dart';
import 'package:weapon/main/main_state.dart';
import 'package:weapon/model/one_word_model.dart';

class MainController extends GetxController {
  final state = MainState();

  @override
  void onInit() {
    ///初始化应用信息
    InitConfig.initApp(Get.context);
    super.onInit();
    getOneWord();
  }

  ///切换tab
  void switchTap(int index) {
    state.selectedIndex = index;
    state.pageController.jumpToPage(index);
    update();
  }

  ///是否展开侧边栏
  void onUnfold(bool isUnfold) {
    state.isUnfold = !state.isUnfold;
    update();
  }

  ///是否缩放
  void onScale(bool isScale) {
    state.isScale = !state.isScale;
    update();
    initWindow(scale: isScale ? 1.25 : 1.0);
  }

  getOneWord() async {
    var dio = Dio();
    final response = await dio.get(Api.oneWord);
    OneWordModel detail = OneWordModel.fromJson(jsonDecode(response.toString()));
    String oneWord = detail.hitokoto ?? "";
    state.oneWord = oneWord;
    update();
  }
}