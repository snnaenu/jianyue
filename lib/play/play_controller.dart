import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/db/local_db.dart';
import 'package:weapon/favorite/favorite_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_detail.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/net/net_util.dart';
import 'package:weapon/play/play_state.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/lyric_util.dart';

import 'lyric_view.dart';

class PlayController extends GetxController {
  PlayState state = PlayState();

  late PlayerMode mode;
  late AudioPlayer audioPlayer;
  late List<HistoryPo> playItems = [];
  late int playIndex = 0;

  bool get isPlaying => state.playerState == PlayerState.PLAYING;

  initState(List<HistoryPo>? histories, int index) async {
    if (histories == null || histories.isEmpty) return;
    playItems = histories;
    playIndex = index;
    HistoryPo historyPo = histories[index];

    if (historyPo.lyrics.isEmpty) {
      // var dio = Dio();
      // Map<String, dynamic> header = AuthUtil.getHeader(Api.lyric);
      // dio.options.headers = header;
      // Map<String, dynamic> lyricParam = {
      //   "lyric_id": historyPo.lyricId,
      //   "source": historyPo.source,
      //   "type": "lyric"
      // };
      // final lyricResponse =
      //     await dio.get(Api.lyric, queryParameters: lyricParam);
      // var lyricMap = jsonDecode(lyricResponse.toString());

      var lyricMap =
          await NetUtil.lyric(historyPo.lyricId, historyPo.sourceType);
      if (lyricMap != null) {
        historyPo.lyrics = LyricUtil.formatLyric(lyricMap["lyric"]);
      }
    }

    state.lyricWidget = LyricView(historyPo.lyrics, 0);
    state.duration = const Duration();
    state.position = const Duration();
    state.currentPo = historyPo;

    state.isSaved = await isSaved();

    play();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initAudioPlayer();
  }

  initAudioPlayer() {
    mode = PlayerMode.LOW_LATENCY;
    audioPlayer = AudioPlayer();
    // audioPlayer.setVolume(1);
    state.playerState = audioPlayer.state;

    audioPlayer.onDurationChanged.listen((duration) {
      state.duration = duration;
      update();
    });

    //监听进度
    audioPlayer.onAudioPositionChanged.listen((position) {
      state.position = position;
      // print("position = ${position.inMilliseconds}");
      update();
    });

    //播放完成
    audioPlayer.onPlayerCompletion.listen((event) {
      state.position = const Duration();
      next();
    });

    //监听报错
    // audioPlayer.onPlayerError.listen((msg) {
    //   state.duration = const Duration(seconds: 0);
    //   state.position = const Duration(seconds: 0);
    //   update();
    // });

    //播放状态改变
    audioPlayer.onPlayerStateChanged.listen((playerState) {
      state.playerState = playerState;
      update();
    });
  }

  stopAndPlay() async {
    if (isPlaying) {
      await audioPlayer.pause();
      state.animationController?.stop();
      return;
    }
    await play();
  }

  play() async {
    String songId = state.currentPo.playId;
    if (songId.isEmpty) return;
    // var dio = Dio();
    // Map<String, dynamic> header = AuthUtil.getHeader(Api.play);
    // Map<String, dynamic> param = {
    //   "id": songId,
    //   "source": state.currentPo.source,
    //   "type": "play"
    // };
    // dio.options.headers = header;
    // final response = await dio.get(Api.play, queryParameters: param);
    // SongDetail detail = SongDetail.fromJson(jsonDecode(response.toString()));

    var urlMap = await NetUtil.url(songId, state.currentPo.sourceType);
    if (urlMap == null) return;
    SongDetail detail = SongDetail.fromJson(urlMap);
    String url = detail.url ?? "";
    if (url.isEmpty) return;
    final playPosition = (state.position.inMilliseconds > 0 &&
            state.position.inMilliseconds < state.duration.inMilliseconds)
        ? state.position
        : const Duration();

    if (url.isEmpty) {
      print("url 为空");
      return;
    }

    var result = await audioPlayer.play(
      Uri.encodeFull(url),
      position: playPosition,
    );
    if (result == 1) {
      state.animationController?.forward();
      print('play succes');
    }
  }

  previous() {
    if (playItems.isNotEmpty && playIndex < playItems.length - 1) {
      initState(playItems, playIndex - 1);
    }
  }

  next() {
    if (playItems.isNotEmpty && playIndex < playItems.length - 1) {
      initState(playItems, playIndex + 1);
    }
  }

  collect() async {
    if (state.currentPo.playId.isEmpty) return;
    var result =
        await LocalDb.instance.historyDao.queryByPlayId(state.currentPo.playId);
    if (result.isNotEmpty) {
      LocalDb.instance.historyDao.deletePlayId(state.currentPo.playId);
    } else {
      LocalDb.instance.historyDao.insert(state.currentPo);
    }
    state.isSaved = await isSaved();

    FavoriteController favoriteController = Get.find<FavoriteController>();
    if (!favoriteController.isClosed) favoriteController.fetchData();

    update();
  }

  seek(Duration duration) {}

  Future<bool> isSaved() async {
    if (state.currentPo.playId.isEmpty) return false;
    var result =
        await LocalDb.instance.historyDao.queryByPlayId(state.currentPo.playId);
    return result.isNotEmpty;
  }

  void initAnimation() {
    // if (state.animationController != null) {
    //   state.animationController.forward();
    // }
  }
}
