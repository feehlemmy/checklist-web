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

class ChecklistAnswered extends StatelessWidget {
  ChecklistAnswered({Key? key}) : super(key: key);
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
                      print(orientation);

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
                    backgroundColor: Colors.white,
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
                      width: small == true ? width * .17 : width * .12,
                      height: height * .07,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
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
                      width: width * .1,
                      height: height * .07,
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
                            width: small == true ? width * .1 : width * .1,
                            height: height * .1,
                            child: Container(
                              height: height * .1,
                              child: TextFormField(
                                autofocus: false,
                                style: GoogleFonts.exo2(
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                decoration: InputDecoration(
                                  hintText: optionValue.value,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: optionValue.value,
                                  labelStyle: GoogleFonts.exo2(
                                      textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  )),
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
                                  width:
                                      small == true ? width * .1 : width * .1,
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
                                      small == true ? width * .1 : width * .1,
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
                  ],
                ).marginOnly(
                    top: height * 0.05, left: width * 0.1, right: width * 0.1),
              ])),
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
                          Controller.to.cards.value = [];
                          Controller.to.visible.value = true;
                          Controller.to.countSearch.value = 0;
                          await Controller.to.searchResponseCheckList(
                              Controller.to.productName.value!,
                              optionValue.value!,
                              parameter.value!,
                              '30',
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
                            Controller.to.cards.value = buildCards(height,
                                width, small, Controller.to.cards, context);
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
                                  Controller.to.sizeOfResponse2.value
                                      .toString(),
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
                            Controller.to.cards.value = [];
                            Controller.to.offset.value =
                                Controller.to.offset.value - 30;
                            await Controller.to.searchResponseCheckList(
                                Controller.to.productName.value,
                                optionValue.value,
                                parameter.value,
                                '30',
                                Controller.to.offset.value.toString(),
                                statusValue.value!,
                                productFilterName.value);
                            Controller.to.cards.value = buildCards(height,
                                width, small, Controller.to.cards, context);
                          },
                        )).marginOnly(right: width * 0.01)
                      : Container(),
                  Controller.to.offset.value <
                          Controller.to.sizeOfResponse.value
                      ? Container(
                          child: ElevatedButton(
                              child: Text('Proxima Página'),
                              onPressed: () async {
                                Controller.to.cards.value = [];
                                Controller.to.offset.value =
                                    Controller.to.offset.value + 30;
                                await Controller.to.searchResponseCheckList(
                                    Controller.to.productName.value,
                                    optionValue.value,
                                    parameter.value,
                                    '30',
                                    Controller.to.offset.value.toString(),
                                    statusValue.value!,
                                    productFilterName.value);
                                Controller.to.cards.value = buildCards(height,
                                    width, small, Controller.to.cards, context);
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
                                    children: Controller.to.cards.value)
                                .marginOnly(
                                    left: width * .1, right: width * .1))
                      ]))),
        ]);
  }

  List<Obx> buildCards(
    double height,
    double width,
    bool small,
    List<Obx> cards,
    BuildContext context,
  ) {
    cards = [];

    for (CheckListAnswerReactive checklistSkeletonAux
        in Controller.to.ansewersListReactive) {
      final checklist = checklistSkeletonAux.obs;
      Color color = checklist.value!.statusOfCheckList! == "Aprovado"
          ? PersonalizedColors.darkGreen
          : checklist.value!.statusOfCheckList!.contains("Retrab")
              ? PersonalizedColors.warningColor
              : PersonalizedColors.errorColor;
      cards.add(
        Obx(
          () => InkWell(
            child: Container(
              width: small ? width * .7 : width * .1,
              height: height * .2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  style: BorderStyle.solid,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
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
                  Container(height: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidgets.buildText(
                          "Setor: ", 14, Colors.white, TextAlign.center),
                      CommonWidgets.buildText(checklist.value!.sector!.value!,
                          14, Colors.white, TextAlign.center),
                    ],
                  ),
                  Container(height: 0.5),
                  CommonWidgets.buildText(checklist.value!.statusOfCheckList!,
                      14, color, TextAlign.center),
                  Container(height: 0.5),
                ],
              ),
            ),
            onTap: () {
              showCheckList(
                checklist.value!,
                context,
                height,
                width,
                small,
                splitQuestionsByCategory(checklist.value!.questions!),
              );
            },
          ),
        ),
      );
    }
    return cards;
  }

  List<QuestionAnswerReactive> splitQuestionsByCategory(
      List<QuestionAnswerReactive> questionList) {
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
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // Required, but not used.
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: screenSize.width * 0.8, // 80% largura
                height: screenSize.height * 0.6, // 60% altura
                decoration: BoxDecoration(
                  color: PersonalizedColors.skyBlue,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
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
    ScrollController scrollController = ScrollController();
    needPdf = Controller.to.user.sector!.value == Constants.administrativo;

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
              .map(
                (w) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: w,
                  ),
                ),
              )
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
              generatePdf(checkListAnswer, height, width,
                  listQuestionsSplitedByCategory);
            },
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        ],
      ).marginOnly(top: height * 0.015);
    }

    Widget buildRetrabalhoInfo() {
      if (!checkListAnswer.statusOfCheckList!.contains("Retrab"))
        return Container();

      return Column(
        children: [
          buildRowWrap([
            buildText(
                "Responsável Retrabalho: ${checkListAnswer.nameOfUserAssistance!}"),
            buildText(
                "Data Retrabalho: ${CommonWidgets.getFormatter().format(checkListAnswer.dateAssistance!)}"),
          ]),
          buildRowWrap([
            buildText(
              "Produto Retrabalhado: ${checkListAnswer.statusOfCheckList!}",
              color: PersonalizedColors.warningColor,
            ),
            buildText("Causa: ${checkListAnswer.cause!}"),
          ]),
          if (checkListAnswer.causeDescription != null)
            buildRowWrap([
              buildText("Solução: ${checkListAnswer.causeDescription!}",
                  w: width * 0.5),
            ]),
        ],
      );
    }

    Widget buildStatus() {
      if (checkListAnswer.statusOfCheckList!.contains("Retrab"))
        return Container();

      final isApproved = checkListAnswer.statusOfCheckList == "Aprovado";
      final statusText = isApproved ? "Produto Aprovado" : "Produto Reprovado";
      final statusColor = isApproved
          ? PersonalizedColors.lightGreen
          : PersonalizedColors.errorColor;

      return Padding(
        padding: EdgeInsets.only(top: height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AutoSizeText(
                statusText,
                textAlign: TextAlign.center,
                style: GoogleFonts.exo2(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
    }

    final obs = checkListAnswer.observation?.value ?? '';
    final causeText = checkListAnswer.cause ?? '';
    final statusProd = checkListAnswer.statusOfProduct ?? '';

    return Container(
      width: double.infinity,
      height: height * 0.85,
      decoration: BoxDecoration(
        color: PersonalizedColors.skyBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          needPdf
              ? buildPdfHeader()
              : buildText(
                  checkListAnswer.title!.value!,
                  align: TextAlign.center,
                  w: width * 0.7,
                ).marginOnly(top: height * 0.015),
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
          buildRetrabalhoInfo(),
          buildStatus(),
          SizedBox(
            height: height * 0.5,
            child: Scrollbar(
              interactive: true,
              trackVisibility: true,
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                children: [
                  buildQuestions(height, width, small,
                      listQuestionsSplitedByCategory, checkListAnswer),
                  if (obs.isNotEmpty)
                    buildText(
                      "Observação: $obs",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),

// Resumo da causa
                  if (causeText.isNotEmpty)
                    buildText(
                      "Resumo da Causa: $causeText",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),

// Motivo da reprova
                  if (statusProd.isNotEmpty)
                    buildText(
                      "Motivo da Reprova: $statusProd",
                      w: width * 0.7,
                    ).marginOnly(bottom: height * 0.1),
                ],
              ).paddingOnly(
                left: width * 0.05,
                right: width * 0.05,
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
