import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:weapon/model/history_po.dart';

class HistoryDao {
  final Database db;
  static String tableName = "history";

  HistoryDao(this.db);

  Future<int> insert(HistoryPo history) async {
    List<Map> lyricsMap = history.lyrics.map((e) => e.toJson()).toList();
    var lyricsJson = json.encode(lyricsMap);
    //插入方法
    String addSql = //插入数据
        "INSERT INTO "
        "history(play_id,artist,source,pic_url,lyric_url,pic_id,lyric_id,lyrics,name,dt) "
        "VALUES (?,?,?,?,?,?,?,?,?,?);";
    return await db.transaction((tran) async => await tran.rawInsert(addSql, [
          history.playId,
          history.artistStr,
          history.source,
          history.picUrl,
          history.lyricUrl,
          history.picId,
          history.lyricId,
          lyricsJson,
          history.name,
          history.duration
        ]));
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    return await db.rawQuery("SELECT * "
        "FROM history");
  }

  //根据 id 查询组件 node
  Future<List<Map<String, dynamic>>> queryById(int id) async {
    return await db.rawQuery(
        "SELECT play_url,artist,source,pic_url,lyric_url"
        "FROM history "
        "WHERE id = ? ORDER BY priority",
        [id]);
  }

  //根据 playId 查询组件 node
  Future<List<Map<String, dynamic>>> queryByPlayId(String playId) async {
    return await db.rawQuery(
        "SELECT *"
        "FROM history "
        "WHERE play_id = ?",
        [playId]);
  }

  Future<int> deletePlayId(String playId) async {
    return await db
        .rawDelete('DELETE FROM $tableName WHERE play_id = ?', [playId]);
  }
}
