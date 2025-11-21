import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as Responsive;

class CreateProduct extends StatelessWidget {
  const CreateProduct({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(builder: (context, constrainsts) {
      return OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? buildPage(constrainsts.maxWidth, constrainsts.maxHeight, true)
            : buildPage(constrainsts.maxWidth, constrainsts.maxHeight, false);
      });
    }));
  }

  buildPage(double width, double height, bool small) {
    var items = <String>[
      "QTA/QCTA",
      'Atuador',
      'Regulador',
      'Sensor',
      'Carregador',
      'Controlador',
      'Acessório'
    ];

    items.sort();
    RxString optionValue = 'Atuador'.obs;
    ProductEntityReactive product =
        ProductEntityReactive(name: ''.obs, category: optionValue);
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(height: height * 0.015),
      CommonWidgets.buildTextFormWithoutValidationForEntities(
          height * .07,
          Responsive.Device.screenType == Responsive.ScreenType.mobile
              ? 55.w
              : 25.w,
          Colors.white,
          null,
          "Nome",
          12,
          product.name!),
      Container(height: height * 0.015),
      Obx(() => Container(
            width: small == true ? width * .7 : width * .25,
            height: height * .05,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: DropdownButton(
              // Not necessary for Option 1
              onChanged: (String? newValue) {
                product.category!.value = newValue!;
                optionValue.value = newValue;
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
      Container(height: height * 0.025),
      Container(
        width: small == true ? width * .3 : width * .1,
        height: height * .06,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: PersonalizedColors.lightGreen,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () {
              Controller.to.createProduct(product);
            },
            child: CommonWidgets.buildText(
                "Salvar", 14, Colors.white, TextAlign.center)),
      ),
    ]));
  }
}
