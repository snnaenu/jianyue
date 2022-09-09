import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

class AuthUtil {
  static String secretId = "";
  static String secretKey = "";

  static String sign(String s, String k) {
    var key = utf8.encode(k);
    var bytes = utf8.encode(s);
    Hmac hmac = Hmac(sha1, key);
    Digest sha1Result = hmac.convert(bytes);
    var signStr = base64Encode(sha1Result.bytes);
    return signStr;
  }

  static Map<String, dynamic> getHeader(String host) {
    DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    String timestamp = format.format(DateTime.now());
    String srcStr =
        "date: " + timestamp + "\n" + "source: " + "xxxxxx"; //签名水印值，可填写任意值
    String signStr = sign(srcStr, secretKey);
    String authen = 'hmac id="$secretId", algorithm="hmac-sha1", headers="date source", signature="$signStr"';
    return {
      'Host': "service-1neqmc80-1257701204.gz.apigw.tencentcs.com", // 用户 API 所在服务的域名
      'Accept': '*/*',
      'Source': 'xxxxxx',
      'Date': timestamp,
      'Authorization': authen,
      // 'X-Requested-With': 'XMLHttpRequest',
    };
  }
}