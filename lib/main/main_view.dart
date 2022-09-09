import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/custom/background_shower.dart';
import 'package:weapon/main/main_drawer.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/main/main_state.dart';
import 'package:weapon/main/side_navigation.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/play/play_view.dart';
import 'package:weapon/utils/audio_player_util.dart';

class MainView extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      // drawer: const MainDrawer(),
      body: Row(children: [
        ///侧边栏区域
        GetBuilder<MainController>(
          builder: (logic) {
            return Expanded(
              flex: 5,
              child: SideNavigation(
                selectedIndex: logic.state.selectedIndex,
                isUnfold: logic.state.isUnfold,
                isScale: logic.state.isScale,
                sideItems: logic.state.itemList,
                onItem: (index) => logic.switchTap(index),
                onUnfold: (isUnfold) => logic.onUnfold(isUnfold),
                onScale: (isScale) => logic.onScale(isScale),
                oneWord: logic.state.oneWord ?? "",
                oneWordClicked: logic.getOneWord,
              ),
            );
          },
        ),

        ///Expanded占满剩下的空间
        Expanded(
          flex: 17,
          child: Stack(
            children: [
              // _buildBackground(),
              PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.state.pageList.length,
                itemBuilder: (context, index){
                  return Navigator(
                    initialRoute: '/',
                    onGenerateRoute: (RouteSettings settins) {
                      // WidgetBuilder builder;
                      // switch (settins.name) {
                      //   case '/':
                      //     builder = (context) => controller.state.pageList[index];
                      //     break;
                      //   default:
                      //     builder = (context) => Container();
                      //     break;
                      // }
                      return MaterialPageRoute(builder: (context) => controller.state.pageList[index]);
                    },
                  );
                },
                // controller.state.pageList[index],
                controller: controller.state.pageController,
              )
            ],
          ),
        ),
        Expanded(flex: 6, child: PlayView()),
      ]),
    );
  }

  Widget _buildBackground() {
    return BackgroundShower();
  }
}
