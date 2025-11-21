import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';

import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/ItemDrawer.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/Utils/Drawers/AppDrawer.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/Translator.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:projeto_kva/View/FillStatusOfProduct.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as ResponsiveSizer;

import '../Utils/Constansts.dart';

class AnswerChecklist extends StatelessWidget {
  const AnswerChecklist(
      {Key? key,
      required this.checkListSkeletonReactive,
      required this.firstTime,
      required this.batch,
      required this.versionNumber})
      : super(key: key);
  final CheckListSkeletonReactive checkListSkeletonReactive;
  final bool firstTime;
  final String batch;
  final String versionNumber;

  @override
  Widget build(BuildContext context) {
    List<ItemDrawer> items = Controller.to.items;
    Controller.to.batch = batch.obs;
    Controller.to.productVersion = versionNumber.obs;
    return firstTime == false
        ? Scaffold(
            backgroundColor: PersonalizedColors.skyBlue,
            appBar: new AppBar(
              backgroundColor: PersonalizedColors.skyBlue,
            ),
            drawer: AppDrawer(
              items: items,
              title: 'Painel ',
            ),
            body: LayoutBuilder(builder: (context, constrainsts) {
              return OrientationBuilder(builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? buildPage(constrainsts.maxHeight, constrainsts.maxWidth,
                        true, checkListSkeletonReactive, context)
                    : buildPage(constrainsts.maxHeight, constrainsts.maxWidth,
                        false, checkListSkeletonReactive, context);
              });
            }))
        : LayoutBuilder(builder: (context, constrainsts) {
            return OrientationBuilder(builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? buildPage(constrainsts.maxHeight, constrainsts.maxWidth,
                      true, checkListSkeletonReactive, context)
                  : buildPage(constrainsts.maxHeight, constrainsts.maxWidth,
                      false, checkListSkeletonReactive, context);
            });
          });
  }

  buildPage(
      double height,
      double width,
      bool small,
      CheckListSkeletonReactive checkListSkeletonReactive,
      BuildContext context) {
    initStorage();
    final box = GetStorage();
    CheckListAnswerReactive checkListAnswer =
        Translator.checkListSkeletonReactiveToCheckListAnswerReactive(
            checkListSkeletonReactive);
    ScrollController scrollController = ScrollController();
    Controller.to.getAllCause();

    List<String> optionsQualityControll = [
      'Atualização da Engenharia',
      'Retorno de Demonstração',
      'Devolução de Venda',
      'Verificação da Engenharia',
      'Produção',
      'Produção Retrabalho',
      'Assistência Técnica',
      'Outros',
    ];

    List<String> enviromentsOptions = [
      'Jiga de Testes',
      'Gerador',
      'Outros',
    ];
    String auxOption =
        box.read('origin') != null ? box.read('origin') : 'Outros';
    String enviromentOption =
        box.read('enviroment') != null ? box.read('enviroment') : 'Outros';
    optionsQualityControll.sort();
    enviromentsOptions.sort();
    RxString optionQualityValue = auxOption.obs;
    RxString optionEnviroment = enviromentOption.obs;

    List<QuestionAnswerReactive> listQuestionsSplitedByCategory =
        splitQuestionsByCategory(checkListAnswer.questions!);

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
    checkListAnswer.origin = optionQualityValue;
    return Column(
      children: [
        Container(
            child: AutoSizeText(
          checkListAnswer.title!.value!,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
            color: Colors.white,
          )),
          maxLines: 1,
          maxFontSize: 16,
          minFontSize: 12,
        )).marginOnly(top: height * .02, bottom: height * 0.02),
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Container(
                width: ResponsiveSizer.Device.screenType ==
                        ResponsiveSizer.ScreenType.mobile
                    ? 55.w
                    : 25.w,
                height: 6.h,
                child: TextFormField(
                  autofocus: false,
                  initialValue: box.read('version'),
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  decoration: InputDecoration(
                    hintText: "Versão",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Versão',
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
                    box.write('version', value);
                    checkListAnswer.productVersion = value.obs;
                    Controller.to.productVersion = value.obs;
                  },
                ),
              ),
              Controller.to.user.sector!.value != Constants.assistencia
                  ? Container(
                      width: ResponsiveSizer.Device.screenType ==
                              ResponsiveSizer.ScreenType.mobile
                          ? 55.w
                          : 25.w,
                      height: 6.h,
                      child: TextFormField(
                          autofocus: false,
                          initialValue: box.read('batch'),
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          decoration: InputDecoration(
                            hintText: "Lote",
                            border: outlineInputBorder,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Lote',
                            labelStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            )),
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
                            box.write('batch', value);

                            checkListAnswer.batch = value.obs;
                            Controller.to.batch = value.obs;
                          }),
                    )
                  : Container(),
              Container(
                  width: ResponsiveSizer.Device.screenType ==
                          ResponsiveSizer.ScreenType.mobile
                      ? 55.w
                      : 25.w,
                  height: 6.h,
                  child: TextFormField(
                    autofocus: false,
                    style: GoogleFonts.montserrat(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 14)),
                    decoration: InputDecoration(
                      hintText: "Número de Série",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Número de Série',
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
                    onChanged: (value) =>
                        checkListAnswer.serieNumber = value.obs,
                  )),
            ])).marginOnly(
            left: width * 0.1, right: width * 0.1, bottom: height * .02),
        Controller.to.user.sector!.value == Constants.controleDeQualidade ||
                Controller.to.user.sector!.value == Constants.inspecaoVisual ||
                Controller.to.user.sector!.value == Constants.producao
            ? Container(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Container(
                      width: ResponsiveSizer.Device.screenType ==
                              ResponsiveSizer.ScreenType.mobile
                          ? 55.w
                          : 25.w,
                      height: 6.5.h,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Origem',
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          )),
                          border: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          focusedBorder: enableBorder,
                        ),
                        onChanged: (String? value) {
                          box.write('origin', value);
                          optionQualityValue.value = value!;
                          checkListAnswer.origin = optionQualityValue;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return optionsQualityControll
                              .map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },
                        items: optionsQualityControll.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: optionQualityValue.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: true,
                      ),
                    ),
                  ),
                  Controller.to.user.sector!.value ==
                          Constants.controleDeQualidade
                      ? Obx(
                          () => Container(
                            width: ResponsiveSizer.Device.screenType ==
                                    ResponsiveSizer.ScreenType.mobile
                                ? 55.w
                                : 25.w,
                            height: 6.h,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Ambiente de testes',
                                labelStyle: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                                border: outlineInputBorder,
                                enabledBorder: outlineInputBorder,
                                focusedBorder: enableBorder,
                              ),
                              onChanged: (String? value) {
                                box.write('enviroment', value);
                                optionEnviroment.value = value!;
                                checkListAnswer.testEnvironment =
                                    optionEnviroment;
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return enviromentsOptions
                                    .map<Widget>((String item) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: CommonWidgets.buildText(item, 14,
                                        Colors.white, TextAlign.center),
                                  );
                                }).toList();
                              },
                              items: enviromentsOptions.map((String option) {
                                return DropdownMenuItem(
                                  child: CommonWidgets.buildText(option, 14,
                                      Colors.white, TextAlign.center),
                                  value: option,
                                );
                              }).toList(),
                              value: optionEnviroment.value,
                              dropdownColor: PersonalizedColors.skyBlue,
                              isExpanded: true,
                              isDense: true,
                            ),
                          ),
                        )
                      : Container()
                ],
              )).marginOnly(
                left: width * 0.1, right: width * 0.1, bottom: height * .02)
            : Container(),
        Container(
            child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                textBaseline: TextBaseline.alphabetic,
                columnWidths: {
              0: FlexColumnWidth(width * 0.1),
              1: FlexColumnWidth(width * 0.2),
              2: FlexColumnWidth(width * 0.05),
              3: FlexColumnWidth(width * 0.01),
              4: FlexColumnWidth(width * 0.05)
            },
                children: [
              TableRow(children: [
                TableCell(child: Container()),
                TableCell(child: Container()),
                TableCell(
                    child: Container(
                        child: AutoSizeText(
                  "Aprovado",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                    color: Colors.white,
                  )),
                  maxLines: 1,
                  maxFontSize: 14,
                  minFontSize: 08,
                ))),
                TableCell(child: Container()),
                TableCell(
                    child: Container(
                        child: AutoSizeText(
                  "Reprovado",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                    color: Colors.white,
                  )),
                  maxLines: 1,
                  maxFontSize: 14,
                  minFontSize: 08,
                ))),
              ])
            ])).paddingOnly(
            left: width * 0.05,
            right: width * 0.05,
            top: height * 0.02,
            bottom: height * 0.05),
        Expanded(
          child: Scrollbar(
            interactive: true,
            trackVisibility: true,

            controller: scrollController, // <---- Here, the controller
            child: ListView(
                controller:
                    scrollController, // <---- Same as the Scrollbar controller
                children: [
                  Container(
                      child: buildQuestions(
                          height,
                          width,
                          small,
                          listQuestionsSplitedByCategory,
                          context,
                          checkListSkeletonReactive,
                          checkListAnswer,
                          checkListAnswer.batch!.value!,
                          checkListAnswer.productVersion!.value!)),
                  Container(
                    width: small == true ? width * .7 : width * .25,
                    height: height * .07,
                    child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        hintText: "Observação",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Observação',
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
                      onChanged: (value) =>
                          checkListAnswer.observation = value.obs,
                    ),
                  ).paddingOnly(
                    left: width * .2,
                    right: width * .2,
                    top: height * .02,
                  ),
                  Container(
                          width: small ? width * .3 : width * .25,
                          height: height * .07,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      PersonalizedColors.lightGreen,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(60.0),
                                  )),
                              onPressed: () {
                                checkListAnswer.sector == Constants.assistencia
                                    ? checkListAnswer.batch!.value = ''
                                    : checkListAnswer.batch!.value != ""
                                        ? checkListAnswer.batch!.value!
                                        : checkListAnswer.batch = batch.obs;
                                checkListAnswer.productVersion!.value != ""
                                    ? checkListAnswer.productVersion!.value!
                                    : checkListAnswer.productVersion =
                                        versionNumber.obs;
                                checkListAnswer.sector !=
                                        Constants.controleDeQualidade
                                    ? checkListAnswer.testEnvironment != null
                                        ? checkListAnswer
                                                    .testEnvironment!.value !=
                                                ""
                                            ? checkListAnswer
                                                .testEnvironment!.value!
                                            : checkListAnswer.testEnvironment =
                                                enviromentOption.obs
                                        : checkListAnswer.testEnvironment =
                                            enviromentOption.obs
                                    : checkListAnswer.testEnvironment == null;
                                checkListAnswer.sector !=
                                        Constants.controleDeQualidade
                                    ? checkListAnswer.testEnvironment != null
                                        ? checkListAnswer
                                                    .testEnvironment!.value !=
                                                ""
                                            ? checkListAnswer
                                                .testEnvironment!.value!
                                            : checkListAnswer.testEnvironment =
                                                enviromentOption.obs
                                        : checkListAnswer.testEnvironment =
                                            enviromentOption.obs
                                    : checkListAnswer.origin == null;

                                bool verified = verifyFields(
                                    width,
                                    height,
                                    small,
                                    context,
                                    checkListSkeletonReactive,
                                    checkListAnswer.batch!.value!,
                                    checkListAnswer.productVersion!.value!,
                                    checkListAnswer,
                                    isComplete(checkListAnswer));
                                bool isReproved = false;
                                for (var question
                                    in checkListAnswer.questions!) {
                                  if (question.disapproved!.value == true ||
                                      (question.disapproved!.value == false &&
                                          question.approved!.value == false)) {
                                    isReproved = true;
                                    break;
                                  }
                                }
                                if (verified) {
                                  if (!isReproved) {
                                    checkListAnswer.statusOfCheckList =
                                        'Aprovado';
                                    checkListAnswer.date = new DateTime.now();
                                    checkListAnswer.nameOfUser =
                                        Controller.to.user.name!;

                                    Controller.to
                                        .saveCheckListAnswer(checkListAnswer);
                                    Get.back();
                                    Get.to(() => AnswerChecklist(
                                        checkListSkeletonReactive:
                                            checkListSkeletonReactive,
                                        batch: checkListAnswer.batch!.value!,
                                        versionNumber: checkListAnswer
                                            .productVersion!.value!,
                                        firstTime: false));
                                  } else {
                                    if (isComplete(checkListAnswer)) {
                                      buildDialog(
                                          width,
                                          height,
                                          small,
                                          context,
                                          checkListSkeletonReactive,
                                          checkListAnswer.batch!.value!,
                                          checkListAnswer
                                              .productVersion!.value!,
                                          checkListAnswer);
                                    } else {
                                      Get.dialog(AlertDialog(
                                        actionsOverflowButtonSpacing: 50,
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        PersonalizedColors
                                                            .lightGreen,
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(60.0),
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
                                                    backgroundColor:
                                                        PersonalizedColors
                                                            .redAccent,
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(60.0),
                                                    )),
                                                onPressed: () {
                                                  Get.back();
                                                  buildDialog(
                                                      width,
                                                      height,
                                                      small,
                                                      context,
                                                      checkListSkeletonReactive,
                                                      checkListAnswer
                                                          .batch!.value!,
                                                      checkListAnswer
                                                          .productVersion!
                                                          .value!,
                                                      checkListAnswer);
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
                                        backgroundColor:
                                            PersonalizedColors.blueGrey,
                                        title: Text(
                                          'Ainda há itens sem testar. Deseja finalizar o checklist?',
                                          textAlign: TextAlign.center,
                                        ),
                                        titleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ));
                                    }
                                  }
                                } else
                                  Controller.to.snackbar(
                                      "Por favor preencha todos os campos",
                                      'Erro',
                                      Colors.red[200]!);
                              },
                              child: CommonWidgets.buildText("Salvar", 14,
                                  Colors.white, TextAlign.center)))
                      .paddingOnly(
                          left: width * .4,
                          right: width * .4,
                          top: height * .02,
                          bottom: height * 0.02),
                ]).paddingOnly(
              left: width * 0.05,
              right: width * 0.05,
            ),
          ),

          // ...
        ),
      ],
    );
  }

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  splitQuestionsByCategory(List<QuestionAnswerReactive> questionList) {
    questionList.sort((a, b) =>
        int.parse(a.position!.value!).compareTo(int.parse(b.position!.value!)));

    return questionList;
  }

  buildQuestions(
      double height,
      double width,
      bool small,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
      BuildContext context,
      CheckListSkeletonReactive skeleton,
      CheckListAnswerReactive answer,
      String batchValue,
      String versionNumberValue) {
    String category = "A";

    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      TableCell(
          child: Container(
        height: height * 0.02,
      )),
      TableCell(child: Container()),
      TableCell(child: Container()),
      TableCell(child: Container()),
      TableCell(child: Container()),
    ]));
    for (QuestionAnswerReactive question in listQuestionsSplitedByCategory) {
      question.approved = false.obs;
      question.disapproved = false.obs;

      buildCategoryWidget(category, question, rows, width);

      buildQuestionWidget(rows, question, height, width, small, context,
          skeleton, answer, batchValue, versionNumberValue);

      category == question.category!.value!
          ? category = category
          : category = question.category!.value!;
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      textBaseline: TextBaseline.alphabetic,
      columnWidths: {
        0: FlexColumnWidth(width * 0.1),
        1: FlexColumnWidth(width * 0.2),
        2: FlexColumnWidth(width * 0.05),
        3: FlexColumnWidth(width * 0.01),
        4: FlexColumnWidth(width * 0.05)
      },
      children: rows,
    );
  }

  void buildQuestionWidget(
      List<TableRow> rows,
      QuestionAnswerReactive question,
      double height,
      double width,
      small,
      BuildContext context,
      CheckListSkeletonReactive skeleton,
      CheckListAnswerReactive answer,
      String batchValue,
      String versionNumberValue) {
    final box = GetStorage();
    rows.add(TableRow(
      children: [
        TableCell(
          child: Container(),
        ),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Container(
              height: 2.h,
              child: Tooltip(
                message: question.tooltip!.value!,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.circular(90)),
                preferBelow: false,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                textStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
                child: AutoSizeText(question.description!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start),
              ),
            ).marginOnly(bottom: 2.h, top: 2.h)),
        TableCell(
            child: Container(
          width: width * 0.01,
          child: Obx(() => Checkbox(
              value: question.approved!.value!,
              activeColor: PersonalizedColors.lightGreen,
              tristate: false,
              onChanged: (value) {
                question.approved!.value = value!;
                question.disapproved!.value = false;
              })),
        )),
        TableCell(child: Container()),
        TableCell(
            child: Container(
          width: width * 0.01,
          child: Obx(() => Checkbox(
                value: question.disapproved!.value!,
                tristate: false,
                activeColor: PersonalizedColors.errorColor,
                onChanged: (value) {
                  question.disapproved!.value = value!;
                  question.approved!.value = false;

                  /* if (saved) {
                    buildNewPage(saved, answer);*/
                },
              )),
        )),
      ],
    ));
  }

  buildDialog(
      double width,
      double height,
      small,
      BuildContext context,
      CheckListSkeletonReactive skeleton,
      String batchValue,
      String versionNumberValue,
      CheckListAnswerReactive checkListAnswer) async {
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
    List<String> causeList = Controller.to.buildCauseListList().length > 0
        ? Controller.to.buildCauseListList()
        : ['Não há causa cadastrada'];

    causeList.sort();

    RxString cause =
        causeList.length > 0 ? causeList[0].obs : 'Não há causa cadastrada'.obs;
    showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.8,
        maxHeight: 1,
        context: context,
        builder: (
          BuildContext context,
          ScrollController scrollController,
          double bottomSheetOffset,
        ) {
          RxString redirect = Constants.assistencia.obs;
          checkListAnswer.redirectTo = redirect.value;
          var redirectList = <String>[
            Constants.assistencia,
            Constants.producao,
            Constants.inspecaoFinal
          ];

          return Center(
              child: SafeArea(
            bottom: false,
            child: Material(
              color: PersonalizedColors.skyBlue,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: small == true ? width * .7 : width * .25,
                    height: height * .12,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 10,
                      autofocus: false,
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        hintText: 'Motivo da Reprova',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Motivo da Reprova',
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
                      onChanged: (value) =>
                          checkListAnswer.statusOfProduct = value,
                    ),
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
                          // Not necessary for Option 1
                          onChanged: (newValue) {
                            checkListAnswer.cause = newValue.toString();
                            cause.value = newValue.toString();
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return causeList.map<Widget>((String item) {
                              return Container(
                                alignment: Alignment.center,
                                child: CommonWidgets.buildText(
                                    item, 14, Colors.white, TextAlign.center),
                              );
                            }).toList();
                          },

                          items: causeList.map((String option) {
                            return DropdownMenuItem(
                              child: CommonWidgets.buildText(
                                  option, 14, Colors.white, TextAlign.center),
                              value: option,
                            );
                          }).toList(),
                          value: cause.value!,
                          dropdownColor: PersonalizedColors.skyBlue,
                          isExpanded: true,
                          isDense: false,
                          underline: SizedBox(),
                        ).marginOnly(
                          left: 10,
                          right: 10,
                        ),
                      )).marginOnly(left: width * .2, right: width * .2),
                  Container(
                    height: height * .02,
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
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Encaminhar para:',
                            labelStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            )),
                          ),
                          // Not necessary for Option 1
                          onChanged: (String? newValue) {
                            redirect.value = newValue!;
                            checkListAnswer.redirectTo = redirect.value;
                          },

                          selectedItemBuilder: (BuildContext context) {
                            return redirectList.map<Widget>((String item) {
                              return Container(
                                alignment: Alignment.center,
                                child: CommonWidgets.buildText(
                                    item, 14, Colors.white, TextAlign.center),
                              );
                            }).toList();
                          },

                          items: redirectList.map((String option) {
                            return DropdownMenuItem(
                              child: CommonWidgets.buildText(
                                  option, 14, Colors.white, TextAlign.center),
                              value: option,
                            );
                          }).toList(),
                          value: redirect.value,
                          dropdownColor: PersonalizedColors.skyBlue,
                          isExpanded: true,

                          isDense: false,
                        ).marginOnly(
                          left: 10,
                          right: 10,
                        ),
                      )),
                  Container(
                    height: height * .02,
                  ),
                  Container(
                      width: small == true ? width * .25 : width * .15,
                      height: height * .05,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: PersonalizedColors.lightGreen,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                              )),
                          onPressed: () {
                            checkListAnswer.statusOfCheckList = 'Reprovado';
                            checkListAnswer.date = new DateTime.now();

                            checkListAnswer.nameOfUser =
                                Controller.to.user.name!;
                            Controller.to.saveCheckListAnswer(checkListAnswer);
                            checkListAnswer.serieNumber = ''.obs;
                            Get.back();
                            Get.to(FillStatusOfProduct());
                            Get.to(AnswerChecklist(
                                checkListSkeletonReactive: skeleton,
                                firstTime: false,
                                batch: checkListAnswer.batch!.value!,
                                versionNumber:
                                    checkListAnswer.productVersion!.value!));
                          },
                          child: CommonWidgets.buildText(
                              "Salvar ", 14, Colors.white, TextAlign.center)))
                ],
              ),
            ),
          ));
        },
        anchors: [0, 0.5, 1],
        isCollapsible: true,
        isExpand: false,
        isModal: true);
  }
}

