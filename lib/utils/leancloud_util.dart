import 'package:leancloud_storage/leancloud.dart';

class LeanCloudUtil {
  static String historyCN = "history";

  static initSDK() {
    LeanCloud.initialize(
        "VRiOjGUNrvxQ6lsNqw3cLQwm-gzGzoHsz", "sAvI4hzaerjzF5JA17tU95IA",
        server: "https://music.nnxkcloud.com", queryCache: LCQueryCache());
  }

  static Future<List<LCObject>> query(String className, int limit) async {
    LCQuery<LCObject> query = LCQuery<LCObject>(className);
    query.limit(limit);
    return await query.find() ?? [];
  }

  static Future<List<LCObject>> findOneMusic(
      String playId, String source) async {
    LCQuery<LCObject> query = LCQuery<LCObject>(LeanCloudUtil.historyCN);
    query.whereEqualTo("playId", playId);
    query.whereEqualTo("source", source);
    return await query.find() ?? [];
  }
}
