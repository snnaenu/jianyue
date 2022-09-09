import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:weapon/play/play_view.dart';

class AudioPlayerUtil {
  // factory AudioPlayerUtil() => _singleton;
  //
  // static AudioPlayerUtil get instance => AudioPlayerUtil();
  // static final AudioPlayerUtil _singleton = AudioPlayerUtil._();
  //
  // late PlayerMode mode;
  // late AudioPlayer audioPlayer;
  //
  // late StreamSubscription durationSubscription;
  // late StreamSubscription positionSubscription;
  // late StreamSubscription playerCompleteSubscription;
  // late StreamSubscription playerErrorSubscription;
  // late StreamSubscription playerStateSubscription;
  //
  // PlayerState get playerState => audioPlayer.state;

  // late PlayView playView;

  // AudioPlayerUtil._() {
  //   // mode = PlayerMode.MEDIA_PLAYER;
  //   // audioPlayer = AudioPlayer(mode: mode);
  //   // playView = PlayView();
  //
  //   durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
  //     print("duration = $duration");
  //     // this.duration = duration;
  //   });
  //
  //   //监听进度
  //   positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
  //     print(p);
  //     // position = p;
  //   });
  //
  //   //播放完成
  //   playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen((event) {
  //     // position = const Duration();
  //   });
  //
  //   //监听报错
  //   playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
  //     print('audioPlayer error : $msg');
  //     // duration = const Duration(seconds: 0);
  //     // position = const Duration(seconds: 0);
  //   });
  //
  //   //播放状态改变
  //   playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
  //     // playerState = state;
  //     // if (!mounted) return;
  //     // setState(() {});
  //   });
  //
  //   ///// iOS中来自通知区域的玩家状态变化流。
  //   audioPlayer.onNotificationPlayerStateChanged.listen((state) {
  //     // if (!mounted) return;
  //   });
  // }
  //
  // Future<void> play(String url, Duration? position) async {
  //   if (url.isEmpty) {
  //     print("url 为空");
  //     return;
  //   }
  //   if (audioPlayer.state == PlayerState.PLAYING) {
  //     final result = await audioPlayer.pause();
  //     if (result == 1) {
  //       print('pause succes');
  //     }
  //     return;
  //   }
  //   final result =
  //       await audioPlayer.play(url, position: position ?? const Duration());
  //   if (result == 1) {
  //     print('play succes');
  //   }
  // }
  //
  // void seek(Duration duration) {
  //   audioPlayer.seek(duration);
  // }
}
