import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/ItemDrawer.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';

import '../../View/Dashboard.dart';
import '../WidgetsCommon.dart';

/// The navigation drawer for the app.
/// This listens to changes in the route to update which page is currently been shown
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.items, required this.title})
      : super(key: key);
  final List<ItemDrawer> items;
  final String title;

  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constrainsts) {
      return OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? buildPage(
                constrainsts.maxHeight, constrainsts.maxWidth, true, context)
            : buildPage(
                constrainsts.maxHeight, constrainsts.maxWidth, false, context);
      });
    });
  }

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  buildPage(double height, double width, bool small, BuildContext context) {
    initStorage();
    final box = GetStorage();
    String name = (box.read('name'));

    return GFDrawer(
      color: PersonalizedColors.blueGrey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(height: height * .1),
          CommonWidgets.buildText(
              title + box.read('sector'), 18, Colors.white, TextAlign.center),
          Container(height: height * .05),
          CommonWidgets.buildText(name, 18, Colors.white, TextAlign.center),
          Divider(
            color: Colors.white,
            endIndent: 1,
            indent: 0.5,
            thickness: 1,
          ),
          Container(height: height * .05),
          Column(children: buildItem(items, context)),
          buildButtonLogout(height, width, small),
        ],
      ),
    );
  }

  buildItem(List<ItemDrawer> items, BuildContext context) {
    List<ListTile> list = [];

    items.forEach((element) {
      list.add(ListTile(
          title: CommonWidgets.buildText(
              element.name, 14, Colors.white, TextAlign.left),
          leading: Icon(element.iconData, color: Colors.white),
          hoverColor: Colors.white,
          onTap: () {
            if (Controller.to.previousindex.value == 70) {
              showConfirmation(element.index);
              (Get.context as Element).reassemble();
            } else {
              Controller.to.index.value = element.index;
              Controller.to.buildScreen();
            }
          }));
    });

    return list;
  }
}

buildButtonLogout(double height, double width, small) {
  return Container(
    width: 10,
    height: height * .05,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: PersonalizedColors.redAccent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(60.0),
          )),
      onPressed: () => {Controller.to.logout()},
      child:
          CommonWidgets.buildText('Sair', 14, Colors.white, TextAlign.center),
    ),
  ).paddingAll(small == true ? 40 : 80);
}

showConfirmation(int index) {
  Get.dialog(AlertDialog(
    content: Text(
      'Todos os dados preenchidos serão perdidos!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    actionsOverflowButtonSpacing: 50,
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: PersonalizedColors.lightGreen,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () {
              Controller.to.confirmed.value = false;
              Get.back();
            },
            child: Text(
              'Não',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: PersonalizedColors.redAccent,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () {
              Controller.to.confirmed.value = true;
              Controller.to.previousindex.value = index;

              Controller.to.index.value = index;

              final box = GetStorage();
              box.remove('batch');
              box.remove('version');

              Get.back();
              Get.to(Dashboard(items: Controller.to.items));
            },
            child: Text(
              'Sim',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ],
    backgroundColor: PersonalizedColors.blueGrey,
    title: Text(
      'Deseja Voltar?',
      textAlign: TextAlign.center,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ));
}
