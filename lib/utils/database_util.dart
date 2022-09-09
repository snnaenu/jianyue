import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weapon/db/local_db.dart';
import 'package:weapon/db/local_storage.dart';
import 'package:sqflite_common/sqlite_api.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DataBaseUtil {

  static initDB() async {
    SharedPreferences prefs = await LocalStorage.sp;
    if (!kIsWeb) {
      //数据库不存在，执行拷贝
      String databasesPath = await getDatabasesPath();
      String dbPath = path.join(databasesPath, "music.db");

      bool shouldCopy = await _checkShouldCopy(dbPath);

      if (shouldCopy) {
        await _doCopyAssetsDb(dbPath);
      } else {
        print("=====flutter.db 已存在====");
      }
    }

    await LocalDb.instance.initDb();
  }

  static Future<bool> _checkShouldCopy(String dbPath) async {
    bool shouldCopy = false;
    String versionStr = await rootBundle.loadString('assets/version.json');
    int dbVersion = await json.decode(versionStr)['dbVersion'];
    int versionInSP =
        await LocalStorage.getInt(LocalStorage.dbVersionKey) ?? -1;

    // 版本升级，执行拷贝
    if (dbVersion > versionInSP) {
      shouldCopy = true;
      await LocalStorage.saveInt(LocalStorage.dbVersionKey, dbVersion);
    }

    //非 release模式，执行拷贝
    // const isPro = bool.fromEnvironment('dart.vm.product');
    // if (!isPro) {
    //   shouldCopy = true;
    // }

    //数据库不存在，执行拷贝
    if (!File(dbPath).existsSync()) {
      shouldCopy = true;
    }

    return shouldCopy;
  }

  static Future<void> _doCopyAssetsDb(String dbPath) async {
    Directory dir = Directory(path.dirname(dbPath));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    ByteData data = await rootBundle.load("assets/music.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes, flush: true);

    print("=====flutter.db==== assets ======拷贝完成====");
  }
}
