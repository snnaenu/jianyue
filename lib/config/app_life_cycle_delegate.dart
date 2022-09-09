import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AppLifeCycleDelegate with WidgetsBindingObserver {
  static final AppLifeCycleDelegate _appLifeCycleDelegate =
  AppLifeCycleDelegate._inital();
  AppLifeCycleDelegate._inital() {
    print("初始化生命周期代理");
    WidgetsBinding.instance?.addObserver(this);
  }
  factory AppLifeCycleDelegate() {
    return _appLifeCycleDelegate;
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
    print("手机主题发生变化");
    //强制触发 build
    Get.forceAppUpdate();
  }
}