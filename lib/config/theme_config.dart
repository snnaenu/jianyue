import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';

class ThemeConfig {
  ///白天模式
  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: const Color(0xffffffff),
      splashColor: Colors.white,
      highlightColor: Colors.white,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(color: Colors.black,size: 20),
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: Color(0xFF2d2d2d),
        ),
        centerTitle: true,
      ),
      scaffoldBackgroundColor: const Color(0xffF6F8F9),
      backgroundColor: const Color(0xffF6F8F9),
      dividerColor: const Color(0xffF6F8F9),
      iconTheme: const IconThemeData(
        color: Color(0xFF2d2d2d),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.tealAccent),
      cardColor: Colors.white,
      shadowColor: const Color(0xffe0e0e0).withAlpha(120),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 15,
            color: Color(0xFF2d2d2d),
            fontWeight: FontWeight.w400),
        subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF666666))
      ));

  ///夜间模式
  static ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: ThemeData.dark().primaryColor,
      splashColor: ThemeData.dark().splashColor,
      highlightColor: Colors.black,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        backgroundColor: ThemeData.dark().cardColor,
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        titleTextStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFFeeeeee),
        ),
        centerTitle: true,
      ),
      scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
      dividerColor: ThemeData.dark().dividerColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.blue),
      cardColor: ThemeData.dark().cardColor,
      shadowColor: ThemeData.dark().shadowColor.withAlpha(10),
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
              fontWeight: FontWeight.w400),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF666666))
      )
  );

  static ThemeData get theme => Get.theme;

  static bool get isDark => Get.isDarkMode;
}
