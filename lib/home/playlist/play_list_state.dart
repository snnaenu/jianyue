import 'package:flutter/material.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/search/search_state.dart';

class PlayListState {
  // PlayListItemModel? playListItem;

  // List<SongListItem> songs = [];
  int selectedIndex = 0;

  List<Map<String, dynamic>> titleList = [
    {"title": "网易", "type": AudioSource.netease},
    {"title": "酷狗", "type": AudioSource.kugou}
  ];

  List<PlayListItemModel> playList = [];

  int offset = 0;

  ScrollController scrollController = ScrollController();
  bool haveMore = true;
}
