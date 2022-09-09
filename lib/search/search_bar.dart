import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/theme_config.dart';

typedef OnChanged = Function(String text);
typedef StartSearch = Function();
typedef MenuChanged = Function(String text);

class SearchBar extends StatelessWidget {
  OnChanged? onChanged;
  StartSearch? search;
  MenuChanged? menuChanged;
  TextEditingController searchBarController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<DropdownMenuItem<String>> menuItems = [];
  String selectedName = "";
  List<Map<String, dynamic>> sources = [];

  SearchBar(
      {Key? key,
      this.onChanged,
      this.search,
      this.menuChanged,
      required this.searchBarController,
      required this.searchFocus,
      required this.menuItems,
      required this.selectedName,
      required this.sources})
      : super(key: key);

  Widget _routeName() {
    if (menuItems.isEmpty) return Container();
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: menuItems,
        value: selectedName,
        elevation: 0,
        isDense: true,
        isExpanded: false,
        menuMaxHeight: 200.dp,
        autofocus: false,
        borderRadius: BorderRadius.circular(4.dp),
        selectedItemBuilder: (BuildContext context) {
          return sources.map<Widget>((Map<String, dynamic> route) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                route["name"],
                style: TextStyle(
                  color: ThemeConfig.theme.textTheme.headline1?.color,
                  fontSize: 13.sp,
                  // fontWeight: FontWeight.w300,
                ),
              ),
            );
          }).toList();
        },
        iconEnabledColor: Colors.white,
        focusColor: Colors.white,
        dropdownColor: Colors.white,
        icon: Container(),
        onChanged: (newValue) =>
            menuChanged != null ? menuChanged!(newValue!) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              width: 22.dp,
            ),
            ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: _routeName()),
            SizedBox(
              width: 15.dp,
            ),
            Container(
              // color: Colors.blue,
              child: Image.asset(
                "assets/images/search_icon.png",
                width: 14.sp,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 12.dp,
            ),
            Expanded(
              // height: SGScreenUtil.h(40),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Color(0xFFeeeeee),
                //     borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(22.dp),
                //       bottomRight: Radius.circular(22.dp),
                //     ),
                //     ),
                child: TextField(
                  focusNode: searchFocus,
                  controller: searchBarController,
                  onChanged: onChanged,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: ThemeConfig.theme.textTheme.headline1?.color,
                      fontSize: 13.sp,
                      // fontWeight: FontWeight.w300,
                      textBaseline: TextBaseline.alphabetic),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    //const EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: "请输入歌曲名称、歌单链接",
                    hintStyle: TextStyle(
                      color: Color(0xFF999999), fontSize: 12.sp,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (text) {
                    if (search != null) {
                      search!();
                    }
                  },
                ),
              ),
            ),
            // cancelWidget,
            SizedBox(
              width: 10.dp,
            ),
            GestureDetector(
              onTap: search,
              child: Container(
                width: 70.dp,
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ThemeConfig.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(22.dp),
                    bottomRight: Radius.circular(22.dp),
                  ),
                ),
                child: Text(
                  "搜索",
                  style: ThemeConfig.theme.textTheme.headline1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
