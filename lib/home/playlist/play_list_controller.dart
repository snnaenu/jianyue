import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/playlist/play_list_state.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/search/search_state.dart';

class PlayListController extends GetxController {
  PlayListState state = PlayListState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadRefresh();
  }

  loadMore() async {
    state.offset++;
    var playList = await fetchPlayList();
    state.playList.addAll(playList);
    update();
  }

  AudioSource get currentSourceType =>
      state.titleList[state.selectedIndex]["type"];

  Future<void> loadRefresh() async {
    state.offset = 0;
    switch (currentSourceType) {
      case AudioSource.netease:
        var playList = await fetchPlayList();
        state.playList = playList;
        break;
      case AudioSource.kugou:
        var playList = await fetchKugouPlayList();
        state.playList = playList;
        break;
      case AudioSource.kuwo:
        // TODO: Handle this case.
        break;
      case AudioSource.migu:
        // TODO: Handle this case.
        break;
      default:
        break;
    }
    update();
  }

  updateIndex(int index) {
    state.selectedIndex = index;
    loadRefresh();
  }

  Future<List<PlayListItemModel>> fetchKugouPlayList() async {
    final response = await Dio().get(Api.kugouPlayList,
        queryParameters: {"page": state.offset, "pagesize": 100});
    // print(response);
    Map<String, dynamic> data = jsonDecode(response.toString());
    if (data["data"]?["info"] != null && data["data"]?["info"] is List) {
      List dataList = data["data"]["info"];
      List<PlayListItemModel> playList =
          dataList.map((e) => PlayListItemModel.fromKugouJson(e)).toList();
      // if (playList.length < 20) {
      //   state.haveMore = false;
      // }
      return playList;
    }
    return [];
  }

  Future<List<PlayListItemModel>> fetchPlayList() async {
    final response = await Dio().get(Api.neteasePlayList,
        queryParameters: {"offset": state.offset, "limit": 100});
    Map<String, dynamic> data = jsonDecode(response.toString());
    List dataList = data["rows"];
    List<PlayListItemModel> playList =
        dataList.map((e) => PlayListItemModel.fromJson(e)).toList();
    if (playList.length < 20) {
      state.haveMore = false;
    }
    return playList;
  }
}
