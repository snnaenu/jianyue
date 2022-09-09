import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/theme_config.dart';

typedef OnChanged = Function(String text);
typedef StartSearch = Function();

// ignore: must_be_immutable
class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  static const double appBarHeight = 66;
  Widget? child;
  double height = 66;

  MyAppbar({Key? key, this.child, this.height = 66}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppbarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(height.dp);
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}

class SearchWidget extends StatelessWidget {
  OnChanged? onChanged;
  StartSearch? start;
  final TextEditingController searchBarController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  SearchWidget({Key? key, this.onChanged, this.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: start,
      child: Container(
        decoration: BoxDecoration(
            color: ThemeConfig.theme.cardColor,
            borderRadius: BorderRadius.all(
              Radius.circular(22.dp),
            ),
            boxShadow: [
              BoxShadow(
                  color: ThemeConfig.theme.shadowColor,
                  offset: const Offset(6, 6),
                  blurRadius: 5.0,
                  spreadRadius: 0),
              BoxShadow(
                  color: ThemeConfig.theme.shadowColor,
                  offset: const Offset(-6, -6),
                  blurRadius: 5.0,
                  spreadRadius: 0)
            ]),
        height: 50.dp,
        // padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 12.dp),
        child: Container(
          // height: SGScreenUtil.w(40),
          // decoration: BoxDecoration(
          //   color: const Color(0xFFF5F5F5),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(8.dp),
          //   ),
          // ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.dp,
              ),
              Container(
                // color: Colors.blue,
                child: Image.asset(
                  "assets/images/search_icon.png",
                  width: 15.dp,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 12.dp,
              ),
              Expanded(
                // height: SGScreenUtil.h(40),
                child: TextField(
                  focusNode: searchFocus,
                  controller: searchBarController,
                  onChanged: onChanged,
                  enabled: start == null,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 12.sp,
                      textBaseline: TextBaseline.alphabetic),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(
                        0, 0, 0, 0), //const EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: "请输入歌曲名称、歌单链接",
                    hintStyle:
                        TextStyle(color: Color(0xFF999999), fontSize: 12.sp),
                  ),
                ),
              ),
              // cancelWidget,
              SizedBox(
                width: 10.dp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
