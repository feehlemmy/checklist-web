import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/UserEntityReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/Constansts.dart';

class CreateUser extends StatelessWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(builder: (context, constrainsts) {
      return OrientationBuilder(builder: (context, orientation) {
        return buildPage();
      });
    }));
  }

  buildPage() {
    var items = <String>[
      Constants.assistencia,
      Constants.administrativo,
      Constants.gerenteDeProducao,
      Constants.producao,
      Constants.controleDeQualidade,
      Constants.inspecaoFinal,
      Constants.inspecaoVisual,
    ];
    items.sort();
    Get.RxString optionValue = Constants.producao.obs;
    UserEntityReactive user = UserEntityReactive(
        name: ''.obs, password: ''.obs, sector: optionValue, username: ''.obs);
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(height: 1.5.h),
      CommonWidgets.buildTextFormWithoutValidationForEntities(
          7.h,
          Device.screenType == ScreenType.mobile ? 55.w : 25.w,
          Colors.white,
          null,
          "Nome",
          12,
          user.name),
      Container(height: 1.5.h),
      CommonWidgets.buildTextFormWithoutValidationForEntities(
          7.h,
          Device.screenType == ScreenType.mobile ? 55.w : 25.w,
          Colors.white,
          null,
          "Login",
          12,
          user.username),
      Container(height: 1.5.h),
      CommonWidgets.buildTextFormWithoutValidationForEntities(
          7.h,
          Device.screenType == ScreenType.mobile ? 55.w : 25.w,
          Colors.white,
          null,
          "Senha",
          12,
          user.password),
      Container(height: 1.5.h),
      Get.Obx(() => Container(
            width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
            height: 5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: DropdownButton(
              // Not necessary for Option 1
              onChanged: (String? newValue) {
                user.sector!.value = newValue!;
                optionValue.value = newValue;
              },
              selectedItemBuilder: (BuildContext context) {
                return items.map<Widget>((String item) {
                  return Container(
                    alignment: Alignment.center,
                    child: CommonWidgets.buildText(
                        item, 12, Colors.white, TextAlign.center),
                  );
                }).toList();
              },

              items: items.map((String option) {
                return DropdownMenuItem(
                  child: CommonWidgets.buildText(
                      option, 12, Colors.white, TextAlign.center),
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
      Container(height: 2.h),
      Container(
        width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
        height: 5.h,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: PersonalizedColors.lightGreen,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () => {Controller.to.createUser(user)},
            child: CommonWidgets.buildText(
                "Salvar", 12, Colors.white, TextAlign.center)),
      ),
    ]));
  }
}
