class TimeFormatUtil {
  static String secondToTimeString(int duration) {
    int min = (duration / 60).floor();
    String minStr = "$min";
    if (min < 10) minStr = "0$min";
    int seconds = (duration % 60).floor();
    String secondStr = "$seconds";
    if (seconds < 10) secondStr = "0$seconds";
    return "$minStr:$secondStr";
  }
}
