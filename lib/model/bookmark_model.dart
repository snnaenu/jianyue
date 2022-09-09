
class BookMarkItem {

  String? title = "";
  String? url = "";
  String? icon = "";
  String? desc = "";

  BookMarkItem({
    this.title,
    this.url,
    this.icon,
    this.desc
  });
  BookMarkItem.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString() ?? "";
    url = json['url']?.toString() ?? "";
    icon = json['icon']?.toString() ?? "";
    desc = json['desc']?.toString() ?? "";
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    data['icon'] = icon;
    data['desc'] = desc;
    return data;
  }
}

class BookMarkModel {

  String? category;
  String? name;
  List<BookMarkItem>? items = [];

  BookMarkModel({
    this.category,
    this.name,
    this.items,
  });

  BookMarkModel.fromJson(Map<String, dynamic> json) {
    category = json['category']?.toString() ?? "";
    name = json['name']?.toString() ?? "";
    if (json['items'] != null) {
      final v = json['items'];
      final arr0 = <BookMarkItem>[];
      v.forEach((v) {
        arr0.add(BookMarkItem.fromJson(v));
      });
      items = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    data['name'] = name;
    if (items != null) {
      final v = items;
      final arr0 = [];
      for (var value in v!) {
        arr0.add(value.toJson());
      }
      data['items'] = arr0;
    }
    return data;
  }
}
