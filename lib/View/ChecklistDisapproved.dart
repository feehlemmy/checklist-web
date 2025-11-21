import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/Utils/Constansts.dart';
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
                              style: GoogleFonts.exo2(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              decoration: InputDecoration(
                                hintText: "Pesquisar",
                                border: outlineInputBorder,
                                enabledBorder: outlineInputBorder,
                                focusedBorder: enableBorder,
                                errorStyle: GoogleFonts.exo2(
                                    textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                )),
                                hintStyle: GoogleFonts.exo2(
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
                                      hintStyle: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                              fontSize: 14,
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
                                    style: GoogleFonts.exo2(
                                        textStyle: TextStyle(
                                      fontSize: 14,
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
                                      hintStyle: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                              fontSize: 14,
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
                                    style: GoogleFonts.exo2(
                                        textStyle: TextStyle(
                                      fontSize: 14,
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
                            backgroundColor: PersonalizedColors.lightGreen,
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
                  trackVisibility: true,
                  controller: scrollController, // <---- Here, the controller
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
    List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
  ) {
    final screenSize = MediaQuery.of(context).size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Checklist",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(curved),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.6,
                decoration: BoxDecoration(
                  color: PersonalizedColors.skyBlue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: buildCompleteCheckList(
                          checkListAnswer,
                          width,
                          small,
                          height,
                          listQuestionsSplitedByCategory,
                          true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCompleteCheckList(
    CheckListAnswerReactive checkListAnswer,
    double width,
    bool small,
    double height,
    List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
    bool needPdf,
  ) {
    // ───── Lista de causas e estado reativo ─────
    List<String> causeList = Controller.to.buildCauseListList().isNotEmpty
        ? Controller.to.buildCauseListList()
        : ['Não há causa cadastrada'];
    causeList.sort();
    RxString cause = (checkListAnswer.cause ?? causeList.first).obs;

    final scrollController = ScrollController();

    Widget buildText(String text,
        {Color color = Colors.white,
        double? w,
        TextAlign align = TextAlign.start}) {
      return SizedBox(
        width: w ?? width * 0.3,
        child: AutoSizeText(
          text,
          style: GoogleFonts.exo2(textStyle: TextStyle(color: color)),
          maxLines: 2,
          maxFontSize: 14,
          textAlign: align,
        ),
      );
    }

    Widget buildRowWrap(List<Widget> widgets) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        margin: EdgeInsets.only(top: height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets
              .map((w) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: w,
                    ),
                  ))
              .toList(),
        ),
      );
    }

    Widget buildPdfHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: AutoSizeText(
              checkListAnswer.title!.value!,
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            tooltip: "Gerar PDF",
            onPressed: () {
              generatePdf(
                checkListAnswer,
                height,
                width,
                listQuestionsSplitedByCategory,
              );
            },
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        ],
      ).marginOnly(top: height * 0.015);
    }

    return Container(
      width: double.infinity,
      height: height * 0.85,
      decoration: BoxDecoration(
        color: PersonalizedColors.skyBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Cabeçalho
          needPdf
              ? buildPdfHeader()
              : buildText(
                  checkListAnswer.title!.value!,
                  align: TextAlign.center,
                  w: width * 0.7,
                ).marginOnly(top: height * 0.015),

          // Dados principais
          buildRowWrap([
            buildText("Lote: ${checkListAnswer.batch!.value!}"),
            buildText("Nº de Série: ${checkListAnswer.serieNumber!.value!}"),
            buildText("Versão: ${checkListAnswer.productVersion!.value!}"),
          ]),
          buildRowWrap([
            buildText("Responsável: ${checkListAnswer.nameOfUser!.value!}"),
            buildText(
                "Data: ${CommonWidgets.getFormatter().format(checkListAnswer.date!)}"),
            buildText("Setor: ${checkListAnswer.sector!.value!}"),
          ]),
          buildRowWrap([
            if (checkListAnswer.sector == Constants.controleDeQualidade &&
                checkListAnswer.origin!.value!.isNotEmpty)
              buildText("Origem: ${checkListAnswer.origin!.value!}"),
            if (checkListAnswer.sector == Constants.controleDeQualidade &&
                checkListAnswer.testEnvironment!.value!.isNotEmpty)
              buildText(
                  "Ambiente de Teste: ${checkListAnswer.testEnvironment!.value!}"),
          ]),

          // Área rolável com perguntas e retrabalho
          SizedBox(
            height: height * 0.5,
            child: Scrollbar(
              controller: scrollController,
              interactive: true,
              trackVisibility: true,
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(vertical: 0),
                children: [
                  // Perguntas
                  buildQuestions(
                    height,
                    width,
                    small,
                    listQuestionsSplitedByCategory,
                    checkListAnswer,
                  ),

                  // Observações/Causas/Motivos (se existirem)
                  if ((checkListAnswer.observation?.value ?? '').isNotEmpty)
                    buildText(
                      "Observação: ${checkListAnswer.observation!.value!}",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),

                  if ((checkListAnswer.cause ?? '').isNotEmpty)
                    buildText(
                      "Resumo da Causa: ${checkListAnswer.cause!}",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),

                  if ((checkListAnswer.statusOfProduct ?? '').isNotEmpty)
                    buildText(
                      "Motivo da Reprova: ${checkListAnswer.statusOfProduct!}",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),

                  // ───── Campos de retrabalho ─────
                  SizedBox(height: height * 0.02),

                  // 1) Dropdown de causas
                  Center(
                    child: Container(
                        width: width * 0.5,
                        child: Obx(() => DropdownButtonFormField<String>(
                              value: cause.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    PersonalizedColors.blueGrey.withOpacity(.2),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              items: causeList
                                  .map((c) => DropdownMenuItem<String>(
                                        value: c,
                                        child: CommonWidgets.buildText(c, 14,
                                            Colors.white, TextAlign.center),
                                      ))
                                  .toList(),
                              dropdownColor: PersonalizedColors.skyBlue,
                              onChanged: (v) {
                                cause.value = v!;
                                checkListAnswer.cause = v;
                              },
                            ))),
                  ),

                  SizedBox(height: height * 0.02),

                  // 2) Campo de solução
                  Center(
                    child: Container(
                      width: width * 0.5,
                      child: TextFormField(
                        initialValue: checkListAnswer.causeDescription ?? '',
                        maxLines: 4,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Descreva a solução',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor:
                              PersonalizedColors.blueGrey.withOpacity(.2),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: (v) => checkListAnswer.causeDescription = v,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // 3) Botão Salvar
                  Center(
                    child: Container(
                      width: width * 0.25,
                      height: height * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          checkListAnswer.nameOfUserAssistance =
                              Controller.to.user.name!.value;
                          checkListAnswer.dateAssistance = DateTime.now();
                          checkListAnswer.statusOfCheckList = "Retrabalhado " +
                              Controller.to.user.sector!.value;
                          await Controller.to.editAnswer(checkListAnswer);
                          (Get.context as Element).reassemble();
                        },
                        child: CommonWidgets.buildText(
                          'Salvar',
                          14,
                          PersonalizedColors.skyBlue,
                          TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  // ───────────────────────────────────────
                ],
              ),
            ),
          ),
        ],
      ),
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
              textStyle: GoogleFonts.exo2(
                  textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
              child: AutoSizeText(question.description!.value!,
                  style: GoogleFonts.exo2(
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
            style: GoogleFonts.exo2(
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
                style: GoogleFonts.exo2(
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
            style: GoogleFonts.exo2(
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
