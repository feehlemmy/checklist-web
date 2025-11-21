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
              return LayoutBuilder(
                builder: (context, constraints) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      return Obx(() => Scaffold(
                            backgroundColor: PersonalizedColors.skyBlue,
                            drawer: AppDrawer(
                              items: items,
                              title: 'Painel',
                            ),
                            appBar: AppBar(
                              backgroundColor: PersonalizedColors.skyBlue,
                              title: AutoSizeText(
                                Controller.to.getTitle(),
                                maxLines: 1,
                                maxFontSize: 14,
                                textAlign: TextAlign.center,
                              ),
                              titleTextStyle: GoogleFonts.exo2(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              centerTitle: true,
                              iconTheme: IconThemeData(
                                color:
                                    Colors.white, // Cor do ícone do "Hamburger"
                              ),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(0),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 0.5,
                                ),
                              ),
                            ),
                            body: buildPage(
                              constraints.maxHeight,
                              constraints.maxWidth,
                              orientation == Orientation.portrait,
                            ),
                          ));
                    },
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }

  buildPage(double maxHeight, double maxWidth, bool bool) {
    return Obx(() => Controller.to.buildScreen());
  }
}
