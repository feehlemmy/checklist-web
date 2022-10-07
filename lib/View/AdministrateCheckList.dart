import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionSkeletonReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as Responsive;

import '../Utils/Constansts.dart';

class AdministrateCheckList extends StatelessWidget {
  const AdministrateCheckList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constrainsts) {
        return OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPage(
                  constrainsts.maxHeight, constrainsts.maxWidth, true, context)
              : buildPage(constrainsts.maxHeight, constrainsts.maxWidth, false,
                  context);
        });
      }),
    );
  }

  buildPage(double height, double width, bool small, BuildContext context) {
    RxString filter = ''.obs;
    RxList<Container> cards =
        buildCards(height, width, small, filter.value!, context).obs;

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
              cards.value =
                  buildCards(height, width, small, filter.value!, context);
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

  List<Container> buildCards(double height, double width, bool small,
      String filter, BuildContext context) {
    List<CheckListSkeletonReactive> cheklistSkeletonFilteredList = [];
    List<Container> cards = [];
    List<CheckListSkeletonReactive> checklistSkeletonList =
        Controller.to.getChecklistSkeletonList();
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
    } else {
      cheklistSkeletonFilteredList = checklistSkeletonList;
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
      cards.add(Container(
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
                ? CommonWidgets.buildText(
                    product!.name!.value!, 14, Colors.white, TextAlign.center)
                : Container(),
            Container(
              height: 0.5,
            ),
            Obx(() => Controller.to
                .userIsDisableText(checklist.value!.status!.value)),
            Container(
              height: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    tooltip: 'Editar',
                    onPressed: () {
                      Controller.to.checklistToEdit = checklistSkeletonAux;
                      editUser(context);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                IconButton(
                    tooltip: 'Duplicar',
                    onPressed: () {
                      Controller.to.checklistToCopy = checklistSkeletonAux;

                      copyCheckList(context);
                      Controller.to.getChecklistSkeleton();
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Colors.white,
                    )),
                IconButton(
                    tooltip: 'Excluir',
                    onPressed: () {
                      showConfirmation(checklist.value);
                    },
                    icon: Icon(Icons.delete, color: Colors.white)),
                Obx(() => Controller.to
                    .getIconDeleteOrRestoreChecklist(checklist.value!))
              ],
            ),
          ],
        ),
      ));
    }
    return cards;
  }

  editUser(context) {
    showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.8,
        maxHeight: 1,
        context: context,
        builder: _buildBottomSheet,
        anchors: [0, 0.5, 1],
        isCollapsible: true,
        isExpand: false,
        isModal: true);
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return SafeArea(
      child: buildCompleteCheckList(context, Controller.to.checklistToEdit!),
    );
  }

  buildCompleteCheckList(
      BuildContext context, CheckListSkeletonReactive checkList) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.height * 0.6;
    bool small = false;

    List<String> productsName = List.empty(growable: true);
    productsName = Controller.to.buildProductNameList();
    var auxProducts = Controller.to.getProductsList();
    List<ProductEntityReactive> products = List.empty(growable: true);
    for (ProductEntityReactive product in auxProducts) {
      if (product.status!.value == 'Active') {
        products.add(product);
      }
    }

    var sectorList = <String>[
      Constants.assistencia,
      Constants.producao,
      Constants.controleDeQualidade,
      Constants.inspecaoFinal,
      Constants.inspecaoVisual,
    ];
    sectorList.sort();
    RxString sectorOption = checkList.sector!.value!.trim().obs;
    RxString? product;

    for (ProductEntityReactive item in products) {
      int id = item.id!;
      if (id == checkList.productId!.value) {
        product = item.name!.value!.obs;
        break;
      }
    }

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );
    return Obx(() => SafeArea(
          bottom: false,
          child: Material(
            color: PersonalizedColors.skyBlue,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: width * .4,
                    height: height * .07,
                    child: TextFormField(
                        autofocus: false,
                        style: GoogleFonts.montserrat(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        decoration: InputDecoration(
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
                        initialValue: checkList.title!.value,
                        textAlign: TextAlign.center,
                        onChanged: (String? newValue) {
                          checkList.title!.value = newValue!;
                        }),
                  ).marginOnly(left: width * .2, right: width * .2),
                  Container(
                    height: height * 0.02,
                  ),
                  Obx(() => Container(
                        width: small == true ? width * .7 : width * .4,
                        height: height * .07,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: DropdownButton(
                          onChanged: (String? value) {
                            product!.value = value!;
                            for (ProductEntityReactive item in products) {
                              String name = item.name!.value!;
                              if (name == value) {
                                checkList.productId!.value = item.id!;
                                break;
                              }
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return productsName.map<Widget>((String item) {
                              return Container(
                                alignment: Alignment.center,
                                child: CommonWidgets.buildText(
                                    item, 14, Colors.white, TextAlign.center),
                              );
                            }).toList();
                          },
                          items: productsName.map((String option) {
                            return DropdownMenuItem(
                              child: CommonWidgets.buildText(
                                  option, 14, Colors.white, TextAlign.center),
                              value: option,
                            );
                          }).toList(),
                          value: product!.value,
                          dropdownColor: PersonalizedColors.skyBlue,
                          isExpanded: true,
                          isDense: false,
                          underline: SizedBox(),
                        ).marginOnly(
                          left: 10,
                          right: 10,
                        ),
                      ).marginOnly(left: width * .5, right: width * .5)),
                  Container(
                    height: height * 0.02,
                  ),
                  Obx(() => Container(
                        width: small == true ? width * .7 : width * .25,
                        height: height * .07,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: DropdownButton(
                          onChanged: (newValue) {
                            checkList.sector!.value = newValue.toString();
                            sectorOption.value = newValue.toString();
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return sectorList.map<Widget>((String item) {
                              return Container(
                                alignment: Alignment.center,
                                child: CommonWidgets.buildText(
                                    item, 14, Colors.white, TextAlign.center),
                              );
                            }).toList();
                          },
                          items: sectorList.map((String option) {
                            return DropdownMenuItem(
                              child: CommonWidgets.buildText(
                                  option, 14, Colors.white, TextAlign.center),
                              value: option,
                            );
                          }).toList(),
                          value: sectorOption.value,
                          dropdownColor: PersonalizedColors.skyBlue,
                          isExpanded: true,
                          isDense: false,
                          underline: SizedBox(),
                        ).marginOnly(
                          left: 10,
                          right: 10,
                        ),
                      ).marginOnly(left: width * .5, right: width * .5)),
                  Container(
                    height: height * 0.02,
                  ),
                  Container(
                          width: width * .8,
                          child: AutoSizeText('Questões: ',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start))
                      .marginOnly(top: height * 0.05, left: width * 0.02),
                  Obx(() => Container(
                        child: Column(
                            children: buildQuestions(
                                height, width, small, checkList)),
                      ).marginOnly(top: height * 0.05)),
                  Container(
                          width: width * .8,
                          child: AutoSizeText('Pessoas Interessadas: ',
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start))
                      .marginOnly(top: height * 0.05, left: width * 0.02),
                  Container(
                    child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: buildEmails(height, width, small))
                        .marginOnly(
                      top: height * 0.05,
                    ),
                  ),
                  Container(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: width * .3,
                          height: height * .1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: PersonalizedColors.lightGreen,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(60.0),
                                  )),
                              onPressed: () {
                                Controller.to.editChecklist();
                                Get.back();
                              },
                              child: CommonWidgets.buildText("Salvar", 14,
                                  Colors.white, TextAlign.center))),
                    ],
                  ).marginOnly(bottom: height * 0.03),
                ],
              ),
            ).paddingAll(80),
          ),
        ));
  }

  buildEmails(
    double height,
    double width,
    bool small,
  ) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );
    List<Widget> containers = [];
    for (var email
        in Controller.to.checklistToEdit!.interestedPartiesEmailList!) {
      containers.add(
        Container(
            width: width * .5,
            child: Row(
              children: [
                AutoSizeText(email.email!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start),
                Container(
                    width: width * .05,
                    child: IconButton(
                        tooltip: "Remover",
                        onPressed: () {
                          Controller
                              .to.checklistToEdit!.interestedPartiesEmailList!
                              .remove(email);
                          Get.back();
                          editUser(Get.context);
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: PersonalizedColors.errorColor,
                        )))
              ],
            )),
      );
    }
    containers.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
                width: small == true ? width * .3 : width * .3,
                height: height * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          InterestedPartiesEmailReactiveEntity party =
                              new InterestedPartiesEmailReactiveEntity();
                          // retorna um objeto do tipo Dialog
                          return AlertDialog(
                            backgroundColor: PersonalizedColors.skyBlue,
                            content: new Container(
                                child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                  Container(
                                    width:
                                        small == true ? width * .7 : width * .4,
                                    height: height * .07,
                                    child: TextFormField(
                                        autofocus: false,
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                        decoration: InputDecoration(
                                          hintText: "E-mail Interessado",
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
                                          party.email = value.obs;
                                        }),
                                  ).marginOnly(top: height * 0.05)
                                ])),
                            actions: <Widget>[
                              // define os botões na base do dialogo
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        60.0),
                                              )),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: CommonWidgets.buildText(
                                              "Cancelar",
                                              14,
                                              PersonalizedColors.errorColor,
                                              TextAlign.center))),
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                                  PersonalizedColors.lightGreen,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        60.0),
                                              )),
                                          onPressed: () {
                                            Controller.to.checklistToEdit!
                                                .interestedPartiesEmailList!
                                                .add(party);
                                            Get.back();
                                            editUser(Get.context);
                                          },
                                          child: CommonWidgets.buildText(
                                              "Adicionar",
                                              14,
                                              Colors.white,
                                              TextAlign.center))),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CommonWidgets.buildText("Adicionar novo e-mail", 14,
                        PersonalizedColors.skyBlue, TextAlign.center)))
            .marginOnly(bottom: height * 0.03, top: height * 0.03),
      ],
    ));
    return containers;
  }

  buildQuestions(double height, double width, bool small,
      CheckListSkeletonReactive checklist) {
    // ignore: unused_local_variable
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
    // ignore: unused_local_variable
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );

    checklist.questions!.sort((a, b) =>
        int.parse(a.position!.value!).compareTo(int.parse(b.position!.value!)));

    List<Row> rows = [];
    for (var question in checklist.questions!) {
      TextEditingController textController =
          new TextEditingController(text: question.position!.value!);
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          width: width * .4,
          height: height * .12,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: enableBorder,
                errorStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                )),
                hintStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
              ),
              initialValue: question.category!.value,
              textAlign: TextAlign.center,
              maxLines: 5,
              onChanged: (String? newValue) {
                question.category!.value = newValue!;
              }),
        ),
        Container(
          width: width * .4,
          height: height * .12,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: enableBorder,
                errorStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                )),
                hintStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
              ),
              initialValue: question.description!.value,
              textAlign: TextAlign.center,
              maxLines: 5,
              onChanged: (String? newValue) {
                question.description!.value = newValue!;
              }),
        ),
        Container(
          width: width * .4,
          height: height * .12,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: enableBorder,
                errorStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                )),
                hintStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
              ),
              initialValue: question.tooltip!.value,
              textAlign: TextAlign.center,
              maxLines: 5,
              onChanged: (String? newValue) {
                question.tooltip!.value = newValue!;
              }),
        ),
        Container(
            width: width * .1,
            child: Obx(() => TextFormField(
                  initialValue: question.position!.value,
                  autofocus: false,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  decoration: InputDecoration(
                    hintText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Posição',
                    labelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    )),
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
                  onChanged: (String? newValue) {
                    textController.text = newValue!;
                  },
                  onEditingComplete: () {
                    editPosition(checklist, question.position!.value,
                        textController.text);
                  },
                ))),
        Container(
            width: width * .05,
            child: IconButton(
                tooltip: "Remover",
                onPressed: () {
                  Controller.to.checklistToEdit!.questions!.remove(question);
                  Get.back();
                  editUser(Get.context);
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: PersonalizedColors.errorColor,
                )))
      ]));
    }
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
                width: small == true ? width * .3 : width * .3,
                height: height * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      QuestionSkeletonReactive questionSkeletonReactive =
                          new QuestionSkeletonReactive(
                              category: RxString(""),
                              description: RxString(""),
                              tooltip: RxString(""));
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          // ignore: unused_local_variable
                          InterestedPartiesEmailReactiveEntity party =
                              new InterestedPartiesEmailReactiveEntity();
                          // retorna um objeto do tipo Dialog
                          return AlertDialog(
                            backgroundColor: PersonalizedColors.skyBlue,
                            content: Container(
                              width: width * .6,
                              child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonWidgets
                                        .buildTextFormWithoutValidationForEntities(
                                            7.h,
                                            Responsive.Device.screenType ==
                                                    Responsive.ScreenType.mobile
                                                ? 55.w
                                                : 25.w,
                                            Colors.white,
                                            null,
                                            'Categoria',
                                            14,
                                            questionSkeletonReactive.category),
                                    Container(
                                      height: height * 0.02,
                                    ),
                                    CommonWidgets
                                        .buildTextFormWithoutValidationForEntities(
                                            7.h,
                                            Responsive.Device.screenType ==
                                                    Responsive.ScreenType.mobile
                                                ? 55.w
                                                : 25.w,
                                            Colors.white,
                                            null,
                                            'Pergunta',
                                            14,
                                            questionSkeletonReactive
                                                .description),
                                    Container(
                                      height: height * 0.02,
                                    ),
                                    CommonWidgets
                                        .buildTextFormWithoutValidationForEntities(
                                            7.h,
                                            Responsive.Device.screenType ==
                                                    Responsive.ScreenType.mobile
                                                ? 55.w
                                                : 25.w,
                                            Colors.white,
                                            null,
                                            'Dica',
                                            14,
                                            questionSkeletonReactive.tooltip),
                                    Container(
                                      height: height * 0.02,
                                    )
                                  ]),
                            ),
                            actions: <Widget>[
                              // define os botões na base do dialogo
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        60.0),
                                              )),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: CommonWidgets.buildText(
                                              "Cancelar",
                                              14,
                                              PersonalizedColors.errorColor,
                                              TextAlign.center))),
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                                  PersonalizedColors.lightGreen,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        60.0),
                                              )),
                                          onPressed: () {
                                            if (Controller.to.validateField(
                                                questionSkeletonReactive
                                                    .category!.value!,
                                                "Categoria")) {
                                              if (Controller.to.validateField(
                                                  questionSkeletonReactive
                                                      .description!.value!,
                                                  "Pergunta")) {
                                                int lenght = Controller
                                                    .to
                                                    .checklistToEdit!
                                                    .questions!
                                                    .length;
                                                lenght = lenght + 1;
                                                String position =
                                                    lenght.toString();
                                                questionSkeletonReactive
                                                    .position = position.obs;
                                                Controller.to.checklistToEdit!
                                                    .questions!
                                                    .add(
                                                        questionSkeletonReactive);
                                                Get.back();
                                                editUser(Get.context);
                                              }
                                            }
                                          },
                                          child: CommonWidgets.buildText(
                                              "Adicionar",
                                              14,
                                              Colors.white,
                                              TextAlign.center))),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CommonWidgets.buildText("Adicionar nova questão", 14,
                        PersonalizedColors.skyBlue, TextAlign.center)))
            .marginOnly(bottom: height * 0.03, top: height * 0.03),
      ],
    ));
    return rows;
  }

  void copyCheckList(BuildContext context) {
    showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.5,
        maxHeight: 1,
        context: context,
        builder: _buildBottomSheetCopy,
        anchors: [0, 0.5, 1],
        isCollapsible: true,
        isExpand: false,
        isModal: true);
  }

  Widget _buildBottomSheetCopy(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return SafeArea(
      child: copyCheckListWidget(context, Controller.to.checklistToCopy!),
    );
  }

  copyCheckListWidget(
      BuildContext context, CheckListSkeletonReactive checkList) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.height * 0.6;
    bool small = false;

    List<String> productsName = List.empty(growable: true);
    productsName = Controller.to.buildProductNameList();
    var auxProducts = Controller.to.getProductsList();
    List<ProductEntityReactive> products = List.empty(growable: true);
    for (ProductEntityReactive product in auxProducts) {
      if (product.status!.value == 'Active') {
        products.add(product);
      }
    }

    var sectorList = <String>[
      Constants.assistencia,
      Constants.producao,
      Constants.controleDeQualidade,
      Constants.inspecaoFinal,
      Constants.inspecaoVisual
    ];
    sectorList.sort();
    RxString sectorOption = checkList.sector!.value!.trim().obs;
    RxString? product;

    for (ProductEntityReactive item in products) {
      int id = item.id!;
      if (id == checkList.productId!.value) {
        product = item.name!.value!.obs;
        break;
      }
    }

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );
    return SafeArea(
        bottom: true,
        child: Material(
            color: PersonalizedColors.skyBlue,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Container(
                child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  width: small == true ? width * .7 : width * .25,
                  height: height * .07,
                  child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
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
                      initialValue: checkList.title!.value,
                      textAlign: TextAlign.center,
                      onChanged: (String? newValue) {
                        checkList.title!.value = newValue!;
                      }),
                ).marginOnly(left: width * .5, right: width * .5),
                Container(
                  height: height * 0.02,
                ),
                Obx(() => Container(
                      width: small == true ? width * .7 : width * .4,
                      height: height * .07,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        onChanged: (String? value) {
                          product!.value = value!;
                          for (ProductEntityReactive item in products) {
                            String name = item.name!.value!;
                            if (name == value) {
                              checkList.productId!.value = item.id!;
                              break;
                            }
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return productsName.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },
                        items: productsName.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: product!.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ).marginOnly(left: width * .5, right: width * .5)),
                Container(
                  height: height * 0.02,
                ),
                Container(
                    width: small == true ? width * .7 : width * .25,
                    height: height * .07,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: DropdownButton(
                      onChanged: (newValue) {
                        checkList.sector!.value = newValue.toString();
                        sectorOption.value = newValue.toString();
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return sectorList.map<Widget>((String item) {
                          return Container(
                            alignment: Alignment.center,
                            child: CommonWidgets.buildText(
                                item, 14, Colors.white, TextAlign.center),
                          );
                        }).toList();
                      },
                      items: sectorList.map((String option) {
                        return DropdownMenuItem(
                          child: CommonWidgets.buildText(
                              option, 14, Colors.white, TextAlign.center),
                          value: option,
                        );
                      }).toList(),
                      value: sectorOption.value,
                      dropdownColor: PersonalizedColors.skyBlue,
                      isExpanded: true,
                      isDense: false,
                      underline: SizedBox(),
                    )
                        .marginOnly(
                          left: 10,
                          right: 10,
                        )
                        .marginOnly(left: width * .5, right: width * .5)),
                Container(
                  height: height * 0.02,
                ),
                Obx(() => Container(
                      child: Column(
                          children:
                              buildQuestions(height, width, small, checkList)),
                    ).marginOnly(top: height * 0.05)),
                Container(
                        width: small == true ? width * .3 : width * .05,
                        height: height * .05,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(60.0),
                                )),
                            onPressed: () {
                              Controller.to.editClonelist();

                              Get.back();
                            },
                            child: CommonWidgets.buildText("Salvar", 14,
                                PersonalizedColors.skyBlue, TextAlign.center)))
                    .marginOnly(left: width * .6, right: width * .6),
              ],
            )).paddingOnly(bottom: 10, top: 50, left: 80, right: 80)));
  }

  editPosition(CheckListSkeletonReactive checklist, String? oldValueString,
      String newValueString) {
    CheckListSkeletonReactive checklistCopy = checklist;
    if (newValueString == '') {
      return;
    }
    int oldValue = int.parse(oldValueString!);
    int newValue = int.parse(newValueString);

    for (int i = 0; i < checklist.questions!.length; i++) {
      if (checklist.questions![i].position!.value == oldValueString) {
        oldValue = i;
        continue;
      } else if (checklist.questions![i].position!.value == newValueString) {
        newValue = i;
        continue;
      }
    }

    int previousCategory = newValue - 1;
    int nextCategory;
    newValue == checklist.questions!.length
        ? nextCategory = newValue
        : nextCategory = newValue + 1;
    bool error = false;
    if (previousCategory >= 0 && nextCategory < checklist.questions!.length) {
      if (checklist.questions![previousCategory].category!.value! ==
          checklist.questions![nextCategory].category!.value) {
        if (checklist.questions![previousCategory].category!.value !=
            checklist.questions![oldValue].category!.value) {
          error = true;
          Get.dialog(AlertDialog(
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: PersonalizedColors.lightGreen,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(60.0),
                      )),
                  onPressed: () {
                    checklist = checklistCopy;
                    Controller.to.checklistToEdit = checklist;
                    Get.back();
                    Get.back();
                    editUser(Get.context);
                  },
                  child: Text(
                    'Ok',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )),
            ],
            content: Text(
              'Não é possível intercalar categorias!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            actionsOverflowButtonSpacing: 50,
            backgroundColor: PersonalizedColors.blueGrey,
            title: Text(
              'Verifique a ordenação',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ));
        }
      }
    }
    if (!error) {
      checklist.questions![oldValue].position!.value = newValueString;
      checklist.questions![newValue].position!.value = oldValueString;

      Controller.to.checklistToEdit!.questions = checklist.questions;
      Get.back();
      editUser(Get.context);
    }
  }

  showConfirmation(CheckListSkeletonReactive checkListSkeletonReactive) {
    Get.dialog(AlertDialog(
      content: Text(
        'Ao excluir não será possível recuperar o checklist!',
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
                Controller.to.deleteCheklist(checkListSkeletonReactive.id!);
                Controller.to.getChecklistSkeleton();

                Get.back();
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
        'Deseja Excluir o Checklist?',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ));
  }
}
