import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/lyric.dart';
import 'package:weapon/play/lyric_view.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/lyric_util.dart';

class PlayState {
  // String? playId;
  // String? picUrl;
  // String? name;
  // String? artist;
  late AudioSource source;

  late HistoryPo currentPo = HistoryPo();

  PlayerState? playerState;
  AnimationController? lyricOffsetYController;
  Timer? dragEndTimer;
  late Function dragEndFunc;
  late Duration dragEndDuration = const Duration(milliseconds: 1000);
  LyricView? lyricWidget;
  // List<Lyric> lyrics = [];
  late StreamController<String> curPositionController;
  late Stream<String> curPositionStream;
  late Duration duration = const Duration();
  late Duration position = const Duration();
  bool isSaved = false;

  String get sourceStr => source.toString().split(".").last;

  AnimationController? animationController;
  Animation<double>? animation;

  PlayState() {
    duration = const Duration();
    position = const Duration();
    source = AudioSource.netease;
    dragEndDuration = const Duration(milliseconds: 1000);
    curPositionController = StreamController<String>.broadcast();
    curPositionStream = curPositionController.stream;
  }
}
