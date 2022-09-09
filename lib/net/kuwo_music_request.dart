import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:weapon/net/base_music_util.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/net/netease_encrypt_util.dart';
import 'package:weapon/search/search_state.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class KuwoMusicRequest extends BaseMusicUtil {
  KuwoMusicRequest() : super.source(AudioSource.kuwo) {
    dio.options = BaseOptions(headers: header);
  }

  @override
  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 10, int type = 1, int page = 1}) async {
    String path =
        "http://www.kuwo.cn/api/www/search/searchMusicBykeyWord?key=$keyword&pn=1&rn=30&httpsStatus=1";
    await getCsrf(path, keyword: keyword);
    var result = await dio.get(path);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = result.data;
      if (data["data"]?["list"] != null && data["data"]?["list"] is List) {
        return (data["data"]["list"] as List).map((item) {
          return formatJson(item);
        }).toList();
      }
    }
    return songs;
  }

  /// 获取 csrf 后添加到 http header 中
  Future<void> getCsrf(String referer, {String keyword = "hello"}) async {
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));
    await dio.get("http://www.kuwo.cn/search/list?key=$keyword");
    List<Cookie> results = await cj.loadForRequest(
        Uri.parse("http://www.kuwo.cn/search/list?key=$keyword"));
    String kwToken = results.first.value;
    Map<String, dynamic> header = headerMap();
    header['csrf'] = kwToken;
    header['cookie'] = "kw_token=$kwToken";
    header['Referer'] = Uri.parse(referer).toString();
    dio.options = BaseOptions(headers: header);
  }

  Map<String, dynamic> formatJson(item) {
    return {
      'id': item['rid'],
      'name': item['name'],
      'artist': [
        {"name": item['artist'], "id": item['artistid']}
      ],
      'album': item['album'],
      'pic_id': item['rid'],
      'pic_url': item['pic']
          .toString()
          .replaceAll("albumcover/120/", "albumcover/500/"),
      'url_id': item['rid'],
      'lyric_id': item['rid'],
      'dt': item['duration'],
      'source': 'kuwo',
    };
  }

  @override
  Future<Map<String, dynamic>?> song(String id) async {
    String path =
        "http://www.kuwo.cn/api/www/music/musicInfo?mid=$id&httpsStatus=1";
    await getCsrf(path);
    var result = await dio.get(path);
    if (result.statusCode != null && result.statusCode == 200) {
      return result.data;
    }
    return null;
  }

  Future<void> album(String id, {int limit = 1000}) async {}

  Future<void> artist(String id, {int limit = 50}) async {
    // String path =
    //     "http://www.kuwo.cn/api/www/artist/artistMusic?artistid=$id&pn=1&rn=$limit&httpsStatus=1";
    // await getCsrf(path);
    // var result = await dio.get(path);
    // print(json.encode(result.data));
  }

  @override
  Future<List<Map<String, dynamic>>?> playlist(String id) async {
    String path =
        "http://www.kuwo.cn/api/www/playlist/playListInfo?pid=$id&pn=1&rn=1000&httpsStatus=1";
    await getCsrf(path);
    var result = await dio.get(path);
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = result.data;
      if (data["data"]?["musicList"] != null &&
          data["data"]?["musicList"] is List) {
        return (data["data"]["musicList"] as List).map((item) {
          return formatJson(item);
        }).toList();
      }
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> url(String id, {int br = 320}) async {
    String path =
        "http://www.kuwo.cn/api/v1/www/music/playUrl?mid=$id&type=music&httpsStatus=1";
    await getCsrf(path);
    print(path);
    var result = await dio.get(path);
    dynamic data = result.data;
    if (data['code'] == 200 && data['data']['url'] != null) {
      return {
        'url': data['data']['url'],
        // 'br': 128,
      };
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> lyric(String id) async {
    String path =
        "http://m.kuwo.cn/newh5/singles/songinfoandlrc?musicId=$id&httpsStatus=1";
    await getCsrf(path);
    var result = await dio.get(path);
    var data = json.decode(result.data);
    if (data['data']['lrclist'] != null) {
      String lyric = (data['data']['lrclist'] as List)
          .map((e) {
            var otime = e['time'];
            var osec = int.parse(otime.toString().split(".").first);
            var m = (osec / 60).floor();
            var min = m < 10 ? "0$m" : m;
            var s = osec - m * 60;
            var sec = s < 10 ? "0$s" : s;
            var msec = otime.toString().split(".").last;
            var olyric = e['lineLyric'];
            return '[${min.toString()}:${sec.toString()}.${msec.toString()}]' +
                olyric;
          })
          .toList()
          .join("\n");

      return {"lyric": lyric, "tlyric": ""};
    }
    return null;
  }

  Future<String?> picUrl(String id, {int size = 400}) async {
    var result = await song(id);
    if (result != null) {
      return result['imgUrl'].toString().replaceAll("{size}", "$size");
    }
    return null;
  }
}
