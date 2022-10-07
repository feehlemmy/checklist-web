import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:universal_html/html.dart' as html;

class DeleteChecklist extends StatelessWidget {
  DeleteChecklist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: Controller.to.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: LayoutBuilder(builder: (context, constrainsts) {
                    return OrientationBuilder(builder: (context, orientation) {
                      return orientation == Orientation.portrait
                          ? buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, true, context)
                          : buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, false, context);
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

  buildPage(double height, double width, bool small, BuildContext context) {
    var items = <String>["Lote", 'Número de Série', 'Data'];

    var status = <String>["Todos", 'Aprovado', 'Retrabalhado', 'Reprovado'];

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

    items.sort();
    status.sort();

    RxString parameter = "".obs;
    ScrollController scrollController = ScrollController();

    RxString optionValue = 'Lote'.obs;
    RxString statusValue = 'Todos'.obs;

    List<String> productNameList = Controller.to.productNameList.length > 0
        ? Controller.to.buildProductNameList()
        : ['Não há produto cadastrado'];
    if (Controller.to.buildProductNameList().length > 0) {
      productNameList.add('Todos');
    }
    productNameList.sort();
    RxString productName = 'Todos'.obs;
    productName = productNameList.length > 0
        ? productNameList[0].obs
        : 'Não há produto cadastrado'.obs;
    RxList<Obx> cards = RxList.empty(growable: true);
    var buttonAllPdf = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: small == true ? width * .15 : width * .15,
            height: height * .065,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(60.0),
                    )),
                onPressed: () {
                  generateAllPdf(
                      Controller.to.ansewersListReactive, height, width);
                },
                child: CommonWidgets.buildText("Exportar todos Checklists", 14,
                    PersonalizedColors.skyBlue, TextAlign.center))),
      ],
    ).marginOnly(top: height * 0.02);

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Wrap(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 11.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        onChanged: (String? newValue) {
                          productName.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return productNameList.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },
                        items: productNameList.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: productName.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ),
                    Container(
                      width: small == true ? width * .2 : width * .11,
                      height: height * .07,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        // Not necessary for Option 1
                        onChanged: (String? newValue) {
                          optionValue.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return items.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },

                        items: items.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: optionValue.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ).marginOnly(left: width * 0.02),
                    Container(
                      width: 11.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        onChanged: (String? newValue) {
                          statusValue.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return status.map<Widget>((String status) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(statusValue.value,
                                  14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },
                        items: status.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: statusValue.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ).marginOnly(left: width * 0.02),
                    optionValue.value != "Data"
                        ? Container(
                            width: small == true ? width * .12 : width * .15,
                            height: height * .1,
                            child: Container(
                              height: height * .1,
                              child: TextFormField(
                                autofocus: false,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                decoration: InputDecoration(
                                  hintText: "Pesquisar",
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
                                onChanged: (value) => parameter.value = value,
                              ),
                            ),
                          ).marginOnly(left: width * 0.02, top: height * 0.035)
                        : Row(
                            children: [
                              Container(
                                  width:
                                      small == true ? width * .1 : width * .11,
                                  height: height * .07,
                                  child: DateTimePicker(
                                      autovalidate: false,
                                      type: DateTimePickerType.date,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: PersonalizedColors.blueGrey,
                                            width: 1.0,
                                          ),
                                        ),
                                        hintStyle: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                textBaseline:
                                                    TextBaseline.alphabetic)),
                                        hintText: 'Data Inicial',
                                        alignLabelWithHint: true,
                                        isCollapsed: false,
                                        icon: Icon(Icons.event,
                                            color: Colors.white),
                                      ),
                                      dateMask: 'dd/MM/yyyy',
                                      firstDate: DateTime(2021),
                                      cursorRadius: Radius.circular(90),
                                      lastDate: DateTime(2100),
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      )),
                                      textAlign: TextAlign.center,
                                      icon: Icon(Icons.event,
                                          color: Colors.white),
                                      timeLabelText: "Hora",
                                      locale: (Locale('pt', 'BR')),
                                      onChanged: (val) {
                                        Controller.to.initialDate =
                                            DateTime.parse(val);
                                      })).marginOnly(left: width * 0.02),
                              Container(
                                  width:
                                      small == true ? width * .1 : width * .11,
                                  height: height * .07,
                                  child: DateTimePicker(
                                      autovalidate: false,
                                      type: DateTimePickerType.date,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: PersonalizedColors.blueGrey,
                                            width: 1.0,
                                          ),
                                        ),
                                        hintStyle: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                textBaseline:
                                                    TextBaseline.alphabetic)),
                                        hintText: 'Data Final',
                                        alignLabelWithHint: true,
                                        isCollapsed: false,
                                        icon: Icon(Icons.event,
                                            color: Colors.white),
                                      ),
                                      dateMask: 'dd/MM/yyyy',
                                      firstDate: DateTime(2000),
                                      cursorRadius: Radius.circular(90),
                                      lastDate: DateTime(2100),
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      )),
                                      textAlign: TextAlign.center,
                                      icon: Icon(Icons.event,
                                          color: Colors.white),
                                      timeLabelText: "Hora",
                                      locale: (Locale('pt', 'BR')),
                                      onChanged: (val) {
                                        Controller.to.endDate =
                                            DateTime.parse(val);
                                        Controller.to.endDate =
                                            Controller.to.endDate!.add(Duration(
                                                hours: 23, minutes: 59));
                                      })).marginOnly(left: width * 0.02),
                            ],
                          ),
                    Container(
                      width: small == true ? width * .05 : width * .05,
                      height: height * .065,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: PersonalizedColors.lightGreen,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                              )),
                          onPressed: () async {
                            cards.value = [];
                            Controller.to.visible.value = true;
                            Controller.to.countSearch.value = 0;
                            await Controller.to.searchResponseCheckList(
                                productName.value!,
                                optionValue.value!,
                                parameter.value!,
                                null,
                                null,
                                statusValue.value!,
                                'Todos');

                            if (Controller.to.ansewersListReactive.isEmpty) {
                              Controller.to.visible.value = false;
                              Controller.to.allPdf.value = false;
                              Controller.to.snackbar(
                                  'Por favor verifique os parâmetros de busca',
                                  'Não foi possível encontrar checklists',
                                  PersonalizedColors.errorColor);
                            } else {
                              Controller.to.visible.value = false;
                              cards.value = buildCards(
                                  height, width, small, cards, context);
                              Controller.to.countSearch.value =
                                  Controller.to.ansewersListReactive.length;

                              if (optionValue.value == 'Número de Série' &&
                                  Controller.to.countSearch.value > 0) {
                                Controller.to.allPdf.value = true;
                              } else {
                                Controller.to.allPdf.value = false;
                              }
                            }
                          },
                          child: CommonWidgets.buildText(
                              "Buscar", 14, Colors.white, TextAlign.center)),
                    ).marginOnly(left: width * 0.02),
                    Obx(() => Controller.to.countSearch.value > 0
                        ? Container(
                            width: small == true ? width * .08 : width * .08,
                            child: CommonWidgets.buildText(
                                "Itens Encontrados: " +
                                    Controller.to.ansewersListReactive.length
                                        .toString(),
                                14,
                                Colors.white,
                                TextAlign.center),
                          ).marginOnly(left: width * 0.01)
                        : Container())
                  ],
                )
              ]).marginOnly(
                  top: height * 0.05, left: width * 0.08, right: width * 0.08)),
          Obx(() =>
              Controller.to.allPdf.value != false ? buttonAllPdf : Container()),
          Expanded(
              child: Scrollbar(
                  interactive: true,
                  showTrackOnHover: true,
                  controller: scrollController, // <---- Here, the controller
                  isAlwaysShown: true,
                  child: ListView(
                      controller:
                          scrollController, // <---- Same as the Scrollbar controller
                      children: [
                        Obx(() => Controller.to.visible.value == true
                            ? Container(
                                alignment: Alignment.bottomCenter,
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                      angleRange: 360,
                                      spinnerMode: true,
                                      size: 80,
                                      customColors: CustomSliderColors(
                                          progressBarColor:
                                              PersonalizedColors.darkGreen)),
                                )).marginOnly(top: height * 0.2)
                            : GridView.count(
                                    shrinkWrap: true,
                                    addRepaintBoundaries: true,
                                    childAspectRatio: 1.6,
                                    crossAxisCount: small == true ? 2 : 3,
                                    padding: EdgeInsets.all(20),
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    // ignore: invalid_use_of_protected_member
                                    children: cards.value)
                                .marginOnly(
                                    left: width * .1, right: width * .1))
                      ]))),
        ]);
  }

  buildCards(double height, double width, bool small, List<Obx> cards,
      BuildContext context) {
    cards = [];

    for (CheckListAnswerReactive checklistSkeletonAux
        in Controller.to.ansewersListReactive) {
      final checklist = checklistSkeletonAux.obs;
      Color color = checklist.value!.statusOfCheckList! == "Aprovado"
          ? PersonalizedColors.darkGreen
          : checklist.value!.statusOfCheckList! == "Retrabalhado" ||
                  checklist.value!.statusOfCheckList! == "Retrabalho"
              ? PersonalizedColors.warningColor
              : PersonalizedColors.errorColor;
      cards.add(
        Obx(
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
                  CommonWidgets.buildText(checklist.value!.title!.value!, 12,
                      Colors.white, TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidgets.buildText(
                          "Nº de Série: ", 14, Colors.white, TextAlign.center),
                      CommonWidgets.buildText(
                          checklist.value!.serieNumber!.value!,
                          14,
                          Colors.white,
                          TextAlign.center),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidgets.buildText(
                          "Lote: ", 14, Colors.white, TextAlign.center),
                      CommonWidgets.buildText(checklist.value!.batch!.value!,
                          14, Colors.white, TextAlign.center),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidgets.buildText(
                          "Data: ", 14, Colors.white, TextAlign.center),
                      CommonWidgets.buildText(
                          CommonWidgets.getFormatter()
                              .format(checklist.value!.date!),
                          14,
                          Colors.white,
                          TextAlign.center),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidgets.buildText(
                          "Setor: ", 14, Colors.white, TextAlign.center),
                      CommonWidgets.buildText(checklist.value!.sector!.value!,
                          14, Colors.white, TextAlign.center),
                    ],
                  ),
                  Container(
                    height: 0.5,
                  ),
                  CommonWidgets.buildText(checklist.value!.statusOfCheckList!,
                      14, color, TextAlign.center),
                  Container(
                    height: 0.5,
                  ),
                ],
              ),
            ),
            onTap: () {
              showCheckList(checklist.value!, context, height, width, small,
                  splitQuestionsByCategory(checklist.value!.questions!));
            },
          ),
        ),
      );
    }
    return cards;
  }

  splitQuestionsByCategory(List<QuestionAnswerReactive> questionList) {
    questionList.sort((a, b) =>
        int.parse(a.position!.value!).compareTo(int.parse(b.position!.value!)));

    return questionList;
  }

  final formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');
  void showCheckList(
      CheckListAnswerReactive checkListAnswer,
      BuildContext context,
      double height,
      double width,
      bool small,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory) {
    Get.bottomSheet(
        buildCompleteCheckList(checkListAnswer, width, small, height,
            listQuestionsSplitedByCategory, true),
        isDismissible: true,
        enableDrag: true,
        elevation: 0,
        backgroundColor: PersonalizedColors.skyBlue);
  }

  buildCompleteCheckList(
      CheckListAnswerReactive checkListAnswer,
      double width,
      bool small,
      double height,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
      bool needPdf) {
    ScrollController scrollController = ScrollController();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: AutoSizeText(checkListAnswer.title!.value!,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                      color: Colors.white,
                    )),
                    maxLines: 2,
                    maxFontSize: 14,
                    textAlign: TextAlign.start)),
            Container(
              width: width * 0.1,
              child: IconButton(
                  onPressed: () =>
                      showConfirmation(small, width, height, checkListAnswer),
                  icon: Tooltip(
                    message: "Excluir Checklist",
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )),
            ),
          ],
        ).marginOnly(left: width * 0.02),
        Container(
            width: width * 0.8,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                          width: width * 0.25,
                          child: AutoSizeText(
                              "Lote: " + checkListAnswer.batch!.value!,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start))
                      .marginOnly(top: height * 0.02),
                  Container(
                      width: width * 0.25,
                      child: AutoSizeText(
                          "Nº de Série: " + checkListAnswer.serieNumber!.value!,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            color: Colors.white,
                          )),
                          maxLines: 2,
                          maxFontSize: 14,
                          textAlign: TextAlign.start)),
                  Container(
                      width: width * 0.25,
                      child: AutoSizeText(
                          "Versão: " + checkListAnswer.productVersion!.value!,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            color: Colors.white,
                          )),
                          maxLines: 2,
                          maxFontSize: 14,
                          textAlign: TextAlign.start)),
                ])).marginOnly(top: height * 0.02),
        Container(
            width: width * 0.8,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: width * 0.25,
                      child: AutoSizeText(
                          "Reponsável: " + checkListAnswer.nameOfUser!.value!,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            color: Colors.white,
                          )),
                          maxLines: 2,
                          maxFontSize: 14,
                          textAlign: TextAlign.start)),
                  Container(
                      width: width * 0.2,
                      child: AutoSizeText(
                          "Data: " + formatter.format(checkListAnswer.date!),
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            color: Colors.white,
                          )),
                          maxLines: 2,
                          maxFontSize: 14,
                          textAlign: TextAlign.start)),
                  Container(
                      width: width * 0.3,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                  child: AutoSizeText(
                                      "Setor: " +
                                          checkListAnswer.sector!.value!,
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                      )),
                                      maxLines: 2,
                                      maxFontSize: 14,
                                      textAlign: TextAlign.start)),
                            ],
                          )
                        ],
                      ))
                ])).marginOnly(top: height * 0.02),
        Container(
            width: width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                checkListAnswer.origin!.value! != ""
                    ? Container(
                        width: width * 0.25,
                        child: AutoSizeText(
                            "Origem: " + checkListAnswer.origin!.value!,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              color: Colors.white,
                            )),
                            maxLines: 2,
                            maxFontSize: 14,
                            textAlign: TextAlign.start))
                    : Container(),
                checkListAnswer.testEnvironment!.value! != ""
                    ? Container(
                        width: width * 0.25,
                        child: AutoSizeText(
                            "Ambiente de Teste: " +
                                checkListAnswer.testEnvironment!.value!,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              color: Colors.white,
                            )),
                            maxLines: 2,
                            maxFontSize: 14,
                            textAlign: TextAlign.start))
                    : Container(),
                Container(
                  width: width * .25,
                ),
              ],
            )).marginOnly(top: height * 0.02),
        checkListAnswer.statusOfCheckList! == "Retrabalhado" ||
                checkListAnswer.statusOfCheckList! == "Retrabalho"
            ? Container(
                width: width * 0.8,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: width * 0.25,
                          child: AutoSizeText(
                              "Responsável Retrabalho: " +
                                  checkListAnswer.nameOfUserAssistance!,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start)),
                      Container(
                          width: width * 0.25,
                          child: AutoSizeText(
                              "Data Retrabalho: " +
                                  formatter
                                      .format(checkListAnswer.dateAssistance!),
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start)),
                      Container(
                        width: width * 0.25,
                      )
                    ])).marginOnly(top: height * 0.02)
            : Container(),
        checkListAnswer.statusOfCheckList! == "Retrabalhado" ||
                checkListAnswer.statusOfCheckList! == "Retrabalho"
            ? Column(
                children: [
                  Container(
                    width: width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: width * 0.25,
                            child: AutoSizeText("Produto Retrabalhado: ",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  color: PersonalizedColors.warningColor,
                                )),
                                maxLines: 2,
                                maxFontSize: 14,
                                textAlign: TextAlign.start)),
                        Container(
                            width: width * 0.25,
                            child:
                                AutoSizeText("Causa: " + checkListAnswer.cause!,
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                      color: Colors.white,
                                    )),
                                    maxLines: 2,
                                    maxFontSize: 14,
                                    textAlign: TextAlign.start)),
                        Container(
                          width: width * 0.25,
                        ),
                      ],
                    ),
                  ).marginOnly(top: height * 0.02),
                  checkListAnswer.causeDescription != null
                      ? Container(
                          width: width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: width * 0.5,
                                  child: AutoSizeText(
                                      "Solução: " +
                                          checkListAnswer.causeDescription!,
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                      )),
                                      maxLines: 10,
                                      maxFontSize: 14,
                                      textAlign: TextAlign.start)),
                              Container(
                                width: width * 0.25,
                              ),
                            ],
                          )).marginOnly(top: height * 0.02)
                      : Container(),
                ],
              )
            : checkListAnswer.statusOfCheckList == "Aprovado"
                ? Container(
                    width: width * 0.8,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: width * 0.25,
                              child: AutoSizeText("Produto Aprovado",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                    color: PersonalizedColors.lightGreen,
                                  )),
                                  maxLines: 2,
                                  maxFontSize: 14,
                                  textAlign: TextAlign.start))
                        ])).marginOnly(top: height * 0.02)
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        width: width * 0.25,
                        child: AutoSizeText("Produto Reprovado",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                              color: PersonalizedColors.errorColor,
                            )),
                            maxLines: 2,
                            maxFontSize: 14,
                            textAlign: TextAlign.start))
                  ]).marginOnly(top: height * 0.02),
        Container(
          child: Expanded(
            child: Scrollbar(
              interactive: true,
              showTrackOnHover: true,

              controller: scrollController, // <---- Here, the controller
              isAlwaysShown: true,
              child: ListView(
                  controller:
                      scrollController, // <---- Same as the Scrollbar controller
                  children: [
                    Container(
                        child: buildQuestions(height, width, small,
                            listQuestionsSplitedByCategory, checkListAnswer)),
                    checkListAnswer.observation!.value! != ""
                        ? Container(
                            alignment: Alignment.centerLeft,
                            width: width * 0.25,
                            child: AutoSizeText(
                                "Observação: " +
                                    checkListAnswer.observation!.value!,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                )),
                                maxLines: 3,
                                maxFontSize: 14,
                                textAlign: TextAlign.start))
                        : Container(),
                    checkListAnswer.statusOfProduct != null
                        ? Container(
                            alignment: Alignment.centerLeft,
                            width: width * 0.25,
                            child: AutoSizeText(
                                "Motivo da Reprova: " +
                                    checkListAnswer.statusOfProduct!,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                )),
                                maxLines: 3,
                                maxFontSize: 14,
                                textAlign: TextAlign.start))
                        : Container()
                  ]).paddingOnly(
                left: width * 0.05,
                right: width * 0.05,
              ),
            ).marginOnly(bottom: height * .02),

            // ...
          ),
        ),
      ],
    );
  }

  Future<void> generatePdf(
      CheckListAnswerReactive checkListAnswer,
      double height,
      double width,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory) async {
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf")),
    );

    final pdf = pw.Document(
      theme: myTheme,
    );
    final logo = pw.MemoryImage(
      (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List(),
    );

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Center(
            child: pw.Container(width: 75, height: 75, child: pw.Image(logo))),
        build: (pw.Context context) {
          return buildPdfCheckList(
              checkListAnswer,
              PdfPageFormat.a4.width,
              false,
              PdfPageFormat.a4.height,
              listQuestionsSplitedByCategory,
              false);
// Center
        }));
    final bytes = await pdf.save();
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'CheckList' + checkListAnswer.serieNumber!.value!
      ..download = checkListAnswer.serieNumber!.value! + '.pdf';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    /*
    final file = File(checkListAnswer.serieNumber!.value! + ".pdf");
    await file.writeAsBytes(await pdf.save());
     */
  }

  Future<void> generateAllPdf(
      List<CheckListAnswerReactive> ansewersListReactive,
      double height,
      double width) async {
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(
        await rootBundle.load("assets/OpenSans-Regular.ttf"),
      ),
    );

    final pdf = pw.Document(
      theme: myTheme,
    );
    final logo = pw.MemoryImage(
      (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List(),
    );
    for (var ansewer in ansewersListReactive) {
      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) => pw.Center(
              child:
                  pw.Container(width: 75, height: 75, child: pw.Image(logo))),
          build: (pw.Context context) {
            return buildPdfCheckList(
                ansewer,
                PdfPageFormat.a4.width,
                false,
                PdfPageFormat.a4.height,
                splitQuestionsByCategory(ansewer.questions!),
                false);
// Center
          }));
    }

    final bytes = await pdf.save();
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display =
          'Vida do CheckList' + ansewersListReactive[0].serieNumber!.value!
      ..download = 'Vida do CheckList' +
          ansewersListReactive[0].serieNumber!.value! +
          '.pdf';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}

