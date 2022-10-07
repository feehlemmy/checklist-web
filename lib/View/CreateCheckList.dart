import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionSkeletonReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/Constansts.dart';
import 'Dashboard.dart';
import 'EmptyScreen.dart';

class CreateChecklist extends StatelessWidget {
  const CreateChecklist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(builder: (context, constrainsts) {
      return buildPage(context);
    }));
  }

  buildPage(BuildContext context) {
    Controller.to.position = 1.obs;
    Controller.to.checklist = new CheckListSkeletonReactive(
        productId: 0.obs,
        sector: ''.obs,
        title: ''.obs,
        interestedPartiesEmailList: new Get.RxList.empty(growable: true),
        questions: new Get.RxList.empty(growable: true));
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
    Get.RxString sectorOption = Constants.producao.obs;
    Get.RxString? product;

    product = products.isNotEmpty
        ? products[0].name!.value!.obs
        : 'Nenhum Produto Cadastrado'.obs;

    Controller.to.checklist.sector = sectorOption;

    for (ProductEntityReactive item in products) {
      var name = item.name!.value!;
      if (name == product.value!) {
        Controller.to.checklist.productId = item.id!.obs;
        break;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: CommonWidgets.buildTextFormWithoutValidationForEntities(
                  7.h,
                  Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                  Colors.white,
                  null,
                  'Título',
                  12,
                  Controller.to.checklist.title)),
          Container(
            height: 2.h,
          ),
          Get.Obx(() => Container(
                width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                height: 6.h,
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
                        Controller.to.checklist.productId!.value = item.id!;
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
              )),
          Container(
            height: 2.h,
          ),
          Get.Obx(() => Container(
                width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                height: 6.h,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: DropdownButton(
                  onChanged: (newValue) {
                    Controller.to.checklist.sector!.value = newValue.toString();
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
              )),
          Container(
            height: 2.h,
          ),
          Container(
            height: 2.h,
          ),
          buildPartyTextBox(),
          Container(
            height: 2.h,
          ),
          Container(
              width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
              height: 6.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(60.0),
                      )),
                  onPressed: () => {buildDialog(context)},
                  child: CommonWidgets.buildText("Adicionar Questão", 14,
                      PersonalizedColors.skyBlue, TextAlign.center))),
          Container(
            height: 2.h,
          ),
          Container(
              alignment: Alignment.center,
              width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Device.screenType == ScreenType.mobile ? 35.w : 15.w,
                    height: 6.h,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: PersonalizedColors.lightGreen,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(60.0),
                            )),
                        onPressed: () {
                          Controller.to
                              .saveCheckListSkeleton(Controller.to.checklist);
                          Get.Get.to(EmptyScreen());
                          Get.Get.to(Dashboard(items: Controller.to.items));
                        },
                        child: CommonWidgets.buildText(
                            "Salvar", 14, Colors.white, TextAlign.center)),
                  ),
                  Container(
                    width: 1.w,
                  ),
                  Container(
                      width:
                          Device.screenType == ScreenType.mobile ? 15.w : 9.w,
                      height: 6.h,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        mini: true,
                        child: Icon(
                          Icons.remove_red_eye,
                          color: PersonalizedColors.skyBlue,
                        ),
                        tooltip: 'Pré Visualizar',
                        onPressed: () {
                          previewWidget(Get.Get.context!);
                        },
                      )),
                ],
              ))
        ],
      ),
    );
  }

  buildDialog(BuildContext context) {
    QuestionSkeletonReactive questionSkeletonReactive =
        new QuestionSkeletonReactive(
            category: Get.RxString(""),
            description: Get.RxString(""),
            tooltip: Get.RxString(""),
            position: Controller.to.position.value.toString().obs);
    initStorage();
    final box = GetStorage();

    if (box.read('category') != null) {
      questionSkeletonReactive.category!.value = box.read('category');
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
    Get.Get.bottomSheet(
      SafeArea(
        bottom: false,
        child: Material(
          color: PersonalizedColors.skyBlue,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                height: 7.h,
                child: TextFormField(
                    initialValue: questionSkeletonReactive.category!.value,
                    autofocus: false,
                    style: GoogleFonts.montserrat(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 14)),
                    decoration: InputDecoration(
                      hintText: 'Categoria',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Categoria',
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
                    onChanged: (value) {
                      questionSkeletonReactive.category = value.obs;
                      box.write('category', value);
                    }),
              ),
              Container(
                height: 2.h,
              ),
              CommonWidgets.buildTextFormWithoutValidationForEntities(
                  7.h,
                  Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                  Colors.white,
                  null,
                  'Pergunta',
                  12,
                  questionSkeletonReactive.description),
              Container(
                height: 2.h,
              ),
              CommonWidgets.buildTextFormWithoutValidationForEntities(
                  7.h,
                  Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                  Colors.white,
                  null,
                  'Dica',
                  12,
                  questionSkeletonReactive.tooltip),
              Container(
                height: 2.h,
              ),
              Container(
                  width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
                  height: 5.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(60.0),
                          )),
                      onPressed: () {
                        if (Controller.to.validateField(
                            questionSkeletonReactive.category!.value,
                            "Categoria")) {
                          if (Controller.to.validateField(
                              questionSkeletonReactive.description!.value,
                              "Pergunta")) {
                            questionSkeletonReactive.position =
                                (Controller.to.checklist.questions!.length + 1)
                                    .toString()
                                    .obs;
                            Controller.to.checklist.questions!
                                .add(questionSkeletonReactive);
                            Controller.to.position++;
                            Get.Get.back();
                            Controller.to.snackbar('', 'Adicionado com sucesso',
                                Colors.green[200]!);
                          }
                        }
                      },
                      child: CommonWidgets.buildText("Adicionar", 14,
                          PersonalizedColors.skyBlue, TextAlign.center))),
            ],
          ),
        ),
      ),
      isDismissible: true,
      backgroundColor: PersonalizedColors.skyBlue,
    );
  }

  buildPartyTextBox() {
    String? email;
    InterestedPartiesEmailReactiveEntity interestedParty;
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

    return Container(
        child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          width: Device.screenType == ScreenType.mobile ? 40.w : 15.w,
          height: 7.h,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                hintText: "E-mail Interessado",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'E-mail Interessado',
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
              onChanged: (value) {
                email = value;
              }),
        ),
        Container(
          width: 0.5.w,
        ),
        Container(
            width: Device.screenType == ScreenType.mobile ? 15.w : 10.w,
            height: 6.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(60.0),
                    )),
                onPressed: () {
                  interestedParty = new InterestedPartiesEmailReactiveEntity(
                      email: email!.obs, checkListSkeletonId: 0.obs, id: 0);

                  Controller.to.checklist.interestedPartiesEmailList!
                      .add(interestedParty);
                  Controller.to.snackbar(
                      '', 'Adicionado com sucesso', Colors.green[200]!);
                },
                child: CommonWidgets.buildText("Adicionar", 10,
                    PersonalizedColors.skyBlue, TextAlign.center))),
      ],
    )).marginOnly(left: 1.w);
  }

  void previewWidget(BuildContext context) {
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
      child: Material(
        color: PersonalizedColors.skyBlue,
        child: buildCompleteCheckList(context),
      ),
    );
  }

  buildCompleteCheckList(context) {
    ScrollController scrollController = ScrollController();

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                    'Título: ' + Controller.to.checklist.title!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start))
            .marginOnly(left: 2.w, top: 1.h),
        Container(
            width: 6.w,
            child: Container(
                width: 6.w,
                child: Container(
                    width: 15.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            child: AutoSizeText(
                                "Produto: " +
                                    findProduct(Controller
                                        .to.checklist.productId!.value),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                )),
                                maxLines: 2,
                                maxFontSize: 14,
                                textAlign: TextAlign.start)),
                        Container(
                            child: AutoSizeText(
                                "Setor: " +
                                    Controller.to.checklist.sector!.value!,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                )),
                                maxLines: 2,
                                maxFontSize: 14,
                                textAlign: TextAlign.start)),
                      ],
                    )))).marginOnly(top: 5.h),
        Container(
                width: 6.w,
                child: AutoSizeText('Questões: ',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start))
            .marginOnly(top: 5.h, left: 2.w),
        Get.Obx(() => Container(
              child: Column(children: buildQuestions(Controller.to.checklist)),
            )).marginOnly(top: 5.h),
        Container(
                width: 6.w,
                child: AutoSizeText('Pessoas Interessadas: ',
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start))
            .marginOnly(top: 3.h, left: 2.w),
        Get.Obx(
          () => Container(
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildEmails(Controller.to.checklist))
                  .marginOnly(top: 3.h, left: 1.w)),
        ),
      ],
    );
  }

  String findProduct(int value) {
    var products = Controller.to.getProductsList();
    String product = '';
    for (var item in products) {
      if (item.id == value) {
        product = item.name!.value!;
      }
    }
    return product;
  }

  buildEmails(CheckListSkeletonReactive checklist) {
    List<Container> containers = [];
    for (var email in checklist.interestedPartiesEmailList!) {
      containers.add(
        Container(
            width: 60.w,
            child: Row(
              children: [
                AutoSizeText("E-mail Interessado: " + email.email!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start),
                Container(
                    width: 1.w,
                    child: IconButton(
                        tooltip: "Remover",
                        onPressed: () {
                          checklist.interestedPartiesEmailList!.remove(email);
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: PersonalizedColors.errorColor,
                        )))
              ],
            )),
      );
    }
    return containers;
  }

  buildQuestions(CheckListSkeletonReactive checklist) {
    List<Row> rows = [];
    var tooltip;
    for (var question in checklist.questions!) {
      tooltip = question.tooltip;
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
            width: 15.w,
            child: AutoSizeText("Categoria: " + question.category!.value!,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  color: Colors.white,
                )),
                maxLines: 2,
                maxFontSize: 14,
                textAlign: TextAlign.start)),
        Container(
            width: 20.w,
            child: AutoSizeText("Questão: " + question.description!.value!,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  color: Colors.white,
                )),
                maxLines: 2,
                maxFontSize: 14,
                textAlign: TextAlign.start)),
        tooltip.value == null
            ? Container(
                width: 20.w,
              )
            : Container(
                width: 15.w,
                child: AutoSizeText("Dica: " + question.tooltip!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start)),
        Container(
            width: 5.w,
            child: IconButton(
                tooltip: "Remover",
                onPressed: () {
                  checklist.questions!.remove(question);
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: PersonalizedColors.errorColor,
                )))
      ]));
    }
    return rows;
  }

  Future<void> initStorage() async {
    await GetStorage.init();
  }
}