bool isComplete(CheckListAnswerReactive checkListAnswer) {
  bool complete = true;
  for (QuestionAnswerReactive question in checkListAnswer.questions!) {
    if (question.disapproved!.value == false && question.approved == false) {
      complete = false;
      break;
    }
  }
  return complete;
}

void buildCategoryWidget(String category, QuestionAnswerReactive question,
    List<TableRow> rows, double width) {
  category.trim() == question.category!.value!.trim()
      ? rows.isEmpty
          ? rows.add(TableRow(children: [
              TableCell(
                  child: Container(
                      child: AutoSizeText(
                question.category!.value!,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  color: Colors.white,
                )),
                maxLines: 1,
                maxFontSize: 14,
                minFontSize: 08,
              ))),
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container())
            ]))
          : TableRow(children: [
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container())
            ])
      : rows.add(TableRow(children: [
          TableCell(
              child: Container(
                  child: AutoSizeText(
            question.category!.value!,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              color: Colors.white,
            )),
            maxLines: 1,
            maxFontSize: 14,
            minFontSize: 08,
          ))),
          TableCell(child: Container()),
          TableCell(child: Container()),
          TableCell(child: Container()),
          TableCell(child: Container())
        ]));
}

bool verifyFields(
    double width,
    double height,
    small,
    BuildContext context,
    CheckListSkeletonReactive skeleton,
    String batchValue,
    String versionNumberValue,
    CheckListAnswerReactive checkListAnswer,
    bool complete) {
  if (Constants.assistencia == Controller.to.user.sector!.value) {
    if (checkListAnswer.serieNumber != null &&
        checkListAnswer.productVersion != null) {
      if (checkListAnswer.serieNumber!.value!.isNotEmpty &&
          checkListAnswer.productVersion!.value!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    if (checkListAnswer.batch != null &&
        checkListAnswer.serieNumber != null &&
        checkListAnswer.productVersion != null) {
      if (checkListAnswer.batch!.value!.isNotEmpty &&
          checkListAnswer.serieNumber!.value!.isNotEmpty &&
          checkListAnswer.productVersion!.value!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
