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
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPage(
                  constraints.maxHeight, constraints.maxWidth, true, context)
              : buildPage(
                  constraints.maxHeight, constraints.maxWidth, false, context);
        });
      }),
    );
  }

  buildPage(double height, double width, bool small, BuildContext context) {
    RxString filter = ''.obs;
    RxList<Container> cards =
        buildCards(height, width, small, filter.value, context).obs;

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
        SizedBox(height: height * .05),
        Container(
          width: small ? width * .7 : width * .25,
          height: height * .07,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.exo2(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                hintText: 'Pesquisar',
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
              onChanged: (value) {
                filter.value = value;
                cards.value =
                    buildCards(height, width, small, filter.value, context);
              }),
        ).marginOnly(left: width * .1, right: width * .1),
        SizedBox(height: height * .05),
        Obx(() => GridView.count(
                shrinkWrap: true,
                addRepaintBoundaries: true,
                childAspectRatio: 1.8,
                crossAxisCount: small ? 2 : 3,
                padding: EdgeInsets.all(30),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: cards.value)
            .marginOnly(left: width * .1, right: width * .1)),
      ]),
    );
  }

  List<Container> buildCards(double height, double width, bool small,
      String filter, BuildContext context) {
    List<CheckListSkeletonReactive> checklistFiltered = [];
    List<Container> cards = [];
    List<CheckListSkeletonReactive> checklistSkeletonList =
        Controller.to.getChecklistSkeletonList();
    checklistSkeletonList
        .sort((a, b) => a.title!.value!.compareTo(b.title!.value!));

    if (!filter.isBlank!) {
      for (CheckListSkeletonReactive checklist in checklistSkeletonList) {
        String title = checklist.title!.value!;
        if (title.toUpperCase().contains(filter.toUpperCase())) {
          checklistFiltered.add(checklist);
        }
      }
    } else {
      checklistFiltered = checklistSkeletonList;
    }

    for (CheckListSkeletonReactive checklist in checklistFiltered) {
      final checklistObs = checklist.obs;
      ProductEntityReactive? product;
      Controller.to.getProductsList().forEach((element) {
        if (element.id == checklistObs.value!.productId!.value) {
          product = element;
        }
      });
      cards.add(Container(
        width: small ? width * .7 : width * .1,
        height: height * .2,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, style: BorderStyle.solid, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CommonWidgets.buildText(checklistObs.value!.title!.value!, 14,
                Colors.white, TextAlign.center),
            SizedBox(height: 0.5),
            CommonWidgets.buildText(checklistObs.value!.sector!.value!, 14,
                Colors.white, TextAlign.center),
            SizedBox(height: 0.5),
            product != null
                ? CommonWidgets.buildText(
                    product!.name!.value!, 14, Colors.white, TextAlign.center)
                : Container(),
            SizedBox(height: 0.5),
            Obx(() => Controller.to
                .userIsDisableText(checklistObs.value!.status!.value)),
            SizedBox(height: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    tooltip: 'Editar',
                    onPressed: () {
                      Controller.to.checklistToEdit = checklist;
                      editUser(context);
                    },
                    icon: Icon(Icons.edit, color: Colors.white)),
                IconButton(
                    tooltip: 'Duplicar',
                    onPressed: () {
                      Controller.to.checklistToCopy = checklist;
                      copyCheckList(context);
                      Controller.to.getChecklistSkeleton();
                    },
                    icon: Icon(Icons.copy, color: Colors.white)),
                IconButton(
                    tooltip: 'Excluir',
                    onPressed: () {
                      showConfirmation(checklistObs.value);
                    },
                    icon: Icon(Icons.delete, color: Colors.white)),
                Obx(() => Controller.to
                    .getIconDeleteOrRestoreChecklist(checklistObs.value!))
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

  Widget _buildBottomSheet(BuildContext context,
      ScrollController scrollController, double bottomSheetOffset) {
    return SafeArea(
        child: buildCompleteCheckList(context, Controller.to.checklistToEdit!));
  }

  buildCompleteCheckList(
      BuildContext context, CheckListSkeletonReactive checkList) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.height * 0.6;
    bool small = false;

    List<String> productsName = Controller.to.buildProductNameList();
    var auxProducts = Controller.to.getProductsList();
    List<ProductEntityReactive> products = [];
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
      if (item.id == checkList.productId!.value) {
        product = item.name!.value!.obs;
        break;
      }
    }

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: PersonalizedColors.blueGrey, width: 1.0),
    );

    // Cria lista temporária reordenável a partir das questões originais
    final RxList<QuestionSkeletonReactive> orderedQuestions =
        RxList<QuestionSkeletonReactive>.from(checkList.questions!);

    return Obx(() => SafeArea(
          bottom: false,
          child: Material(
            color: PersonalizedColors.skyBlue,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(80),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: width * .4,
                    height: height * .07,
                    child: TextFormField(
                        autofocus: false,
                        style: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        decoration: InputDecoration(
                          border: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          focusedBorder: enableBorder,
                          errorStyle: GoogleFonts.exo2(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.red)),
                          hintStyle: GoogleFonts.exo2(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                        initialValue: checkList.title!.value,
                        textAlign: TextAlign.center,
                        onChanged: (String? newValue) {
                          checkList.title!.value = newValue!;
                        }),
                  ).marginOnly(left: width * .2, right: width * .2),
                  SizedBox(height: height * 0.02),
                  Obx(() => Container(
                        width: small ? width * .7 : width * .4,
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
                              if (item.name!.value == value) {
                                checkList.productId!.value = item.id!;
                                break;
                              }
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return productsName
                                .map<Widget>((String item) => Container(
                                      alignment: Alignment.center,
                                      child: CommonWidgets.buildText(item, 14,
                                          Colors.white, TextAlign.center),
                                    ))
                                .toList();
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
                        ).marginOnly(left: 10, right: 10),
                      ).marginOnly(left: width * .5, right: width * .5)),
                  SizedBox(height: height * 0.02),
                  Obx(() => Container(
                        width: small ? width * .7 : width * .25,
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
                            return sectorList
                                .map<Widget>((String item) => Container(
                                      alignment: Alignment.center,
                                      child: CommonWidgets.buildText(item, 14,
                                          Colors.white, TextAlign.center),
                                    ))
                                .toList();
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
                        ).marginOnly(left: 10, right: 10),
                      ).marginOnly(left: width * .5, right: width * .5)),
                  SizedBox(height: height * 0.02),
                  // Seção de questões com o ReorderableListView
                  Container(
                      width: width * .8,
                      child: AutoSizeText(
                        'Questões: ',
                        style: GoogleFonts.exo2(
                            textStyle: TextStyle(color: Colors.white)),
                        maxLines: 2,
                        maxFontSize: 14,
                        textAlign: TextAlign.start,
                      )).marginOnly(top: height * 0.05, left: width * 0.02),
                  Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      child: buildReorderableQuestions(
                          height, width, small, checkList, orderedQuestions)),

                  // Seção de e-mails
                  Container(
                      width: width * .8,
                      child: AutoSizeText(
                        'Pessoas Interessadas: ',
                        style: GoogleFonts.exo2(
                            textStyle: TextStyle(color: Colors.white)),
                        maxLines: 2,
                        maxFontSize: 14,
                        textAlign: TextAlign.start,
                      )).marginOnly(top: height * 0.05, left: width * 0.02),

                  SizedBox(height: 20),
                  Container(
                    child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: buildEmails(height, width, small))
                        .marginOnly(top: height * 0.05),
                  ),
                  SizedBox(height: height * 0.02),

                  SizedBox(height: height * 0.02),
                  // Botão Salvar:
                  // Atualiza a propriedade 'position' de cada item e atualiza a lista original in place,
                  // garantindo que a nova ordem seja aplicada ao objeto que será salvo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: width * .3,
                          height: height * .1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      PersonalizedColors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                  )),
                              onPressed: () {
                                // Atualiza o valor de 'position' de cada questão com base na nova ordem
                                for (int i = 0;
                                    i < orderedQuestions.length;
                                    i++) {
                                  orderedQuestions[i].position!.value =
                                      (i + 1).toString();
                                }
                                // Em vez de reatribuir a lista (o que pode não atualizar o objeto reativo original),
                                // limpe e adicione os itens da lista reordenada à lista original.
                                checkList.questions!.clear();
                                checkList.questions!.addAll(orderedQuestions);
                                Controller.to.editChecklist();
                                Get.back();
                              },
                              child: CommonWidgets.buildText("Salvar", 14,
                                  Colors.white, TextAlign.center))),
                    ],
                  ).marginOnly(bottom: height * 0.03),
                ],
              ),
            ),
          ),
        ));
  }

  // Método que monta a lista de questões com drag-and-drop mantendo visual similar ao original
  Widget buildReorderableQuestions(
      double height,
      double width,
      bool small,
      CheckListSkeletonReactive checkList,
      RxList<QuestionSkeletonReactive> orderedQuestions) {
    return Obx(() => ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final movedQuestion = orderedQuestions.removeAt(oldIndex);
            orderedQuestions.insert(newIndex, movedQuestion);
          },
          children: List.generate(orderedQuestions.length, (index) {
            final question = orderedQuestions[index];
            return Container(
              key: ValueKey(question.id ?? index),
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Ícone para drag
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle, color: Colors.white),
                  ),
                  // Campo para Categoria
                  Container(
                    width: width * .4,
                    height: height * .12,
                    child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.exo2(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        hintStyle: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      initialValue: question.category!.value,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      onChanged: (newValue) {
                        question.category!.value = newValue;
                      },
                    ),
                  ),
                  // Campo para Descrição
                  Container(
                    width: width * .4,
                    height: height * .12,
                    child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.exo2(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        hintStyle: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      initialValue: question.description!.value,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      onChanged: (newValue) {
                        question.description!.value = newValue;
                      },
                    ),
                  ),
                  // Campo para Tooltip
                  Container(
                    width: width * .4,
                    height: height * .12,
                    child: TextFormField(
                      autofocus: false,
                      style: GoogleFonts.exo2(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        hintStyle: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      initialValue: question.tooltip!.value,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      onChanged: (newValue) {
                        question.tooltip!.value = newValue;
                      },
                    ),
                  ),
                  // Campo para Posição (apenas para visualização)
                  Container(
                    width: width * .1,
                    child: TextFormField(
                      initialValue: question.position!.value,
                      autofocus: false,
                      style: GoogleFonts.exo2(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)),
                      decoration: InputDecoration(
                        hintText: 'Posição',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        hintStyle: GoogleFonts.exo2(
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (newValue) {
                        // A posição será atualizada via reordenamento
                      },
                    ),
                  ),
                  // Botão Remover
                  Container(
                    width: width * .05,
                    child: IconButton(
                        tooltip: "Remover",
                        onPressed: () {
                          orderedQuestions.removeAt(index);
                        },
                        icon: Icon(Icons.remove_circle_outline,
                            color: PersonalizedColors.errorColor)),
                  )
                ],
              ),
            );
          }),
        ));
  }

  buildEmails(double height, double width, bool small) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: PersonalizedColors.blueGrey, width: 1.0),
    );
    List<Widget> containers = [];
    for (var email
        in Controller.to.checklistToEdit!.interestedPartiesEmailList!) {
      containers.add(Container(
        width: width * .5,
        child: Row(
          children: [
            AutoSizeText(email.email!.value!,
                style:
                    GoogleFonts.exo2(textStyle: TextStyle(color: Colors.white)),
                maxLines: 2,
                maxFontSize: 14,
                textAlign: TextAlign.start),
            Container(
                width: width * .05,
                child: IconButton(
                    tooltip: "Remover",
                    onPressed: () {
                      Controller.to.checklistToEdit!.interestedPartiesEmailList!
                          .remove(email);
                      Get.back();
                      editUser(Get.context);
                    },
                    icon: Icon(Icons.remove_circle_outline,
                        color: PersonalizedColors.errorColor)))
          ],
        ),
      ));
    }
    containers.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
                width: small ? width * .3 : width * .3,
                height: height * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          InterestedPartiesEmailReactiveEntity party =
                              InterestedPartiesEmailReactiveEntity();
                          return AlertDialog(
                            backgroundColor: PersonalizedColors.skyBlue,
                            content: Container(
                                child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                  Container(
                                    width: small ? width * .7 : width * .4,
                                    height: height * .07,
                                    child: TextFormField(
                                        autofocus: false,
                                        style: GoogleFonts.exo2(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                        decoration: InputDecoration(
                                          hintText: "E-mail Interessado",
                                          border: outlineInputBorder,
                                          enabledBorder: outlineInputBorder,
                                          focusedBorder: enableBorder,
                                          errorStyle: GoogleFonts.exo2(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red)),
                                          hintStyle: GoogleFonts.exo2(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                        ),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          party.email = value.obs;
                                        }),
                                  ).marginOnly(top: height * 0.05)
                                ])),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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
                                              backgroundColor:
                                                  PersonalizedColors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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
        Container(
                width: small ? width * .3 : width * .3,
                height: height * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      QuestionSkeletonReactive questionSkeletonReactive =
                          QuestionSkeletonReactive(
                              category: RxString(""),
                              description: RxString(""),
                              tooltip: RxString(""));
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: PersonalizedColors.skyBlue,
                            content: Container(
                              width: width * .6,
                              child: Column(
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
                                    SizedBox(height: height * 0.02),
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
                                    SizedBox(height: height * 0.02),
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
                                    SizedBox(height: height * 0.02),
                                  ]),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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
                                              backgroundColor:
                                                  PersonalizedColors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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
    return containers;
  }

  buildQuestions(double height, double width, bool small,
      CheckListSkeletonReactive checklist) {
    // Método antigo para referência (agora substituído pelo ReorderableListView)
    checklist.questions!.sort((a, b) =>
        int.parse(a.position!.value!).compareTo(int.parse(b.position!.value!)));
    List<Row> rows = [];
    for (var question in checklist.questions!) {
      TextEditingController textController =
          TextEditingController(text: question.position!.value!);
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          width: width * .4,
          height: height * .12,
          child: TextFormField(
              autofocus: false,
              style: GoogleFonts.exo2(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                hintStyle: GoogleFonts.exo2(
                    textStyle: TextStyle(fontSize: 14, color: Colors.white)),
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
              style: GoogleFonts.exo2(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                hintStyle: GoogleFonts.exo2(
                    textStyle: TextStyle(fontSize: 14, color: Colors.white)),
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
              style: GoogleFonts.exo2(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                hintStyle: GoogleFonts.exo2(
                    textStyle: TextStyle(fontSize: 14, color: Colors.white)),
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
                  style: GoogleFonts.exo2(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  decoration: InputDecoration(
                    hintText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Posição',
                    labelStyle: GoogleFonts.exo2(
                        textStyle:
                            TextStyle(fontSize: 14, color: Colors.white)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    hintStyle: GoogleFonts.exo2(
                        textStyle:
                            TextStyle(fontSize: 14, color: Colors.white)),
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
                icon: Icon(Icons.remove_circle_outline,
                    color: PersonalizedColors.errorColor)))
      ]));
    }
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
                width: small ? width * .3 : width * .3,
                height: height * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      QuestionSkeletonReactive questionSkeletonReactive =
                          QuestionSkeletonReactive(
                              category: RxString(""),
                              description: RxString(""),
                              tooltip: RxString(""));
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: PersonalizedColors.skyBlue,
                            content: Container(
                              width: width * .6,
                              child: Column(
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
                                    SizedBox(height: height * 0.02),
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
                                    SizedBox(height: height * 0.02),
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
                                    SizedBox(height: height * 0.02),
                                  ]),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: width * .15,
                                      height: height * .1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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
                                              backgroundColor:
                                                  PersonalizedColors.lightGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
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

  Widget _buildBottomSheetCopy(BuildContext context,
      ScrollController scrollController, double bottomSheetOffset) {
    return SafeArea(
        child: copyCheckListWidget(context, Controller.to.checklistToCopy!));
  }

  copyCheckListWidget(
      BuildContext context, CheckListSkeletonReactive checkList) {
    final width = MediaQuery.of(context).size.width * 0.6;
    final height = MediaQuery.of(context).size.height * 0.6;
    bool small = false;

    List<String> productsName = Controller.to.buildProductNameList();
    var auxProducts = Controller.to.getProductsList();
    List<ProductEntityReactive> products = [];
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
      if (item.id == checkList.productId!.value) {
        product = item.name!.value!.obs;
        break;
      }
    }

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    );
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: PersonalizedColors.blueGrey, width: 1.0),
    );
    return SafeArea(
        bottom: true,
        child: Material(
            color: PersonalizedColors.skyBlue,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: Container(
                padding:
                    EdgeInsets.only(bottom: 10, top: 50, left: 80, right: 80),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      width: small ? width * .7 : width * .25,
                      height: height * .07,
                      child: TextFormField(
                          autofocus: false,
                          style: GoogleFonts.exo2(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          decoration: InputDecoration(
                            border: outlineInputBorder,
                            enabledBorder: outlineInputBorder,
                            focusedBorder: enableBorder,
                            errorStyle: GoogleFonts.exo2(
                                textStyle:
                                    TextStyle(fontSize: 14, color: Colors.red)),
                            hintStyle: GoogleFonts.exo2(
                                textStyle: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          initialValue: checkList.title!.value,
                          textAlign: TextAlign.center,
                          onChanged: (String? newValue) {
                            checkList.title!.value = newValue!;
                          }),
                    ).marginOnly(left: width * .5, right: width * .5),
                    SizedBox(height: height * 0.02),
                    Obx(() => Container(
                          width: small ? width * .7 : width * .4,
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
                                if (item.name!.value == value) {
                                  checkList.productId!.value = item.id!;
                                  break;
                                }
                              }
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return productsName
                                  .map<Widget>((String item) => Container(
                                        alignment: Alignment.center,
                                        child: CommonWidgets.buildText(item, 14,
                                            Colors.white, TextAlign.center),
                                      ))
                                  .toList();
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
                          ).marginOnly(left: 10, right: 10),
                        ).marginOnly(left: width * .5, right: width * .5)),
                    SizedBox(height: height * 0.02),
                    Container(
                        width: small ? width * .7 : width * .25,
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
                            return sectorList
                                .map<Widget>((String item) => Container(
                                      alignment: Alignment.center,
                                      child: CommonWidgets.buildText(item, 14,
                                          Colors.white, TextAlign.center),
                                    ))
                                .toList();
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
                            .marginOnly(left: 10, right: 10)
                            .marginOnly(left: width * .5, right: width * .5)),
                    SizedBox(height: height * 0.02),
                    Obx(() => Container(
                          child: Column(
                              children: buildQuestions(
                                  height, width, small, checkList)),
                        ).marginOnly(top: height * 0.05)),
                    Container(
                            width: small ? width * .3 : width * .05,
                            height: height * .05,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60.0),
                                    )),
                                onPressed: () {
                                  Controller.to.editClonelist();
                                  Get.back();
                                },
                                child: CommonWidgets.buildText(
                                    "Salvar",
                                    14,
                                    PersonalizedColors.skyBlue,
                                    TextAlign.center)))
                        .marginOnly(left: width * .6, right: width * .6),
                  ],
                ))));
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
                      backgroundColor: PersonalizedColors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ],
            content: Text(
              'Não é possível intercalar categorias!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            actionsOverflowButtonSpacing: 50,
            backgroundColor: PersonalizedColors.blueGrey,
            title: Text(
              'Verifique a ordenação',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
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
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      actionsOverflowButtonSpacing: 50,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: PersonalizedColors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  )),
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Não',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: PersonalizedColors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  )),
              onPressed: () {
                Controller.to.deleteCheklist(checkListSkeletonReactive.id!);
                Controller.to.getChecklistSkeleton();
                Get.back();
              },
              child: Text(
                'Sim',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
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
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ));
  }
}
