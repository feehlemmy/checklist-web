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

import '../Utils/Constansts.dart';

class ChecklistReport extends StatelessWidget {
  ChecklistReport({Key? key}) : super(key: key);
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
    var mapOfProductIdAndTile = Controller.to.getMapOfProductIdChecklistTitle();
    RxList<String> prodList = RxList.empty(growable: true);

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
    RxString productFilterName = "Todos".obs;

    RxString optionValue = 'Lote'.obs;

    var status = <String>["Todos", 'Aprovado', 'Retrabalhado', 'Reprovado'];
    status.sort();
    RxString statusValue = 'Todos'.obs;

    Controller.to.buildProductNameList();
    Controller.to.productNameList.add('Todos');
    Controller.to.productNameList.sort();
    prodList = Controller.to.productNameList.obs;

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
                          int productId =
                              Controller.to.findProductIdByName(newValue!);
                          prodList.value =
                              findTitlesById(productId, mapOfProductIdAndTile);
                          if (prodList.isNotEmpty) {
                            productFilterName.value = prodList.value[0];
                          }
                          prodList.add('Todos');

                          if (newValue == "Todos") {
                            productFilterName.value = 'Todos';
                          }
                          Controller.to.productName.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return Controller.to.productNameList
                              .map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },

                        items:
                            Controller.to.productNameList.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: Controller.to.productName.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ),
                    Obx(() => Container(
                          width: small == true ? width * .2 : width * .12,
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
                            onChanged: (String? newValue) {
                              productFilterName.value = newValue!;
                              print(productFilterName.value);
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return prodList.map<Widget>((String item) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: CommonWidgets.buildText(
                                      item, 14, Colors.white, TextAlign.center),
                                );
                              }).toList();
                            },

                            items: prodList.map((String option) {
                              return DropdownMenuItem(
                                child: CommonWidgets.buildText(
                                    option, 14, Colors.white, TextAlign.center),
                                value: option,
                              );
                            }).toList(),
                            value: productFilterName.value,
                            dropdownColor: PersonalizedColors.skyBlue,
                            isExpanded: true,

                            isDense: false,
                            underline: SizedBox(),
                          ).marginOnly(
                            left: 10,
                            right: 10,
                          ),
                        )).marginOnly(left: width * 0.02),
                    Container(
                      width: small == true ? width * .1 : width * .1,
                      height: height * .1,
                      child: Container(
                        height: height * .1,
                        child: TextFormField(
                          autofocus: false,
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          decoration: InputDecoration(
                            hintText: optionValue.value,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: optionValue.value,
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
                          onChanged: (value) => parameter.value = value,
                        ),
                      ),
                    ).marginOnly(left: width * 0.02, top: height * 0.035),
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
                            Controller.to.cards2.value = [];
                            Controller.to.visible.value = true;
                            Controller.to.countSearch.value = 0;
                            await Controller.to.searchResponseCheckList(
                                Controller.to.productName.value!,
                                optionValue.value!,
                                parameter.value!,
                                '1000000000',
                                '0',
                                statusValue.value!,
                                productFilterName.value);

                            if (Controller.to.ansewersListReactive.isEmpty) {
                              Controller.to.visible.value = false;
                              Controller.to.snackbar(
                                  'Por favor verifique os parâmetros de busca',
                                  'Não foi possível encontrar checklists',
                                  PersonalizedColors.errorColor);
                            } else {
                              Controller.to.visible.value = false;
                              Controller.to.cards2.value = buildCards(height,
                                  width, small, Controller.to.cards2, context);
                              Controller.to.countSearch.value =
                                  Controller.to.ansewersListReactive.length;
                            }
                          },
                          child: CommonWidgets.buildText(
                              "Buscar", 14, Colors.white, TextAlign.center)),
                    ).marginOnly(left: width * 0.01),
                  ],
                ).marginOnly(
                    top: height * 0.05, left: width * 0.1, right: width * 0.1),
              ])),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Controller.to.countSearch.value > 0
                      ? Container(
                          width: width * .1,
                          child: CommonWidgets.buildText(
                              "Itens Encontrados: " +
                                  Controller.to.sizeOfResponse2.value
                                      .toString(),
                              8,
                              Colors.white,
                              TextAlign.center),
                        ).marginOnly(left: width * 0.01)
                      : Container(),
                ],
              )).marginOnly(bottom: height * 0.01, top: height * 0.01),
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
                            : Table(
                                border: TableBorder.all(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                    width: 2),
                                children: Controller.to.cards2,
                              ).marginOnly(left: width * .1, right: width * .1))
                      ]))),
        ]);
  }

  buildCards(double height, double width, bool small, List<TableRow> cards,
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
        TableRow(children: [
          Container(
            width: width * .25,
            child: CommonWidgets.buildText(
                "Titulo: " + checklist.value!.title!.value!,
                14,
                Colors.white,
                TextAlign.center),
          ).marginAll(2),
          Container(
            width: width * .015,
            child: CommonWidgets.buildText(
                "Lote: " + checklist.value!.batch!.value!,
                14,
                Colors.white,
                TextAlign.center),
          ).marginAll(2),
          Container(
            child: CommonWidgets.buildText(
                "Nº de Série: " + checklist.value!.serieNumber!.value!,
                14,
                Colors.white,
                TextAlign.center),
          ).marginAll(2),
          Container(
            child: CommonWidgets.buildText(checklist.value!.sector!.value!, 14,
                Colors.white, TextAlign.center),
          ).marginAll(2),
          Container(
            child: CommonWidgets.buildText(checklist.value!.statusOfCheckList!,
                14, color, TextAlign.center),
          ).marginAll(2),
        ]),
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
            listQuestionsSplitedByCategory, true),
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
    ScrollController scrollController = ScrollController();
    needPdf = Controller.to.user.sector!.value == Constants.administrativo
        ? true
        : false;

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
                          width: width * 0.3,
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
                      width: width * 0.25,
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
                      width: width * 0.25,
                      child: Column(
                        children: [
                          Container(
                              child: AutoSizeText(
                                  "Setor: " + checkListAnswer.sector!.value!,
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                                  maxLines: 2,
                                  maxFontSize: 14,
                                  textAlign: TextAlign.start)),
                        ],
                      ))
                ])).marginOnly(top: height * 0.02),
        Container(
            width: width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                checkListAnswer.sector == Constants.controleDeQualidade
                    ? checkListAnswer.origin!.value! != ""
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
                        : Container()
                    : Container(),
                checkListAnswer.sector == Constants.controleDeQualidade
                    ? checkListAnswer.testEnvironment!.value! != ""
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
                        : Container()
                    : Container(),
                Container(
                  width: width * .25,
                ),
              ],
            )).marginOnly(top: height * 0.02),
        checkListAnswer.statusOfCheckList!.contains("Retrab")
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
                                  CommonWidgets.getFormatter()
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
        checkListAnswer.statusOfCheckList!.contains("Retrab")
            ? Column(
                children: [
                  Container(
                    width: width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: width * 0.25,
                            child: AutoSizeText(
                                "Produto Retrabalhado: " +
                                    checkListAnswer.statusOfCheckList!,
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
                            .marginOnly(bottom: height * 0.1)
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
                            .marginOnly(bottom: height * 0.1)
                        : Container(),
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

findTitlesById(int productId, Map<String, int> mapOfProductIdAndTitle) {
  var prodList = <String>[];
  for (var item in mapOfProductIdAndTitle.entries) {
    if (item.value == productId) {
      prodList.add(item.key);
    }
  }
  return prodList;
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
