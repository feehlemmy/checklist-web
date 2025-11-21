import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:get/get.dart';
import 'package:projeto_kva/View/EmptyScreen.dart';

import 'Dashboard.dart';
import 'EmptyScreen.dart';

class AdministrateProduct extends StatelessWidget {
  const AdministrateProduct({Key? key}) : super(key: key);

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
    RxList<Obx> cards =
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

  List<Obx> buildCards(double height, double width, bool small, String filter,
      BuildContext context) {
    List<ProductEntityReactive> productFiltered = [];
    RxList<Obx> cards = RxList.empty();
    RxList<ProductEntityReactive> productList =
        Controller.to.getProductsList().obs;
    productList.sort((a, b) => a.name!.value!.compareTo(b.name!.value!));

    if (!filter.isBlank!) {
      for (ProductEntityReactive product in productList) {
        String name = product.name!.value!;
        if (name.toUpperCase().contains(filter.toUpperCase())) {
          productFiltered.add(product);
        }
      }
    } else {
      productFiltered = productList;
    }

    for (int i = 0; i < productFiltered.length; i++) {
      ProductEntityReactive productAux = productFiltered[i];
      final product = productAux.obs;
      cards.add(Obx(() => Container(
            width: small == true ? width * .7 : width * .1,
            height: height * .2,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonWidgets.buildText(product.value!.name!.value!, 14,
                    Colors.white, TextAlign.center),
                Container(
                  height: 0.5,
                ),
                Obx(() => Controller.to
                    .userIsDisableText(product.value!.status!.value)),
                CommonWidgets.buildText(product.value!.category!.value!, 14,
                    Colors.white, TextAlign.center),
                Container(
                  height: 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        tooltip: 'Editar',
                        onPressed: () {
                          Controller.to.productToEdit = productAux;
                          editUser(context);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                    Obx(() => Controller.to
                        .getIconDeleteOrRestoreProduct(product.value!)),
                  ],
                ),
              ],
            ),
          )));
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
      child: buildCompleteCheckList(context, Controller.to.productToEdit!),
    );
  }

  buildCompleteCheckList(BuildContext context, ProductEntityReactive product) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = MediaQuery.of(context).size.height * 0.8;
    bool small = false;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      small = true;
    }
    var items = <String>[
      "QTA/QCTA",
      'Atuador',
      'Regulador',
      'Sensor',
      'Carregador',
      'Controlador',
      'Acessório'
    ];

    RxString optionValue = Controller.to.productToEdit!.category!.value!.obs;
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
              height: height * .07,
              child: TextFormField(
                  autofocus: false,
                  style: GoogleFonts.exo2(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  decoration: InputDecoration(
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
                  initialValue: product.name!.value,
                  textAlign: TextAlign.center,
                  onChanged: (String? newValue) {
                    product.name!.value = newValue!;
                  }),
            ),
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
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: DropdownButton(
                    // Not necessary for Option 1
                    onChanged: (String? newValue) {
                      optionValue.value = newValue!;
                      product.category!.value = newValue!;
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
                )),
            Container(
              height: height * 0.02,
            ),
            Container(
              height: height * 0.02,
            ),
            Container(
                width: small == true ? width * .3 : width * .25,
                height: height * .05,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(60.0),
                        )),
                    onPressed: () {
                      Controller.to.editProduct();

                      Get.to(EmptyScreen());
                      Get.to(Dashboard(items: Controller.to.items));
                    },
                    child: CommonWidgets.buildText("Salvar", 14,
                        PersonalizedColors.skyBlue, TextAlign.center))),
          ],
        ),
      ),
    );
  }
}
