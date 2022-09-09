import 'package:flutter/material.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';


enum AudioSource { netease, tencent, xiami, kugou, baidu, kuwo }

class SearchState {
  HistoryPo? selectedItem;
  int selectedIndex = -1;

  List<HistoryPo> histories = [];

  List<PlayListItemModel> playList = [];

  final List<Map<String, dynamic>> sources = [
    {"name": "网易", "source": AudioSource.netease},
    // {"name": "腾讯", "source": AudioSource.tencent},
    // {"name": "小米", "source": AudioSource.xiami},
    {"name": "酷狗", "source": AudioSource.kugou},
    // {"name": "百度", "source": AudioSource.baidu},
    {"name": "酷我", "source": AudioSource.kuwo},
  ];
  List<DropdownMenuItem<String>> subRouteNameMenuItems = [];
  String selectedName = "网易";
  AudioSource audioSource = AudioSource.netease;

  List<HistoryPo> songs = [];

  final TextEditingController searchBarController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

}
