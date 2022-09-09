class SongListItem {
  String id = "";
  String name = "";
  List<ArtistModel> artist = [];
  List<String> artistStrArr = [];
  String album = "";
  String picId = "";
  String picUrl = "";
  String urlId = "";
  String lyricId = "";
  String source = "";
  int dt = 0;
  dynamic lyric;

  SongListItem({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    required this.picId,
    required this.picUrl,
    required this.urlId,
    required this.lyricId,
    required this.source,
  });

  SongListItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? "";
    name = json['name']?.toString() ?? "";
    if (name.contains("&nbsp;")) {
      name = name.replaceAll(RegExp(r'&nbsp;'), " ");
    }

    if (json['artist'] != null) {
      final v = json['artist'];
      final arr0 = <ArtistModel>[];
      final arr1 = <String>[];
      v.forEach((e) {
        if (e is Map<String, dynamic>) {
          arr0.add(ArtistModel.fromJson(e));
        }else{
          if (e.contains("nbsp;")) {
            e = e.replaceAll(RegExp(r'nbsp;'), "");
          }
          arr1.add(e);
        }
      });
      artist = arr0;
      artistStrArr = arr1;
    }
    album = json['album']?.toString() ?? "";
    picId = json['pic_id']?.toString() ?? "";
    picUrl = json['pic_url']?.toString() ?? "";
    urlId = json['url_id']?.toString() ?? "";
    lyricId = json['lyric_id']?.toString() ?? "";
    source = json['source']?.toString() ?? "";
    if (json["dt"] != null) {
      dt = json["dt"].toInt();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (artist != null) {
      final v = artist;
      final arr0 = [];
      v.forEach((v) {
        arr0.add(v);
      });
      data['artist'] = arr0;
    }
    data['album'] = album;
    data['pic_id'] = picId;
    data['url_id'] = urlId;
    data['lyric_id'] = lyricId;
    data['source'] = source;
    return data;
  }
}

class ArtistModel {
  String name = "";
  String id = "";

  ArtistModel.fromJson(Map<String, dynamic> json){
    id = json['id']?.toString() ?? "";
    name = json['name']?.toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