buildPdfCheckList(
    CheckListAnswerReactive checkListAnswer,
    double width,
    bool bool,
    double height,
    List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
    bool bool2) {
  return CommonWidgets.generatePdf(
      checkListAnswer, height, width, bool, listQuestionsSplitedByCategory);
}

buildQuestions(
    double height,
    double width,
    bool small,
    List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
    CheckListAnswerReactive answer) {
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
  ]));
  for (QuestionAnswerReactive question in listQuestionsSplitedByCategory) {
    buildCategoryWidget(category, question, rows, width);

    buildQuestionWidget(rows, question, height, width, small, answer);

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
    },
    children: rows,
  );
}

void buildQuestionWidget(List<TableRow> rows, QuestionAnswerReactive question,
    double height, double width, small, CheckListAnswerReactive answer) {
  String status = '';
  Color colorStatus = Colors.white;
  if (question.approved == null) {
    question.approved = false.obs;
  }
  if (question.disapproved == null) {
    question.disapproved = false.obs;
  }
  if (question.approved!.value! == false &&
      question.disapproved!.value! == false) {
    status = "Não testado";
  } else if (question.approved!.value! == false &&
      question.disapproved!.value! == true) {
    status = "Reprovado";
    colorStatus = PersonalizedColors.errorColor;
  } else if (question.approved!.value! == true &&
      question.disapproved!.value! == false) {
    status = "Aprovado";
    colorStatus = PersonalizedColors.darkGreen;
  }
  rows.add(TableRow(
    children: [
      TableCell(
        child: Container(),
      ),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            width: width * 0.2,
            child: Tooltip(
              message: question.tooltip!.value!,
              decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(90)),
              preferBelow: false,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              textStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 14,
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
          ).marginOnly(bottom: height * 0.03, top: height * 0.03)),
      TableCell(
          child: Container(
        width: width * 0.1,
        child: AutoSizeText(status,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              color: colorStatus,
            )),
            maxLines: 2,
            maxFontSize: 14,
            textAlign: TextAlign.start),
      )),
      TableCell(
        child: Container(),
      ),
    ],
  ));
}

