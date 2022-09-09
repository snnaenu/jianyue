import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:weapon/config/route_config.dart';
import 'package:weapon/config/theme_config.dart';
import 'package:weapon/custom/custom_loading_widget.dart';
import 'package:weapon/custom/custom_toast_widget.dart';
import 'package:weapon/net/kugou_music_request.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/net/netease_music_request.dart';
import 'package:weapon/net/qq_music_request.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/database_util.dart';

import 'net/kuwo_music_request.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseUtil.initDB();
  runApp(const MyApp());
  // 透明状态栏
  if (Platform.isAndroid) {
    const SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // LeanCloudUtil.initSDK();
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        initialRoute: RouteConfig.webLand,
        debugShowCheckedModeBanner: false,
        getPages: RouteConfig.getPages,
        // home: WebLandView(),
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        navigatorObservers: [FlutterSmartDialog.observer],
        // builder: FlutterSmartDialog.init(
        //   toastBuilder: (String msg, AlignmentGeometry alignment) {
        //     return CustomToastWidget(msg: msg, alignment: alignment);
        //   },
        //   loadingBuilder: (String msg, Color background) {
        //     return CustomLoadingWidget(msg: msg, background: background);
        //   },
        // ),
        // home: MainView()
    );
  }
}
