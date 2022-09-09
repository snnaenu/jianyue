
class OneWordModel {

  int? id;
  String? uuid;
  String? hitokoto;
  String? type;
  String? from;
  String? fromWho;
  String? creator;
  int? creatorUid;
  int? reviewer;
  String? commitFrom;
  String? createdAt;
  int? length;

  OneWordModel({
    this.id,
    this.uuid,
    this.hitokoto,
    this.type,
    this.from,
    this.fromWho,
    this.creator,
    this.creatorUid,
    this.reviewer,
    this.commitFrom,
    this.createdAt,
    this.length,
  });
  OneWordModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    uuid = json['uuid']?.toString();
    hitokoto = json['hitokoto']?.toString();
    type = json['type']?.toString();
    from = json['from']?.toString();
    fromWho = json['from_who']?.toString();
    creator = json['creator']?.toString();
    creatorUid = json['creator_uid']?.toInt();
    reviewer = json['reviewer']?.toInt();
    commitFrom = json['commit_from']?.toString();
    createdAt = json['created_at']?.toString();
    length = json['length']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['hitokoto'] = hitokoto;
    data['type'] = type;
    data['from'] = from;
    data['from_who'] = fromWho;
    data['creator'] = creator;
    data['creator_uid'] = creatorUid;
    data['reviewer'] = reviewer;
    data['commit_from'] = commitFrom;
    data['created_at'] = createdAt;
    data['length'] = length;
    return data;
  }
}
