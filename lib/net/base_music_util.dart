import 'dart:math';

import 'package:dio/dio.dart';
import 'package:weapon/search/search_state.dart';

abstract class BaseMusicUtil {
  late AudioSource source;
  late Dio dio;
  late Map<String, dynamic> header;

  BaseMusicUtil.source(this.source) {
    dio = Dio();
    header = headerMap();
  }

  Future<List<Map<String, dynamic>>?> search(String keyword,
      {int limit = 30, int type = 1, int page = 1});

  Future<void> song(String id);

  Future<List<Map<String, dynamic>>?> playlist(String id);

  Future<Map<String, dynamic>?> url(String id, {int br = 320});

  Future<Map<String, dynamic>?> lyric(String id);


  headerMap() {
    Map<String, dynamic> headerMap = {};
    switch (source) {
      case AudioSource.netease:
        headerMap = {
          'Referer': 'https://music.163.com/',
          'Cookie':
          'appver=8.2.30; os=iPhone OS; osver=15.0; EVNSM=1.0.0; buildver=2206; channel=distribution; machineid=iPhone13.3',
          'User-Agent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 CloudMusic/0.1.1 NeteaseMusic/8.2.30',
          'X-Real-IP': longToIp(random(1884815360, 1884890111)),
          'Accept': '*/*',
          'Accept-Language': 'zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4',
          'Connection': 'keep-alive',
          'Content-Type': 'application/x-www-form-urlencoded',
        };
        break;
      case AudioSource.tencent:
        headerMap = {
          // 'Referer': 'https://c.y.qq.com',
          // 'Cookie':
          //     'pgv_pvi=22038528; pgv_si=s3156287488; pgv_pvid=5535248600; yplayer_open=1; ts_last=y.qq.com/portal/player.html; ts_uid=4847550686; yq_index=0; qqmusic_fromtag=66; player_exist=1',
          // 'User-Agent':
          //     'QQ%E9%9F%B3%E4%B9%90/54409 CFNetwork/901.1 Darwin/17.6.0 (x86_64)',
          // 'Accept': '*/*',
          // 'Accept-Language': 'zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4',
          // 'Connection': 'keep-alive',
          // 'Content-Type': 'application/x-www-form-urlencoded',
          "Cookie":
          "eas_sid=h1u5a6D7N0u089l4P8g4S1o9N5; pgv_pvi=1399294976; pgv_pvid=3522250322; RK=RaCE+Qw87C; ptcz=645f699f302818f2aa4fb78a5bf7f75fd0d90f1c95db5a5d0acb695283fdc8b7; tvfe_boss_uuid=306cd91a9af78b43; LW_uid=11f5K7a8I9K0K2E7d6G2B4q7P1; LW_sid=K1o518v1X5U1h0o5J6i4x9g0n9; o_cookie=229554158; pac_uid=1_229554158; uin_cookie=o0229554158; ied_qq=o0229554158; ptui_loginuin=2863778213; luin=o0229554158; lskey=00010000161fb2266a89bdbedc615f48e2b88d65a280a1be4207429dee5c429e0fcb7e0da641297e832f0555",
          "User-Agent":
          "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36"
        };
        break;
      case AudioSource.xiami:
        headerMap = {
          'Cookie':
          '_m_h5_tk=15d3402511a022796d88b249f83fb968_1511163656929; _m_h5_tk_enc=b6b3e64d81dae577fc314b5c5692df3c',
          'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) XIAMI-MUSIC/3.1.1 Chrome/56.0.2924.87 Electron/1.6.11 Safari/537.36',
          'Accept': 'application/json',
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept-Language': 'zh-CN',
        };
        break;
      case AudioSource.kugou:
        headerMap = {
          'User-Agent': 'IPhone-8990-searchSong',
          'UNI-UserAgent': 'iOS11.4-Phone8990-1009-0-WiFi',
        };
        break;
      case AudioSource.baidu:
        headerMap = {
          'Cookie': 'BAIDUID=' + 32.toRadixString(16) + ':FG=1',
          'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) baidu-music/1.2.1 Chrome/66.0.3359.181 Electron/3.0.5 Safari/537.36',
          'Accept': '*/*',
          'Content-type': 'application/json;charset=UTF-8',
          'Accept-Language': 'zh-CN',
        };
        break;
      case AudioSource.kuwo:
        headerMap = {
          // 'Cookie':
          //     'Hm_lvt_cdb524f42f0ce19b169a8071123a4797=1657360384; _ga=GA1.2.1532813676.1657360387; gtoken=rOUj73zvRbzq; gid=79f42284-96cb-4085-a200-16f141c5a622; JSESSIONID=1xlfp931ggy6k19y7o634hzolu; reqid=95be0d93X1cb6X4d8cXa443X908bece67905; kw_token=0RLYG6P2RI4',
          // 'csrf': '0RLYG6P2RI4',
          'Host': 'www.kuwo.cn',
          'Referer': 'http://www.kuwo.cn/',
          'Origin': 'http://www.kuwo.cn/',
          'Accept': 'application/json, text/plain, */*',
          'Content-type': 'application/x-www-form-urlencoded',
          "Accept-Language":
          "zh-CN,zh-HK;q=0.8,zh-TW;q=0.6,en-US;q=0.4,en;q=0.2",
          'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36',
          "Accept-Encoding": "gzip, deflate, br",
        };
        break;
      case AudioSource.migu:
        headerMap = {
          'Referer': 'http://music.migu.cn/',
          'Content-type': 'application/x-www-form-urlencoded',
        };
        break;
    }
    return headerMap;
  }

  String longToIp(int iplong) {
    int a1 = iplong >> 24;
    int a2 = iplong << 40 >> 56;
    int a3 = iplong << 48 >> 56;
    int a4 = iplong << 56 >> 56;
    return "$a1.$a2.$a3.$a4";
  }

  random(int min, int max) => min + Random().nextInt(max - min);
}