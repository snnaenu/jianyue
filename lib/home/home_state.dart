import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_rank_model.dart';

class HomeState {
  HistoryPo? selectedItem;
  int selectedIndex = -1;

  List<HistoryPo> histories = [];

  List<PlayListItemModel> playList = [];

  List<HistoryPo> ranks = [];
}
