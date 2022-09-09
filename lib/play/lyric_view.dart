import 'dart:ui';
import 'dart:ui' as prefix0;
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/model/lyric.dart';

class LyricView extends CustomPainter with ChangeNotifier {
  List<Lyric> lyric;
  late List<TextPainter> lyricPaints = []; // 其他歌词
  late double _offsetY = 0;
  int curLine;
  late Paint linePaint;
  late bool isDragging = false; // 是否正在人为拖动
  late double totalHeight = 0; // 总长度
  late TextPainter draggingLineTimeTextPainter; // 正在拖动中当前行的时间
  late Size canvasSize = Size.zero;
  late int dragLineTime;

  final commonWhiteTextStyle = TextStyle(
      fontSize: 12.sp, color: Colors.red, overflow: TextOverflow.ellipsis);
  final commonGrayTextStyle = TextStyle(
      fontSize: 12.sp, color: Colors.grey, overflow: TextOverflow.ellipsis);
  final commonWhite70TextStyle =
      TextStyle(fontSize: 14.sp, color: Colors.white70);
  final smallGrayTextStyle = TextStyle(
      fontSize: 10.sp, color: Colors.grey, overflow: TextOverflow.ellipsis);

  double get offsetY => _offsetY;

  set offsetY(double value) {
    // 判断如果是在拖动状态下
    if (isDragging) {
      // 不能小于最开始的位置
      if (_offsetY.abs() < lyricPaints[0].height + 30.dp) {
        _offsetY = (lyricPaints[0].height + 30.dp) * -1;
      } else if (_offsetY.abs() >
          (totalHeight + lyricPaints[0].height + 30.dp)) {
        // 不能大于最大位置
        _offsetY = (totalHeight + lyricPaints[0].height + 30.dp) * -1;
      } else {
        _offsetY = value;
      }
    } else {
      // print("offsetY = $offsetY");
      _offsetY = value;
    }
    notifyListeners();
  }

  LyricView(this.lyric, this.curLine) {
    linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1.dp;
    if (lyric.isNotEmpty) {
      lyricPaints.addAll(lyric
          .map((l) => TextPainter(
              text: TextSpan(text: l.lyric, style: commonGrayTextStyle),
              textDirection: TextDirection.ltr,
              maxLines: 3))
          .toList());
      // 首先对TextPainter 进行 layout，否则会报错
      _layoutTextPainters();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // print("size = $size");
    // canvasSize = size;
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;
    for (int i = 0; i < lyric.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        // 画每一行歌词
        if (curLine == i) {
          // 如果是当前行
          lyricPaints[i].text =
              TextSpan(text: lyric[i].lyric, style: commonWhiteTextStyle);
          lyricPaints[i].layout();
        } else if (isDragging &&
            i ==
                (_offsetY / (lyricPaints[0].height + 30.dp)).abs().round() -
                    1) {
          // 如果是拖动状态中的当前行
          lyricPaints[i].text =
              TextSpan(text: lyric[i].lyric, style: commonWhite70TextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text =
              TextSpan(text: lyric[i].lyric, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }

        lyricPaints[i].maxLines = 3;
        double begin = (size.width - lyricPaints[i].width) / 2;
        // if (begin.abs() > size.width*0.5) begin = -size.width*0.5;
        // print("lyricPaints[i].size: ${lyricPaints[i].size}");
        lyricPaints[i].paint(
          canvas,
          Offset(begin, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + 30.dp;
      lyric[i].offset = y;
    }

    // 拖动状态下显示的东西
    if (isDragging) {
      // 画 icon
      final icon = Icons.play_arrow;
      var builder = prefix0.ParagraphBuilder(prefix0.ParagraphStyle(
        fontFamily: icon.fontFamily,
        fontSize: 60.sp,
      ))
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(prefix0.ParagraphConstraints(
        width: 60.dp,
      ));
      canvas.drawParagraph(para, Offset(10.dp, size.height / 2 - 60.dp));

      // 画线
      canvas.drawLine(Offset(80.dp, size.height / 2 - 30.dp),
          Offset(size.width - 120.dp, size.height / 2 - 30.dp), linePaint);
      // 画当前行的时间
      dragLineTime =
          lyric[(_offsetY / (lyricPaints[0].height + 30.dp)).abs().round() - 1]
                  .startTime
                  ?.inMilliseconds ??
              0;
      draggingLineTimeTextPainter = TextPainter(
        text: TextSpan(
            text: DateUtil.formatDateMs(dragLineTime, format: "mm:ss"),
            style: smallGrayTextStyle),
        textDirection: TextDirection.ltr,
      );
      draggingLineTimeTextPainter.layout();
      draggingLineTimeTextPainter.paint(
          canvas, Offset(size.width - 80.dp, size.height / 2 - 45.dp));
    }
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine) {
    return (lyricPaints[0].height + 30.dp) * (curLine + 1);
  }

  void _layoutTextPainters() {
    for (var lp in lyricPaints) {
      lp.layout();
    }

    // 延迟一下计算总高度
    Future.delayed(const Duration(milliseconds: 300), () {
      totalHeight = (lyricPaints[0].height + 30.dp) * (lyricPaints.length - 1);

      print("totalHeight = $totalHeight");
    });
  }

  @override
  bool shouldRepaint(LyricView oldDelegate) {
    return oldDelegate._offsetY != _offsetY ||
        oldDelegate.isDragging != isDragging;
  }
}
