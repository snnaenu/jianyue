
class RankListItemModelSonginfo {

  String? author;
  String? name;
  String? songname;

  RankListItemModelSonginfo({
    this.author,
    this.name,
    this.songname,
  });
  RankListItemModelSonginfo.fromJson(Map<String, dynamic> json) {
    author = json['author']?.toString();
    name = json['name']?.toString();
    songname = json['songname']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['author'] = author;
    data['name'] = name;
    data['songname'] = songname;
    return data;
  }
}

class RankListItemModel {

  int? rankCid;
  int? id;
  String? rankname;
  String? jumpUrl;
  String? banner_9;
  int? rankid;
  int? haschildren;
  String? bannerurl;
  String? zone;
  List<RankListItemModelSonginfo?>? songinfo;
  int? isvol;
  // List<RankListItemModelChildren?>? children;
  int? playTimes;
  String? img_9;
  int? customType;
  int? ranktype;
  String? imgCover;
  int? issue;
  String? banner7url;
  int? showPlayButton;
  String? jumpTitle;
  String? updateFrequency;
  int? classify;
  String? albumImg_9;
  String? intro;
  String? imgurl;

  RankListItemModel({
    this.rankCid,
    this.id,
    this.rankname,
    this.jumpUrl,
    this.banner_9,
    this.rankid,
    this.haschildren,
    this.bannerurl,
    this.zone,
    this.songinfo,
    this.isvol,
    // this.children,
    this.playTimes,
    this.img_9,
    this.customType,
    this.ranktype,
    this.imgCover,
    this.issue,
    this.banner7url,
    this.showPlayButton,
    this.jumpTitle,
    this.updateFrequency,
    this.classify,
    this.albumImg_9,
    this.intro,
    this.imgurl,
  });
  RankListItemModel.fromJson(Map<String, dynamic> json) {
    rankCid = json['rank_cid']?.toInt();
    id = json['id']?.toInt();
    rankname = json['rankname']?.toString();
    jumpUrl = json['jump_url']?.toString();
    banner_9 = json['banner_9']?.toString();
    rankid = json['rankid']?.toInt();
    haschildren = json['haschildren']?.toInt();
    bannerurl = json['bannerurl']?.toString();
    zone = json['zone']?.toString();
    if (json['songinfo'] != null) {
      final v = json['songinfo'];
      final arr0 = <RankListItemModelSonginfo>[];
      v.forEach((v) {
        arr0.add(RankListItemModelSonginfo.fromJson(v));
      });
      songinfo = arr0;
    }
    isvol = json['isvol']?.toInt();
    playTimes = json['play_times']?.toInt();
    img_9 = json['img_9']?.toString();
    customType = json['custom_type']?.toInt();
    ranktype = json['ranktype']?.toInt();
    if (json['img_cover'] != null) {
      imgCover = json['img_cover'].toString().replaceAll(RegExp(r'{size}/'), "");
    }
    // imgCover = json['img_cover']?.toString();
    issue = json['issue']?.toInt();
    banner7url = json['banner7url']?.toString();
    showPlayButton = json['show_play_button']?.toInt();
    jumpTitle = json['jump_title']?.toString();
    updateFrequency = json['update_frequency']?.toString();
    classify = json['classify']?.toInt();
    albumImg_9 = json['album_img_9']?.toString();
    intro = json['intro']?.toString();
    if (json['imgurl'] != null) {
      imgurl = json['imgurl'].toString().replaceAll(RegExp(r'{size}/'), "");
    }
    // imgurl = json['imgurl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rank_cid'] = rankCid;
    data['id'] = id;
    data['rankname'] = rankname;
    data['jump_url'] = jumpUrl;
    data['banner_9'] = banner_9;
    data['rankid'] = rankid;
    data['haschildren'] = haschildren;
    data['bannerurl'] = bannerurl;
    data['zone'] = zone;
    if (songinfo != null) {
      final v = songinfo;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['songinfo'] = arr0;
    }
    data['isvol'] = isvol;
    data['play_times'] = playTimes;
    data['img_9'] = img_9;
    data['custom_type'] = customType;
    data['ranktype'] = ranktype;
    data['img_cover'] = imgCover;
    data['issue'] = issue;
    data['banner7url'] = banner7url;
    data['show_play_button'] = showPlayButton;
    data['jump_title'] = jumpTitle;
    data['update_frequency'] = updateFrequency;
    data['classify'] = classify;
    data['album_img_9'] = albumImg_9;
    data['intro'] = intro;
    data['imgurl'] = imgurl;
    return data;
  }
}
