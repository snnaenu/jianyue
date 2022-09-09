
class SongDetail {

  String? url;
  int? size;
  int? br;

  SongDetail({
    this.url,
    this.size,
    this.br,
  });

  SongDetail.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString() ?? "";
    size = json['size']?.toInt();
    br = json['br']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['size'] = size;
    data['br'] = br;
    return data;
  }
}
