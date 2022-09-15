import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/songlist/songs_state.dart';
import 'package:weapon/home/songlist/songs_view.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/auth_util.dart';

class SongsController extends GetxController {
  SongsState state = SongsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    switch (state.sourceType) {
      case SongListSourceType.playList:
        loadData();
        break;
      case SongListSourceType.rankList:
        state.offset = 0;
        loadDataFromRank();
        break;
    }
  }

  void addScrollListener() {
    //监听滚动条的滚动事件
    state.scrollController.addListener(() {
      if (state.scrollController.position.pixels ==
          state.scrollController.position.maxScrollExtent) {
        if (state.haveMore) {
          state.offset++;
          loadDataFromRank();
        }
      }
    });
  }

  loadData() async {
    var id = state.playListItem?.id;
    if (id == null) return;
    // var dio = Dio();
    // String host = Api.playlist;
    // Map<String, dynamic> header = AuthUtil.getHeader(host);
    // dio.options.headers = header;
    // Map<String, dynamic> param = {
    //   "playlist_id": id,
    //   "source": "netease",
    //   "type": "playlist"
    // };
    // // print("param = $param");
    // final response = await dio.get(host, queryParameters: param);
    // List<dynamic> mapList = jsonDecode(response.toString());
    // // print("response.toString() = ${response.toString()}");
    // List<HistoryPo> songs =
    //     mapList.map((e) => HistoryPo.fromSearchJson(e)).toList();

    AudioSource source = state.audioSource ?? AudioSource.netease;
    List<Map<String, dynamic>>? playlist =
        await NetUtil.playlist(id.toString(), source);
    if (playlist != null) {
      List<HistoryPo> songs =
          playlist.map((e) => HistoryPo.fromSearchJson(e)).toList();
      state.songs = songs;
    }

    update();
  }

  loadDataFromRank() async {
    var ranktype = state.rankListItem?.ranktype;
    var rankid = state.rankListItem?.rankid;
    var dio = Dio();
    String host = Api.rankSongsList;
    Map<String, dynamic> param = {
      "ranktype": ranktype,
      "rankid": rankid,
      "page": 0,
      "pagesize": 1000
    };
    print("param = $param");
    final response = await dio.get(host, queryParameters: param);
    String sst =
        response.toString().replaceAll(RegExp(r'<!--KG_TAG_RES_START-->'), "");
    sst = sst.replaceAll(RegExp(r'<!--KG_TAG_RES_END-->'), "");
    Map<String, dynamic> data = jsonDecode(sst);
    List dataList = data["data"]["info"];
    List<HistoryPo> ranks =
        dataList.map((e) => HistoryPo.fromKugouRankJson(e)).toList();
    state.haveMore = dataList.length >= 20;
    if (state.offset == 0) {
      state.songs = ranks;
    } else {
      state.songs.addAll(ranks);
    }
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.songs, index);
    update();
  }

  chooseRankSong(SongRankModel item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.songs, index);
    update();
  }

  Future<void> loadRefresh(SongListSourceType sourceType) async {
    switch (sourceType) {
      case SongListSourceType.playList:
        loadData();
        break;
      case SongListSourceType.rankList:
        state.offset = 0;
        loadDataFromRank();
        break;
    }
  }
}
