import 'package:dio/dio.dart';
import 'package:weapon/utils/crypt_util.dart';

class NeteaseCloudMusicRequest {
  List userAgentList = [
    // macOS 10.15.6  Firefox / Chrome / Safari
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:80.0) Gecko/20100101 Firefox/80.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.30 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Safari/605.1.15',
    // Windows 10 Firefox / Chrome / Edge
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.30 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/13.10586',
  ];

  Map contentType = {
    'Content-Type': "application/x-www-form-urlencoded",
    "Referer": "https://music.163.com"
  };

  request() {
    RequestOptions options =
        RequestOptions(method: "POST", path: 'https://music.163.com/api/login');
    options.contentType = "application/x-www-form-urlencoded";
    options.headers = {
      "User-Agent": userAgentList,
      "Referer": "https://music.163.com",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    String pwd =  "";

    options.data = {"username":"","password":"","remember_login":true};
    Dio().fetch(options);
  }
}
