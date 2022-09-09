import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:weapon/net/base_music_util.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/net/netease_encrypt_util.dart';
import 'package:weapon/search/search_state.dart';

class NeteaseMusicRequest extends BaseMusicUtil {
  NeteaseMusicRequest() : super.source(AudioSource.netease) {
    dio.options = BaseOptions(headers: header);
  }

  @override
  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 30, int type = 1, int page = 0}) async {
    RequestOptions options = RequestOptions(
        path: "http://music.163.com/weapi/cloudsearch/pc", method: "post");
    Map queryData = {
      's': keyword,
      /** type类型的不同，搜索的类型不同
          type=1         单曲
          type=10        专辑
          type=100       歌手
          type=1000      歌单
          type=1002      用户
          type=1004      MV
          type=1006      歌词
          type=1009      主播电台
       */
      'type': type,
      'limit': limit,
      'total': 'true',
      'offset': page // 分页
    };
    options.queryParameters =
        await NeteaseEncryptUtil.aesEncrypt(json.encode(queryData));
    var result = await dio.fetch(options);
    print(result.data);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      if (data["result"]["songs"] != null && data["result"]["songs"] is List) {
        data["result"]["songs"].forEach((song) {
          songs.add(formatSong(song));
        });
      }
    }
    return songs;
  }

  Map<String, dynamic> formatSong(song) {
    String picId = "";
    String album = "";
    if (song['al']?['pic_str'] != null) {
      picId = song['al']?['pic_str'].toString() ?? "";
    }
    if (picId.isEmpty) {
      picId = song['al']?['pic'].toString() ?? "";
    }
    if (picId.isEmpty) {
      picId =
          song['al']?['picUrl'].toString().split("/").last.split(".").first ??
              "";
    }

    if (song['al'] != null) {
      album = song['al']?['name'] ?? "";
    }

    List<Map<String, dynamic>> artist = [];
    if (song['ar'] != null && song['ar'] is List) {
      song['ar'].forEach((el) {
        artist.add({"name": el["name"], "id": el["id"]});
      });
    }
    return {
      'id': song['id'],
      'name': song['name'],
      'artist': artist,
      'album': album,
      'pic_id': picId,
      'pic_url': picUrl(picId),
      'url_id': song['id'],
      'lyric_id': song['id'],
      'dt': (song['dt'] ?? 0) / 1000,
      'source': 'netease',
    };
  }

  @override
  Future<void> song(String id) async {
    String path =
        "http://music.163.com/api/v3/song/detail?id=$id&c=[{%22id%22:%22$id%22}]";
    var result = await dio.get(path);
    print("song:" + result.data);
  }

  Future<void> album(String id, {int limit = 1000}) async {
    Map params = {
      'total': 'true',
      'offset': '0',
      'id': id,
      'limit': '$limit',
      'ext': 'true',
      'private_cloud': 'true',
    };
    String path = "http://music.163.com/weapi/v1/album/$id";
    RequestOptions options = RequestOptions(path: path, method: "post");
    options.queryParameters =
        await NeteaseEncryptUtil.aesEncrypt(json.encode(params));
    var result = await dio.fetch(options);
    print(result.data);
  }

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
    Map params = {
      // 's': '0',
      'id': id,
      "limit": "1000",
      'n': '1000',
      "total": "true",
      'offset': '0',
      // 't': '0',
    };
    String path = "http://music.163.com/weapi/v6/playlist/detail";
    var map = await NeteaseEncryptUtil.aesEncrypt(json.encode(params));
    var result = await dio.post(path, queryParameters: map);
    var data = json.decode(result.data);
    // print(data["playlist"]["tracks"].length);
    if (data["playlist"]["tracks"] != null &&
        data["playlist"]["tracks"] is List) {
      return (data["playlist"]["tracks"] as List).map((item) {
        return formatSong(item);
      }).toList();
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> url(String id, {int br = 320}) async {
    String path = "http://music.163.com/api/song/enhance/player/url?" +
        id +
        "&ids=[" +
        id +
        "]&br=3200000";
    RequestOptions options = RequestOptions(path: path, method: "get");
    Response result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      if (data?['data']?[0]?["uf"]?['url'] != null) {
        data?['data']?[0]?['url'] = data?['data']?[0]?["uf"]?['url'];
      }
      if (data?['data']?[0]?['url'] != null) {
        return {
          "url": data?['data']?[0]?['url'],
          'size': data?['data']?[0]?['size'],
          'br': data?['data']?[0]?['br'] ?? 0 / 1000,
        };
      }
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> lyric(String id) async {
    Map<String, dynamic> params = {
      'id': id,
      'os': 'linux',
      'lv': -1,
      'kv': -1,
      'tv': -1,
    };
    String path = "http://music.163.com/api/song/lyric";
    RequestOptions options = RequestOptions(path: path, method: "post");
    options.queryParameters = params;
    var result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      return {
        'lyric': data['lrc']?['lyric'] ?? '',
        'tlyric': data['tlyric']?['lyric'] ?? '',
      };
    }
    return null;
  }

  String picUrl(String id, {int size = 300}) {
    return 'https://p3.music.126.net/' +
        NeteaseEncryptUtil.encryptId(id) +
        '/' +
        id +
        '.jpg?param=$size' +
        'y$size';
  }
}
