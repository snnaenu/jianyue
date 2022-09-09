import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/config/route_config.dart';
import 'package:weapon/home/home_state.dart';
import 'package:weapon/home/songlist/songs_view.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/leancloud_util.dart';

class HomeController extends GetxController {
  HomeState state = HomeState();


  @override
  void onReady(){
    fetchPlayList();
    fetchTopSongs();
  }

  fetchTopSongs() async {
    var dio = Dio();
    final response = await dio.get(Api.top500);
    String sst =
        response.toString().replaceAll(RegExp(r'<!--KG_TAG_RES_START-->'), "");
    sst = sst.replaceAll(RegExp(r'<!--KG_TAG_RES_END-->'), "");
    Map<String, dynamic> data = jsonDecode(sst);
    List dataList = data["data"]["info"];
    List<HistoryPo> ranks =
        dataList.map((e) => HistoryPo.fromKugouRankJson(e)).toList();
    state.ranks = ranks;
    update();
  }

  fetchPlayList() async {
    var dio = Dio();
    final response =
        await dio.get(Api.neteasePlayList, queryParameters: {"offset": 0});
    Map<String, dynamic> data = jsonDecode(response.toString());
    List dataList = data["rows"];
    var playList = dataList.map((e) => PlayListItemModel.fromJson(e)).toList();
    state.playList = playList;
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedItem = item;
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.ranks, index);
    update();
  }

  startSearch() {
    Get.find<MainController>().switchTap(1);
  }

  morePlayList(int index) {
    PlayListItemModel playListItem = state.playList[index];
  }
}
