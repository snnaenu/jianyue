import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weapon/net/base_music_util.dart';
import 'package:weapon/search/search_state.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

/// 参考：https://github.com/jsososo/MiguMusicApi
class MiguMusicRequest extends BaseMusicUtil {
  static String searchApi =
      "https://pd.musicapp.migu.cn/MIGUM2.0/v1.0/content/search_all.do";

  MiguMusicRequest() : super.source(AudioSource.migu);

  @override
  Future<Map<String, dynamic>?> lyric(String id) async {
    // TODO: implement lyric
    var result = await song(id);
    if (result != null) {
      var lrc = await dio.get(result["lrcUrl"]);
      return {
        'lyric': lrc.data,
        'tlyric': '',
      };
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>?> playlist(String id) async {
    var result2 = await dio.get("https://music.migu.cn/v3/music/playlist/$id");
    List<Map<String, dynamic>> songs = [];
    if (result2.data != null) {
      var doc = parse(result2.data);
      doc.getElementsByClassName("J_CopySong").forEach((element) {
        var name = element
            .getElementsByClassName("J_SongName")
            .first
            .getElementsByClassName("song-name-txt")
            .first
            .text;
        var id = element.attributes["data-cid"];

        List<Map<String, dynamic>> artist = [];
        element.getElementsByClassName("J_SongSingers").forEach((element) {
          artist.add({
            'name': element.text,
            'id': element.attributes['href']?.split("/").last ?? "",
          });
        });

        var album = element.getElementsByClassName("song-belongs").first.text;
        var actions = element.getElementsByClassName("song-actions").first;
        var shareData = actions
            .getElementsByClassName("J-btn-share")
            .first
            .attributes["data-share"];
        String imgUrl = "";
        if (shareData != null) {
          var shareMap = json.decode(shareData);
          imgUrl = shareMap["imgUrl"];
        }
        var item = {
          'id': id,
          'name': name,
          'artist': artist,
          'album': album,
          'pic_id': id,
          'pic_url': "https:" + imgUrl,
          'lyric_id': id,
          'dt': 0,
          'source': 'migu',
        };
        songs.add(item);
      });
    }
    return songs;
  }

  @override
  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 10, int type = 1, int page = 1}) async {
    Map<String, dynamic> queryData = {
      'text': keyword,
      'ua': "Android_migu",
      'version': "5.0.1",
      'pageNo': page, // 分页
      'pageSize': limit,
      'searchSwitch':
          "{\"song\":1,\"album\":0,\"singer\":0,\"tagSong\":0,\"mvSong\":0,\"songlist\":0,\"bestShow\":1}"
    };
    var result = await dio.get(searchApi, queryParameters: queryData);
    // print(result.data);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      if (result.data["songResultData"]["result"] != null &&
          result.data["songResultData"]["result"] is List) {
        for (var element in (result.data["songResultData"]["result"] as List)) {
          String pic = "";
          if (element["imgItems"] != null && element["imgItems"] is List) {
            pic = (element["imgItems"] as List).first["img"];
          }

          songs.add({
            'id': element["copyrightId"],
            'name': element["name"],
            'artist': element["singers"],
            'album': element["albums"] != null
                ? (element["albums"] as List).first["name"]
                : "",
            'pic_id': element["copyrightId"],
            'pic_url': pic,
            'lyric_id': element["copyrightId"],
            'dt': 0,
            'source': 'migu',
          });
        }
      }
    }
    return songs;
  }

  @override
  Future<Map<String, dynamic>?> song(String id) async {
    var result = await dio.get(
        "https://c.musicapp.migu.cn/MIGUM2.0/v1.0/content/resourceinfo.do?copyrightId=$id&resourceType=2");
    if (result.data["resource"] != null && result.data["resource"] is List) {
      var data = result.data["resource"][0];
      Map<String, dynamic> typeMap = {
        'PQ': '128',
        'HQ': '320',
        'LQ': 'flac',
      };
      Map<String, dynamic> row = {
        "picUrl": data["albumImgs"][0]["img"],
        "id": data["songId"],
        "name": data["songName"],
        "artists": data["artists"],
        "lrcUrl": data['lrcUrl']
      };
      if (data["rateFormats"] != null && data["rateFormats"] is List) {
        for (var element in (data["rateFormats"] as List)) {
          var last = "https://freetyst.nf.migu.cn/public/" +
              element["url"].toString().split("/public/").last;
          row[typeMap[element["formatType"]]] = {
            'url': last,
            'size': element["size"],
          };
        }
      }
      return row;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> url(String id, {int br = 320}) async {
    Map<String, dynamic>? result = await song(id);
    return result?['$br'];
  }
}
