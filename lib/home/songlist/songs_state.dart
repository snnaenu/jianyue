import 'package:flutter/material.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/rank_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';


enum SongSourceType { playList, rankList }

class SongsState {

  PlayListItemModel? playListItem;
  RankListItemModel? rankListItem;

  List<HistoryPo> songs = [];
  int selectedIndex = -1;

  int offset = 0;

  ScrollController scrollController = ScrollController();
  bool haveMore = true;

  late SongSourceType sourceType;
}