import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/home_state.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/leancloud_util.dart';

class SearchController extends GetxController {
  SearchState state = SearchState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _updateSubRouteMenuItems();
  }

  void _updateSubRouteMenuItems() {
    state.subRouteNameMenuItems = state.sources
        .map<DropdownMenuItem<String>>((Map<String, dynamic> route) {
      return DropdownMenuItem(
        value: route["name"],
        onTap: () {
          state.audioSource = route["source"];
          update();
        },
        child: Container(
          // width: double.infinity,
          // height: double.infinity,
          // color: Colors.white,
          child: Text(
            route["name"],
            style: TextStyle(
              color: const Color(0xFF333333),
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }).toList();
  }

  search() async {
    String text = state.searchBarController.value.text;
    if (text.contains("http")){
      searchFromPlayList();
    }else{
      searchFromSong();
    }
  }

  searchFromSong() async{
    String text = state.searchBarController.value.text;
    // print(text);
    if (text.isEmpty) return;
    // var dio = Dio();
    // String host = Api.search;
    // Map<String, dynamic> header = AuthUtil.getHeader(host);
    // dio.options.headers = header;
    // Map<String, dynamic> param = {
    //   "word": text,
    //   "type": "search",
    //   "source": state.audioSource.toString().split(".").last
    // };
    // final response = await dio.get(host, queryParameters: param);
    // List<dynamic> mapList = jsonDecode(response.toString());

    var result = await NetUtil.search(text, state.audioSource);
    if (result != null) {
      List<HistoryPo> songs = [];
      for (var element in result) {
        songs.add(HistoryPo.fromSearchJson(element));
      }
      state.songs = songs;
      state.selectedIndex = -1;
      update();
    }
  }

  searchFromPlayList() async {
    String text = state.searchBarController.value.text;
    if (!text.contains("http")) return;
    var id = "";
    switch (state.audioSource) {
      case AudioSource.netease:

        /// https://music.163.com/#/playlist?id=2335673654
        id = text.split("playlist?id=").last.toString();
        id = "486899256";
        break;
      case AudioSource.tencent:

        /// https://y.qq.com/n/ryqq/playlist/8323382601
        id = text.split("playlist/").last.toString();
        break;
      case AudioSource.kugou:

        /// https://www.kugou.com/yy/special/single/4104096.html
        id = text
            .split("special/single/")
            .last
            .toString()
            .split(".html")
            .first
            .toString();
        break;
      case AudioSource.kuwo:

        /// http://www.kuwo.cn/playlist_detail/3120880453
        id = text.split("playlist_detail/").last.toString();
        break;
      default:
        break;
    }

    String source = state.audioSource.toString().split(".").last;
    var dio = Dio();
    String host = Api.playlist;
    Map<String, dynamic> header = AuthUtil.getHeader(host);
    dio.options.headers = header;
    Map<String, dynamic> param = {
      "playlist_id": id,
      "source": source,
      "type": "playlist"
    };
    // print("param = $param");
    final response = await dio.get(host, queryParameters: param);
    // print("response = $response");
    List<dynamic> mapList = jsonDecode(response.toString());
    List<HistoryPo> songs =
        mapList.map((e) => HistoryPo.fromSearchJson(e)).toList();
    state.songs = songs;
    state.selectedIndex = -1;
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.songs, index);
    update();
  }

  startSearch() {
    Get.find<MainController>().switchTap(1);
  }

  menuChanged(text) {
    state.selectedName = text;
    update();
  }
}
