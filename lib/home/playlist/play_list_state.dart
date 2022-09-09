import 'package:flutter/material.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';

class PlayListState {

  PlayListItemModel? playListItem;

  List<SongListItem> songs = [];
  int selectedIndex = -1;


  List<PlayListItemModel> playList = [];

  int offset = 0;

  ScrollController scrollController = ScrollController();
  bool haveMore = true;
}