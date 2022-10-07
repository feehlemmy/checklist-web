import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/ModelReactive/ItemDrawer.dart';
import 'package:projeto_kva/Utils/Drawers/AppDrawer.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Controller/Controller.dart';
import '../ModelReactive/UserEntityReactive.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.items}) : super(key: key);
  final List<ItemDrawer> items;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: Controller(),
        builder: (_) {
          Controller.to.items = items;

          return FutureBuilder<UserEntityReactive>(
              future: Controller.to.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      child: LayoutBuilder(builder: (context, constrainsts) {
                    return OrientationBuilder(builder: (context, orientation) {
                      return Obx(() => Scaffold(
                            backgroundColor: PersonalizedColors.skyBlue,
                            drawer: AppDrawer(
                              items: items,
                              title: 'Painel ',
                            ),
                            appBar: new AppBar(
                              title: AutoSizeText(Controller.to.getTitle(),
                                  maxLines: 1,
                                  maxFontSize: 14,
                                  textAlign: TextAlign.center),
                              titleTextStyle: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              centerTitle: true,
                            ),
                            body:
                                LayoutBuilder(builder: (context, constrainsts) {
                              return OrientationBuilder(
                                  builder: (context, orientation) {
                                return orientation == Orientation.portrait
                                    ? buildPage(constrainsts.maxHeight,
                                        constrainsts.maxWidth, true)
                                    : buildPage(constrainsts.maxHeight,
                                        constrainsts.maxWidth, false);
                              });
                            }),
                          ));
                    });
                  }));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        });
  }

  buildPage(double maxHeight, double maxWidth, bool bool) {
    return Obx(() => Controller.to.buildScreen());
  }
}
