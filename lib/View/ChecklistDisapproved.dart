import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:universal_html/html.dart' as html;

class ChecklistDisapproved extends StatelessWidget {
  ChecklistDisapproved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller.to.countSearch.value = 0;
    Controller.to.getAllCause();
    return Container(
        child: FutureBuilder(
            future: Controller.to.getProducts(),
            initialData: "Aguardando os dados...",
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
    var items = <String>[
      "Lote",
      'Número de Série',
      'Data',
    ];

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
    RxString parameter = "".obs;
    ScrollController scrollController = ScrollController();

    RxString optionValue = 'Lote'.obs;
    List<String> productNameList = Controller.to.buildProductNameList();
    if (Controller.to.buildProductNameList().length > 0) {
      productNameList.add('Todos');
    }
    productNameList.sort();
    RxString productName = productNameList[0].obs;
    RxList<Obx> cards = RxList.empty(growable: true);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Row(
                children: [
                  Container(
                    width: small == true ? width * .2 : width * .15,
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
                    width: small == true ? width * .2 : width * .15,
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
                  optionValue.value != "Data"
                      ? Container(
                          width: small == true ? width * .15 : width * .25,
                          height: height * .1,
                          child: Container(
                            height: height * .1,
                            child: TextFormField(
                              controller: Controller.to.textController,
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
                                width: small == true ? width * .1 : width * .12,
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
                                    icon:
                                        Icon(Icons.event, color: Colors.white),
                                    timeLabelText: "Hora",
                                    locale: (Locale('pt', 'BR')),
                                    onChanged: (val) {
                                      Controller.to.initialDate =
                                          DateTime.parse(val);
                                    })).marginOnly(left: width * 0.02),
                            Container(
                                width: small == true ? width * .1 : width * .12,
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
                                    icon:
                                        Icon(Icons.event, color: Colors.white),
                                    timeLabelText: "Hora",
                                    locale: (Locale('pt', 'BR')),
                                    onChanged: (val) {
                                      Controller.to.endDate =
                                          DateTime.parse(val);
                                      Controller.to.endDate =
                                          Controller.to.endDate!.add(
                                              Duration(hours: 23, minutes: 59));
                                    })).marginOnly(left: width * 0.02),
                          ],
                        ),
                ],
              ).marginOnly(
                  top: height * 0.05, left: width * 0.08, right: width * 0.08)),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: small == true ? width * .15 : width * .08,
                    height: height * .065,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: PersonalizedColors.lightGreen,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(60.0),
                            )),
                        onPressed: () async {
                          Controller.to.offset.value = 0;
                          cards.value = [];
                          Controller.to.visible.value = true;
                          Controller.to.countSearch.value = 0;
                          await Controller.to.searchReprovedProductionCheckList(
                              productName.value!,
                              optionValue.value!,
                              parameter.value!,
                              '30',
                              '0');

                          if (Controller.to.ansewersListReactive.isEmpty) {
                            Controller.to.visible.value = false;
                            Controller.to.snackbar(
                                'Por favor verifique os parâmetros de busca',
                                'Não foi possível encontrar checklists',
                                PersonalizedColors.errorColor);
                          } else {
                            Controller.to.visible.value = false;
                            cards.value = buildCards(height, width, small,
                                Controller.to.cards, context);
                            Controller.to.countSearch.value =
                                Controller.to.ansewersListReactive.length;
                          }
                        },
                        child: CommonWidgets.buildText(
                            "Buscar", 14, Colors.white, TextAlign.center)),
                  ).marginOnly(left: width * 0.01),
                  Controller.to.countSearch.value > 0
                      ? Container(
                          width: width * .1,
                          child: CommonWidgets.buildText(
                              "Itens Encontrados: " +
                                  Controller.to.sizeOfResponse.value.toString(),
                              8,
                              Colors.white,
                              TextAlign.center),
                        ).marginOnly(left: width * 0.01)
                      : Container(),
                ],
              )).marginOnly(bottom: height * 0.01, top: height * 0.01),
          Obx(() => Controller.to.sizeOfResponse.value > 30
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Controller.to.offset.value >= 30
                      ? Container(
                          child: ElevatedButton(
                          child: Text('Página Anterior'),
                          onPressed: () async {
                            cards.value = [];
                            Controller.to.offset.value =
                                Controller.to.offset.value - 30;
                            await Controller.to
                                .searchReprovedProductionCheckList(
                                    productName.value,
                                    optionValue.value,
                                    parameter.value,
                                    '30',
                                    Controller.to.offset.value.toString());
                            cards.value = buildCards(height, width, small,
                                Controller.to.cards, context);
                          },
                        )).marginOnly(right: width * 0.01)
                      : Container(),
                  Controller.to.offset.value <=
                          Controller.to.sizeOfResponse.value
                      ? Container(
                          child: ElevatedButton(
                              child: Text('Proxima Página'),
                              onPressed: () async {
                                cards.value = [];
                                Controller.to.offset.value =
                                    Controller.to.offset.value + 30;
                                await Controller.to
                                    .searchReprovedProductionCheckList(
                                  productName.value,
                                  optionValue.value,
                                  parameter.value,
                                  '30',
                                  Controller.to.offset.value.toString(),
                                );
                                cards.value = buildCards(height, width, small,
                                    Controller.to.cards, context);
                              }))
                      : Container()
                ])
              : Container()),
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
                                    childAspectRatio: 1.8,
                                    crossAxisCount: small == true ? 2 : 3,
                                    padding: EdgeInsets.all(30),
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
                  CommonWidgets.buildText(checklist.value!.title!.value!, 14,
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
                  Container(
                    height: 0.5,
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

  void showCheckList(
      CheckListAnswerReactive checkListAnswer,
      BuildContext context,
      double height,
      double width,
      bool small,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory) {
    Get.bottomSheet(
        buildCompleteCheckList(checkListAnswer, width, small, height,
            listQuestionsSplitedByCategory, false),
        isDismissible: true,
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

    ScrollController scrollController = ScrollController();

    List<String> causeList = Controller.to.buildCauseListList().length > 0
        ? Controller.to.buildCauseListList()
        : ['Não há causa cadastrada'];

    causeList.sort();

    RxString cause =
        causeList.length > 0 ? causeList[0].obs : 'Não há causa cadastrada'.obs;
    return Column(
      children: [
        needPdf
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                          alignment: Alignment.center,
                          child: AutoSizeText(checkListAnswer.title!.value!,
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                color: Colors.white,
                              )),
                              maxLines: 2,
                              maxFontSize: 14,
                              textAlign: TextAlign.start))
                      .marginOnly(left: width * 0.02),
                  Container(
                      width: small == true ? width * .1 : width * .1,
                      height: height * .05,
                      child: IconButton(
                        tooltip: "Gerar PDF",
                        onPressed: () {
                          generatePdf(checkListAnswer, height, width,
                              listQuestionsSplitedByCategory);
                        },
                        icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      )).marginOnly(left: width * 0.02),
                ],
              ).marginOnly(top: height * 0.02)
            : Container(
                    child: AutoSizeText(checkListAnswer.title!.value!,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          color: Colors.white,
                        )),
                        maxLines: 2,
                        maxFontSize: 14,
                        textAlign: TextAlign.start))
                .marginOnly(left: width * 0.02),
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
                          "Data: " +
                              CommonWidgets.getFormatter()
                                  .format(checkListAnswer.date!),
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            color: Colors.white,
                          )),
                          maxLines: 2,
                          maxFontSize: 14,
                          textAlign: TextAlign.start)),
                  Container(
                      width: width * 0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: width * 0.25,
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
                              checkListAnswer.origin!.value! != ""
                                  ? Container(
                                      width: width * 0.25,
                                      child: AutoSizeText(
                                          "Origem: " +
                                              checkListAnswer.origin!.value!,
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                            color: Colors.white,
                                          )),
                                          maxLines: 2,
                                          maxFontSize: 14,
                                          textAlign: TextAlign.start))
                                  : Container(),
                            ],
                          )
                        ],
                      ))
                ])).marginOnly(top: height * 0.02),
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
                    Container(
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
                        .marginOnly(top: height * 0.05),
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
                            .marginOnly(bottom: height * 0.1)
                        : Container(),
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
                      width: small == true ? width * .15 : width * .25,
                      height: height * .35,
                      child: Container(
                        child: TextFormField(
                          autofocus: false,
                          maxLines: 10,
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          decoration: InputDecoration(
                            hintText: "Solução",
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
                              checkListAnswer.causeDescription = value,
                        ),
                      ),
                    ).marginOnly(
                        left: width * .2,
                        right: width * .2,
                        bottom: height * 0.02,
                        top: height * 0.02),
                    Container(
                            width: small == true ? width * .3 : width * .25,
                            height: height * .05,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(60.0),
                                    )),
                                onPressed: () async {
                                  String sector =
                                      Controller.to.user.sector!.value;

                                  checkListAnswer.cause = cause.value;
                                  checkListAnswer.statusOfCheckList =
                                      "Retrabalhado " +
                                          Controller.to.user.sector!.value;

                                  checkListAnswer.nameOfUserAssistance =
                                      Controller.to.user.name!.value;

                                  checkListAnswer.dateAssistance =
                                      new DateTime.now();
                                  Controller.to.editAnswer(checkListAnswer);
                                  Controller.to.textController.clear();
                                  (Get.context as Element).reassemble();
                                },
                                child: CommonWidgets.buildText(
                                    "Salvar",
                                    14,
                                    PersonalizedColors.skyBlue,
                                    TextAlign.center)))
                        .marginOnly(left: width * .4, right: width * .4),
                  ]).paddingOnly(
                left: width * 0.05,
                right: width * 0.05,
              ),
            ),

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
    final pdf = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List(),
    );
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Center(
            child:
                pw.Container(width: 150, height: 150, child: pw.Image(logo))),
        build: (pw.Context context) {
          return buildPdfCheckList(checkListAnswer, width, false, height,
              listQuestionsSplitedByCategory, false);
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
        width: width * 0.01,
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

void buildCategoryWidget(String category, QuestionAnswerReactive question,
    List<TableRow> rows, double width) {
  category == question.category!.value!
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
