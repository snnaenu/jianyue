class Lyric {
  String lyric = "";
  Duration? startTime;
  Duration? endTime;
  double? offset;

  Lyric({required this.lyric, this.startTime, this.endTime, this.offset});

  Lyric.fromJson(Map<String, dynamic> json) {
    lyric = json["lyric"];
    if (json["start_time"] != null &&
        json["start_time"].toString().isNotEmpty) {
      String startTimeStr = json["start_time"];
      var split = startTimeStr.split(":");
      startTime = Duration(
          minutes: int.parse(split[0].toString()),
          seconds: int.parse(split[1].toString()),
          microseconds: int.parse(split[2].toString()));
    }

    if (json["end_time"] != null && json["end_time"].toString().isNotEmpty) {
      String startTimeStr = json["end_time"];
      var split = startTimeStr.split(":");
      endTime = Duration(
          minutes: int.parse(split[0].toString()),
          seconds: int.parse(split[1].toString()),
          microseconds: int.parse(split[2].toString()));
    }

    offset = double.parse(json["offset"].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lyric'] = lyric;
    data['start_time'] = startTime != null
        ? "${startTime!.inMinutes}:${startTime!.inSeconds}:${startTime!.inMilliseconds}"
        : "";
    data['end_time'] = endTime != null
        ? "${endTime!.inMinutes}:${endTime!.inSeconds}:${endTime!.inMilliseconds}"
        : "";
    data['offset'] = offset;
    return data;
  }

  @override
  String toString() {
    return 'Lyric{lyric: $lyric, startTime: $startTime, endTime: $endTime}';
  }
}