showConfirmation(small, width, height, CheckListAnswerReactive answer) {
  String password = '';
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
      color: Colors.white,
      width: 1.0,
    ),
  );
  Color color = Colors.green[200]!;
  Get.dialog(AlertDialog(
    content: Text(
      'Para excluir o checklist digite a senha para exclusões e clique em confirmar',
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
          Container(
              width: small == true ? width * .12 : width * .15,
              height: height * .1,
              child: Container(
                height: height * .1,
                child: TextFormField(
                  autofocus: false,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  decoration: InputDecoration(
                    hintText: "Senha",
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
                  onChanged: (value) => password = value,
                ),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: PersonalizedColors.redAccent,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () async {
              bool deleted =
                  await Controller.to.deleteChecklist(answer, password);
              if (deleted) {
                Controller.to.snackbar(
                  "Checklist deletado com sucesso!",
                  'Sucesso',
                  Colors.green,
                );
              }
            },
            child: Text(
              'Confirmar',
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
      'Atenção',
      textAlign: TextAlign.center,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ));
}

void buildCategoryWidget(String category, QuestionAnswerReactive question,
    List<TableRow> rows, double width) {
  category == question.category!.value!
      ? rows.isEmpty
          ? rows.add(TableRow(children: [
              TableCell(
                  child: Container(
                      width: width * 0.1,
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
            ]))
          : TableRow(children: [
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container()),
              TableCell(child: Container()),
            ])
      : rows.add(TableRow(children: [
          TableCell(
              child: Container(
                  width: width * 0.1,
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
        ]));
}
