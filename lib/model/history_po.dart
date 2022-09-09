import 'dart:convert';

import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/db/local_db.dart';
import 'package:weapon/model/lyric.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/enum_util.dart';
import 'package:weapon/utils/leancloud_util.dart';
import 'package:weapon/utils/lyric_util.dart';

class HistoryPo {
  // String playUrl = "";
  String playId = "";

  List<ArtistModel> artist = [];
  String artistStr = "";

  String source = "";

  String picUrl = "";
  String picId = "";

  String name = "";
  int id = 0;
  int duration = 0;
  String durationStr = "";

  String lyricUrl = "";
  String lyricId = "";
  List<Lyric> lyrics = [];

  AudioSource sourceType = AudioSource.netease;

  HistoryPo();

  HistoryPo.fromSearchJson(Map<String, dynamic> json) {
    playId = json['id']?.toString() ?? "";
    name = json['name']?.toString() ?? "";
    if (name.contains("&nbsp;")) {
      name = name.replaceAll(RegExp(r'&nbsp;'), " ");
    }

    if (json['artist'] != null) {
      final v = json['artist'];
      final arr0 = <ArtistModel>[];
      v.forEach((e) {
        if (e is Map<String, dynamic>) {
          arr0.add(ArtistModel.fromJson(e));
        } else {
          if (e.contains("nbsp;")) {
            e = e.replaceAll(RegExp(r'nbsp;'), "");
          }
          // arr1.add(e);
        }
      });
      artist = arr0;
      artistStr = arr0.map((e) => e.name).toList().join(",");
      // print("artist = $v; artistStr = $artistStr");
    }
    picId = json['pic_id']?.toString() ?? "";
    picUrl = json['pic_url']?.toString() ?? "";
    lyricId = json['lyric_id']?.toString() ?? "";
    source = json['source']?.toString() ?? "";
    sourceType =
        EnumUtil.enumFromString<AudioSource>(AudioSource.values, source);
    if (json["dt"] != null) {
      duration = json["dt"].toInt();
    }
  }

  HistoryPo.fromKugouRankJson(Map<String, dynamic> json) {
    SongRankModel rank = SongRankModel.fromJson(json);
    playId = rank.hash ?? "";
    sourceType = AudioSource.kugou;
    source = "kugou";
    lyricId = playId;
    name = rank.songName;
    artistStr = rank.singer;
    duration = rank.duration ?? 0;
    picUrl = rank.albumSizableCover ?? "";
  }


  HistoryPo.fromHistoryJson(Map<String, dynamic> jsonMap) {
    playId = jsonMap['play_id']?.toString() ?? "";
    artistStr = jsonMap['artist']?.toString() ?? "";
    source = jsonMap['source']?.toString() ?? "";
    sourceType =
        EnumUtil.enumFromString<AudioSource>(AudioSource.values, source);
    picUrl = jsonMap['pic_url']?.toString() ?? "";
    picId = jsonMap['pic_id']?.toString() ?? "";
    lyricId = jsonMap['lyric_id']?.toString() ?? "";
    lyricUrl = jsonMap['lyric_url']?.toString() ?? "";
    name = jsonMap['name']?.toString() ?? "";
    if (jsonMap["dt"] != null) {
      duration = jsonMap["dt"].toInt();
    }
    if (jsonMap['lyrics'] != null && (jsonMap['lyrics'] is List) && (jsonMap['lyrics'].cast<List>()).isNotEmpty) {
      String lyricsJson = jsonMap['lyrics']?.toString() ?? "";
      List<Map<String, dynamic>> decode = json.decode(lyricsJson);
      lyrics = decode.map((e) => Lyric.fromJson(e)).toList();
    }
  }

  Future<void> saveData() async {
    // LCObject lcObject = LCObject(LeanCloudUtil.historyCN);
    // lcObject["playUrl"] = playUrl;
    // lcObject["playId"] = playId;
    // List<Map<String, dynamic>> artistMaps = [];
    // for (var element in artist) {
    //   artistMaps.add(element.toJson());
    // }
    // lcObject["artist"] = jsonEncode(artistMaps);
    // lcObject["source"] = source;
    // lcObject["picUrl"] = picUrl;
    // lcObject["lyricUrl"] = lyricUrl;
    // lcObject["picId"] = picId;
    // lcObject["lyricId"] = lyricId;
    // lcObject["name"] = name;
    // lcObject["size"] = size;
    // lcObject["dt"] = dt;
    //
    // var findOneMusic = await LeanCloudUtil.findOneMusic(playId, source);
    // if (findOneMusic.isEmpty) {
    //   await lcObject.save();
    // } else {
    //   print("$playId:$name已经存在了");
    // }

    LocalDb.instance.historyDao.insert(this);
  }
}
