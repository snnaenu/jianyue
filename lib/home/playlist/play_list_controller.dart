import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/playlist/play_list_state.dart';
import 'package:weapon/model/play_list_item_model.dart';

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

  Future<void> loadRefresh() async {
    state.offset = 0;
    var playList = await fetchPlayList();
    state.playList = playList;
    update();
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
