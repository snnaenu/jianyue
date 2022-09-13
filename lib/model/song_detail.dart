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
    if (json['size'] != null) {
      if (json["size"] is int) {
        size = json['size']?.toInt();
      }

      if (json["size"] is String) {
        size = int.parse(json['size']);
      }
    }

    if (json['br'] != null) {
      br = json['br']?.toInt();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['size'] = size;
    data['br'] = br;
    return data;
  }
}
