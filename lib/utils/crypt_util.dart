import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:crypt/crypt.dart';

class CryptUtil {
  static String charset = "UTF-8";
  static String secretId = "";
  static String secretKey = "";

  static String getSignString() {
    String timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);

    Map<String, Object> params = {
      "Nonce": Random().nextInt(100000),
      "Timestamp": timestamp,
      "SecretId": secretId,
      "Action": "DescribeInstances",
      "Version": "2017-03-12",
      "Region": "ap-guangzhou",
      "Limit": 20,
      "Offset": 0,
      "InstanceIds.0": "ins-09dx96dg",
    };
    List attrKeys = params.keys.toList();
    attrKeys.sort();
    String ss = getStringToSign(params, attrKeys);
    String signature = sign(ss, secretKey);
    params["Signature"] = signature;
    return getUrl(params);
  }

  static String sign(String s, String k) {
    var key = utf8.encode(k);
    var bytes = utf8.encode(s);
    Hmac hmac = Hmac(sha1, key);
    Digest sha1Result = hmac.convert(bytes);
    var signStr = base64Encode(sha1Result.bytes);
    return signStr;
  }

  static String md5(String s, String k) {
    var key = utf8.encode(k);
    var bytes = utf8.encode(s);
    Hmac hmac = Hmac(sha1, key);
    // Hmac(hash, key);
    return "";
  }

  static String getStringToSign(Map<String, Object> params, List attrKeys) {
    String s2s = "GETcvm.tencentcloudapi.com/?";
    for (var key in attrKeys) {
      s2s += key + "=" + params[key].toString() + "&";
    }
    return s2s.substring(0, s2s.length - 1);
  }

  static String getUrl(Map<String, Object> params) {
    String url = "https://cvm.tencentcloudapi.com/?";
    params.forEach((key, value) {
      url += key + "=" + Uri.encodeComponent(value.toString()) + "&";
    });
    return url.substring(0, url.length - 1);
  }
}
