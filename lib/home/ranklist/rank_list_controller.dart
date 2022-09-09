import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/ranklist/rank_list_state.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/rank_list_item_model.dart';

class RankListController extends GetxController {
  RankListState state = RankListState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    // fetchList();
  }

  fetchList() async {
    final response = await Dio().get(Api.rankList);
    String sst =
        response.toString().replaceAll(RegExp(r'<!--KG_TAG_RES_START-->'), "");
    sst = sst.replaceAll(RegExp(r'<!--KG_TAG_RES_END-->'), "");
    Map<String, dynamic> data = jsonDecode(sst);
    List dataList = data["data"]["info"];
    List<RankListItemModel> rankList =
        dataList.map((e) => RankListItemModel.fromJson(e)).toList();
    state.rankList = rankList;
    update();
  }

  Future<void> loadRefresh() async{
    fetchList();
  }
}
