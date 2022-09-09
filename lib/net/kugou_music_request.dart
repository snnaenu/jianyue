import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:weapon/net/base_music_util.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/net/netease_encrypt_util.dart';
import 'package:weapon/search/search_state.dart';

class KugouMusicRequest extends BaseMusicUtil {
  KugouMusicRequest() : super.source(AudioSource.kugou) {
    dio.options = BaseOptions(headers: header);
  }

  @override
  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 10, int type = 1, int page = 1}) async {
    RequestOptions options = RequestOptions(
        path: "http://mobilecdn.kugou.com/api/v3/search/song", method: "get");
    Map<String, dynamic> queryData = {
      'api_ver': 1,
      'area_code': 1,
      'correct': 1,
      'pagesize': limit,
      'plat': 2,
      'tag': 1,
      'sver': 5,
      'showtype': 14,
      'page': page,
      'keyword': keyword,
      'version': 8990,
    };
    options.queryParameters = queryData;
    var result = await dio.fetch(options);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      if (data["data"]?["info"] != null && data["data"]?["info"] is List) {
        return await formatSongs(data["data"]["info"]);
      }
    }
    return songs;
  }

  Future<List<Map<String, dynamic>>> formatSongs(List data) async {
    List<Map<String, dynamic>> items = [];
    for (var map in data) {
      var item = await songFormat(map);
      items.add(item);
    }
    return items;
  }

  Future<Map<String, dynamic>> songFormat(Map map) async {
    String filename = map['filename'] ?? map['fileName'];
    String name = filename.split("-").last.trim();
    String id = map['hash'];
    String pic = "";
    List<Map<String, dynamic>> artist = [];
    var result = await song(id);
    if (result != null) {
      pic = result['imgUrl']?.toString().replaceAll("{size}", "400") ?? "";
      var authors = result["authors"];
      if (authors != null && authors is List && authors.isNotEmpty) {
        for (var element in authors) {
          artist.add(
              {"name": element["author_name"], "id": element["author_id"]});
        }
      } else {
        artist.add({"name": filename.split("-").first.trim(), "id": ""});
      }
    }

    return {
      'id': id,
      'name': name,
      'artist': artist,
      'album': map['album_name'] ?? '',
      'pic_id': id,
      'pic_url': pic,
      'lyric_id': id,
      'dt': map['duration'],
      'source': 'kugou',
    };
  }

  @override
  Future<Map<String, dynamic>?> song(String id) async {
    String path = "http://m.kugou.com/app/i/getSongInfo.php";
    RequestOptions options = RequestOptions(path: path, method: "get");
    options.queryParameters = {
      'cmd': 'playInfo',
      'hash': id,
      'from': 'mkugou',
    };
    var result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      return json.decode(result.data);
    }
    return null;
  }

  Future<void> album(String id, {int limit = 1000}) async {}

  Future<void> artist(String id, {int limit = 50}) async {
    Map<String, dynamic> params = {
      'ext': 'true',
      'private_cloud': 'true',
      'ext': 'true',
      'top': limit,
      'id': id,
    };
    String path = "http://music.163.com/weapi/v1/artist/$id";
    RequestOptions options = RequestOptions(path: path, method: "post");
    options.queryParameters =
        await NeteaseEncryptUtil.aesEncrypt(json.encode(params));
    var result = await dio.fetch(options);
    print(result.data);
  }

  @override
  Future<List<Map<String, dynamic>>?> playlist(String id) async {
    Map<String, dynamic> params = {
      'specialid': id,
      'area_code': 1,
      'page': 1,
      'plat': 2,
      'pagesize': -1,
      'version': 8990,
    };
    String path = "http://mobilecdn.kugou.com/api/v3/special/song";
    RequestOptions options = RequestOptions(path: path, method: "GET");
    options.queryParameters = params;
    var result = await dio.fetch(options);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      return await formatSongs(data["data"]["info"]);
    }
    return songs;
  }

  @override
  Future<Map<String, dynamic>?> url(String id, {int br = 320}) async {
    Map<String, dynamic> params = {
      'relate': 1,
      'userid': '2626431536',
      'vip': 1,
      "token": '',
      'appid': 1001,
      'token': '',
      'behavior': 'play',
      'area_code': '1',
      'clientver': '8990',
      "area_code": '1',
      "need_hash_offset": 1,
      'resource': [
        {
          'id': 0,
          'type': 'audio',
          'hash': id,
        }
      ]
    };
    String path = "http://media.store.kugou.com/v1/get_res_privilege";
    RequestOptions options = RequestOptions(path: path, method: "POST");
    options.data = params;
    Response result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      if (data?['data']?[0]?['relate_goods'] != null) {
        return getUrl(data?['data']?[0]?['relate_goods']);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUrl(List items, {int br = 320}) async {
    double max = 0;
    Map<String, dynamic> map = {};
    for (var item in items) {
      if (item['info']['bitrate'] <= br && item['info']['bitrate'] > max) {
        RequestOptions options = RequestOptions(
            path: "http://trackercdn.kugou.com/i/v2/", method: "GET");
        var digest =
            md5.convert((item['hash'] + 'kgcloudv2').codeUnits).toString();
        options.queryParameters = {
          'hash': item['hash'],
          'key': digest,
          'pid': 3,
          'behavior': 'play',
          'cmd': '25',
          'version': 8990,
        };
        Response lastResult = await dio.fetch(options);
        if (lastResult.statusCode == 200) {
          dynamic lastData = json.decode(lastResult.data);
          if (lastData["url"] != null) {
            max = lastData["bitRate"] / 1000;
            map = {
              'url': lastData['url'].first,
              'size': lastData['fileSize'],
              'br': lastData['bitRate'] / 1000,
            };
          }
        }
      }
    }
    return map;
  }

  @override
  Future<Map<String, dynamic>?> lyric(String id) async {
    Map<String, dynamic> params = {
      'keyword': '%20-%20',
      'ver': 1,
      'hash': id,
      'client': 'mobi',
      'man': 'yes',
    };
    String path = "http://krcs.kugou.com/search";
    RequestOptions options = RequestOptions(path: path, method: "GET");
    options.queryParameters = params;
    var result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      var data = result.data;
      if (result.data is String) {
        data = json.decode(result.data);
      }
      var response = await dio.fetch(RequestOptions(
          path: "http://lyrics.kugou.com/download",
          method: "GET",
          queryParameters: {
            'charset': 'utf8',
            'accesskey': data['candidates'][0]['accesskey'],
            'id': data['candidates'][0]['id'],
            'client': 'mobi',
            'fmt': 'lrc',
            'ver': 1,
          }));
      var responseMap = response.data;
      var lyric = String.fromCharCodes(base64Decode(responseMap["content"]));
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
