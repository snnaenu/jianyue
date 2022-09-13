import 'dart:math';

import 'package:dio/dio.dart';
import 'package:weapon/net/base_music_util.dart';
import 'package:weapon/net/kugou_music_request.dart';
import 'package:weapon/net/kuwo_music_request.dart';
import 'package:weapon/net/migu_music_request.dart';
import 'package:weapon/net/netease_music_request.dart';
import 'package:weapon/net/qq_music_request.dart';
import 'package:weapon/search/search_state.dart';

class NetUtil {
  static BaseMusicUtil? getSubInstance(AudioSource source) {
    BaseMusicUtil? instance;
    switch (source) {
      case AudioSource.netease:
        instance = NeteaseMusicRequest();
        break;
      case AudioSource.tencent:
        instance = QQMusicRequest();
        break;
      case AudioSource.xiami:
      case AudioSource.baidu:
        break;
      case AudioSource.kugou:
        instance = KugouMusicRequest();
        break;
      case AudioSource.kuwo:
        instance = KuwoMusicRequest();
        break;
      case AudioSource.migu:
        instance = MiguMusicRequest();
        break;
    }
    return instance;
  }

  static Future<List<Map<String, dynamic>>?>? search(
      String keyword, AudioSource source) {
    return getSubInstance(source)?.search(keyword);
  }

  static Future<List<Map<String, dynamic>>?>? playlist(
      String id, AudioSource source) {
    return getSubInstance(source)?.playlist(id);
  }

  static Future<Map<String, dynamic>?>? url(String id, AudioSource source,
      {int br = 320}) {
    return getSubInstance(source)?.url(id);
  }

  static Future<Map<String, dynamic>?>? lyric(String id, AudioSource source) {
    return getSubInstance(source)?.lyric(id);
  }

  static Future<void>? song(String id, AudioSource source) {
    getSubInstance(source)?.song(id);
  }
}
