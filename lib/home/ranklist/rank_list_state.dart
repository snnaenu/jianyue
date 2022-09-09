import 'package:flutter/material.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/rank_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';

class RankListState {

  PlayListItemModel? playListItem;

  List<SongListItem> songs = [];
  int selectedIndex = -1;


  List<RankListItemModel> rankList = [];

  int offset = 0;

  ScrollController scrollController = ScrollController();
}