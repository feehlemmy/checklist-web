import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';

import '../Utils/Constansts.dart';

class ViewCheckListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: Controller.to.getChecklistFirstTime(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: LayoutBuilder(builder: (context, constrainsts) {
                    return OrientationBuilder(builder: (context, orientation) {
                      return orientation == Orientation.portrait
                          ? buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, true)
                          : buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, false);
                    });
                  }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Widget buildPage(double height, double width, bool small) {
    RxString filter = ''.obs;
    RxList<Obx> cards = buildCards(height, width, small, filter.value!).obs;

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 2.0,
      ),
    );

    return Container(
        child: ListView(children: [
      Container(
        height: height * .05,
      ),
      Container(
        width: small == true ? width * .7 : width * .25,
        height: height * .07,
        child: TextFormField(
            autofocus: false,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(color: Colors.white, fontSize: 14)),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              focusedBorder: enableBorder,
              errorStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 14,
                color: Colors.red,
              )),
              hintStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
            ),
            textAlign: TextAlign.center,
            onChanged: (value) {
              filter.value = value;
              cards.value = buildCards(height, width, small, filter.value!);
            }),
      ).marginOnly(left: width * .1, right: width * .1),
      Container(
        height: height * .05,
      ),
      Obx(() => GridView.count(
              shrinkWrap: true,
              addRepaintBoundaries: true,
              childAspectRatio: 1.8,
              crossAxisCount: small == true ? 2 : 3,
              padding: EdgeInsets.all(30),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              // ignore: invalid_use_of_protected_member
              children: cards.value)
          .marginOnly(left: width * .1, right: width * .1)),
    ]));
  }

  List<Obx> buildCards(double height, double width, bool small, String filter) {
    List<CheckListSkeletonReactive> cheklistSkeletonFilteredList = [];
    List<Obx> cards = [];
    List<CheckListSkeletonReactive> checklistSkeletonList =
        Controller.to.checklistSkeletonList;
    checklistSkeletonList
        .sort((a, b) => a.title!.value!.compareTo(b.title!.value!));

    if (!filter.isBlank!) {
      for (CheckListSkeletonReactive checklistSkeleton
          in checklistSkeletonList) {
        String title = checklistSkeleton.title!.value!;
        if (title.toUpperCase().contains(filter.toUpperCase())) {
          cheklistSkeletonFilteredList.add(checklistSkeleton);
        }
      }
      if (Controller.to.user.sector!.value != Constants.controleDeQualidade) {
        cheklistSkeletonFilteredList.removeWhere((element) =>
            element.sector!.value != Controller.to.user.sector!.value);
      } else {
        checklistSkeletonList.removeWhere((element) =>
            element.sector!.value != Controller.to.user.sector!.value &&
            element.sector!.value != Constants.inspecaoVisual);
      }
    } else {
      cheklistSkeletonFilteredList = checklistSkeletonList;
      if (Controller.to.user.sector!.value != Constants.controleDeQualidade) {
        cheklistSkeletonFilteredList.removeWhere((element) =>
            element.sector!.value != Controller.to.user.sector!.value);
      } else {
        checklistSkeletonList.removeWhere((element) =>
            element.sector!.value != Controller.to.user.sector!.value &&
            element.sector!.value != Constants.inspecaoVisual);
      }
    }

    for (CheckListSkeletonReactive checklistSkeletonAux
        in cheklistSkeletonFilteredList) {
      final checklist = checklistSkeletonAux.obs;
      ProductEntityReactive? product;
      Controller.to.getProductsList().forEach((element) {
        if (element.id == checklist.value!.productId!.value) {
          product = element;
        }
      });
      cards.add(Obx(
        () => InkWell(
            child: Container(
              width: small == true ? width * .7 : width * .1,
              height: height * .2,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, style: BorderStyle.solid, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CommonWidgets.buildText(checklist.value!.title!.value!, 14,
                      Colors.white, TextAlign.center),
                  Container(
                    height: 0.5,
                  ),
                  CommonWidgets.buildText(checklist.value!.sector!.value!, 14,
                      Colors.white, TextAlign.center),
                  Container(
                    height: 0.5,
                  ),
                  product != null
                      ? CommonWidgets.buildText(product!.name!.value!, 14,
                          Colors.white, TextAlign.center)
                      : Container(),
                  Container(
                    height: 0.5,
                  ),
                ],
              ),
            ),
            onTap: () => buildAnswerCheckListSkeleton(checklist.value!)),
      ));
    }
    return cards;
  }

  buildAnswerCheckListSkeleton(CheckListSkeletonReactive checklistSkeleton) {
    Controller.to.checkListToAnswer = checklistSkeleton;
    Controller.to.batch = ''.obs;
    Controller.to.productVersion = ''.obs;
    Controller.to.index.value = 70;
    Controller.to.previousindex.value = 70;

    Controller.to.buildScreen();
  }
}
