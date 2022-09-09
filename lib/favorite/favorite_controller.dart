import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/db/history_dao.dart';
import 'package:weapon/db/local_db.dart';
import 'package:weapon/favorite/favorite_state.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/leancloud_util.dart';

class FavoriteController extends GetxController {
  FavoriteState state = FavoriteState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchData();
  }


  fetchData() async {
    // List<LCObject> results =
    //     await LeanCloudUtil.query(LeanCloudUtil.historyCN, 10);
    // List<HistoryPo> histories = [];
    // // for (LCObject element in results) {
    // //   HistoryPo historyPo = HistoryPo.parse(element);
    // //   histories.add(historyPo);
    // // }

    List<HistoryPo> histories = [];
    List<Map<String, dynamic>> result = await LocalDb.instance.historyDao.queryAll();
    // print(result);
    for (var json in result) {
      var historyPo = HistoryPo.fromHistoryJson(json);
      histories.add(historyPo);
    }
    state.histories = histories;
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.histories, index);
  }

  Future<void> loadMore() async {
    
  }

  Future<void> loadRefresh() async {
    fetchData();
  }
}
