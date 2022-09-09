///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PlayListItemModel {

  int? id;
  int? no;
  String? coverImgUrl;
  String? name;
  int? playCount;
  int? subscribedCount;
  int? shareCount;
  int? commentCount;
  int? trackCount;
  String? nickname;
  String? createTime;
  List<String?>? tags;
  int? userId;
  String? avatarUrl;

  PlayListItemModel({
    this.id,
    this.no,
    this.coverImgUrl,
    this.name,
    this.playCount,
    this.subscribedCount,
    this.shareCount,
    this.commentCount,
    this.trackCount,
    this.nickname,
    this.createTime,
    this.tags,
    this.userId,
    this.avatarUrl,
  });
  PlayListItemModel.fromJson(Map<String, dynamic> json) {
    id = json['Id']?.toInt();
    no = json['No']?.toInt();
    coverImgUrl = json['CoverImgUrl']?.toString();
    name = json['Name']?.toString();
    playCount = json['PlayCount']?.toInt();
    subscribedCount = json['SubscribedCount']?.toInt();
    shareCount = json['ShareCount']?.toInt();
    commentCount = json['CommentCount']?.toInt();
    trackCount = json['TrackCount']?.toInt();
    nickname = json['Nickname']?.toString();
    createTime = json['CreateTime']?.toString();
    if (json['Tags'] != null) {
      final v = json['Tags'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      tags = arr0;
    }
    userId = json['UserId']?.toInt();
    avatarUrl = json['AvatarUrl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['No'] = no;
    data['CoverImgUrl'] = coverImgUrl;
    data['Name'] = name;
    data['PlayCount'] = playCount;
    data['SubscribedCount'] = subscribedCount;
    data['ShareCount'] = shareCount;
    data['CommentCount'] = commentCount;
    data['TrackCount'] = trackCount;
    data['Nickname'] = nickname;
    data['CreateTime'] = createTime;
    if (tags != null) {
      final v = tags;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['Tags'] = arr0;
    }
    data['UserId'] = userId;
    data['AvatarUrl'] = avatarUrl;
    return data;
  }
}