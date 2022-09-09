import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/net/netease_encrypt_util.dart';
import 'package:weapon/search/search_state.dart';

import 'base_music_util.dart';

class QQMusicRequest extends BaseMusicUtil {
  QQMusicRequest() : super.source(AudioSource.tencent) {
    dio.options = BaseOptions(headers: header);
  }

  @override
  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 30, int type = 1, int page = 1}) async {
    // RequestOptions options = RequestOptions(
    //     path: "https://c.y.qq.com/soso/fcgi-bin/client_search_cp", method: "GET");
    Map<String, dynamic> queryData = {
      'format'   : 'json',
      // 'p'        : page,
      'n'        : limit,
      'w'        : keyword,
      // 'aggr'     : 1,
      // 'lossless' : 1,
      // 'cr'       : 1,
      // 'new_json' : 1,
      // "outCharset": 'utf-8',
      // "ct": 24,
      // "qqmusic_ver": 1298,
      // // https://github.com/Rain120/qq-music-api/issues/68
      // // new_json: 1,
      // "remoteplace": 'txt.yqq.song',
      // // searchid: 58932895599763136,
      // "t": 0,
      // "aggr": 1,
      // "cr": 1,
      // "lossless": 0,
      // "flag_qc": 0,
      // "platform": 'yqq.json',
    };
    var path = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?w=$keyword&n=limit&format=json&p=$page";
    print(path);
    var result = await dio.get(path);
    List<Map<String, dynamic>> songs = [];
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      print(data);
    }
    return songs;
  }

  Future<void> song(String id) async {
    Map params = {'c': '[{"id":$id,"v":0}]'};
    String path = "http://music.163.com/weapi/v3/song/detail/";
    RequestOptions options = RequestOptions(path: path, method: "post");
    options.queryParameters =
        await NeteaseEncryptUtil.aesEncrypt(json.encode(params));
    var result = await dio.fetch(options);
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
    // Map params = {
    //   's': '0',
    //   'id': id,
    //   'n': '1000',
    //   't': '0',
    // };
    // String path = "http://music.163.com/weapi/v6/playlist/detail";
    // RequestOptions options = RequestOptions(path: path, method: "post");
    // options.queryParameters =
    //     await NeteaseEncryptUtil.aesEncrypt(json.encode(params));
    // var result = await dio.fetch(options);
    // print(result.data);
  }

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

  Future<Map<String, dynamic>?> lyric(String id) async {
    Map<String, dynamic> params = {
      'id': id,
      'os': 'linux',
      'lv': -1,
      'kv': -1,
      'tv': -1,
    };
    String path = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp";
    RequestOptions options = RequestOptions(path: path, method: "post");
    options.queryParameters = params;
    var result = await dio.fetch(options);
    if (result.statusCode != null && result.statusCode == 200) {
      dynamic data = json.decode(result.data);
      return {
        'lyric': data['lrc']['lyric'] ?? '',
        'tlyric': data['tlyric']['lyric'] ?? '',
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
