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
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        return _buildPage();
      });
    });
  }

  Widget _buildPage() {
    final List<String> sectors = [
      Constants.assistencia,
      Constants.administrativo,
      Constants.gerenteDeProducao,
      Constants.producao,
      Constants.controleDeQualidade,
      Constants.inspecaoFinal,
      Constants.inspecaoVisual,
    ]..sort();

    final Get.RxString selectedSector = Constants.producao.obs;

    final user = UserEntityReactive(
      name: ''.obs,
      password: ''.obs,
      sector: selectedSector,
      username: ''.obs,
    );

    final fieldWidth = Device.screenType == ScreenType.mobile ? 85.w : 35.w;

    return Center(
      child: Card(
        color: PersonalizedColors.skyBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Nome", user.name!, fieldWidth),
              SizedBox(height: 2.h),
              _buildTextField("Login", user.username!, fieldWidth),
              SizedBox(height: 2.h),
              _buildTextField("Senha", user.password!, fieldWidth,
                  obscure: true),
              SizedBox(height: 2.h),
              _buildDropdown(sectors, selectedSector, user, fieldWidth),
              SizedBox(height: 3.h),
              SizedBox(
                width: fieldWidth,
                height: 6.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PersonalizedColors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                  onPressed: () => Controller.to.createUser(user),
                  child: CommonWidgets.buildText(
                      "Salvar", 14, Colors.white, TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Get.RxString controller, double width,
      {bool obscure = false}) {
    return CommonWidgets.buildTextFormWithoutValidationForEntities(
      7.h,
      width,
      Colors.white,
      null,
      label,
      12,
      controller,
    );
  }

  Widget _buildDropdown(List<String> items, Get.RxString selected,
      UserEntityReactive user, double width) {
    return Get.Obx(() => Container(
          width: width,
          height: 6.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: DropdownButton<String>(
            onChanged: (value) {
              if (value != null) {
                user.sector!.value = value;
                selected.value = value;
              }
            },
            value: selected.value,
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: PersonalizedColors.skyBlue,
            iconEnabledColor: Colors.white,
            items: items
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: CommonWidgets.buildText(
                          option, 12, Colors.white, TextAlign.center),
                    ))
                .toList(),
            selectedItemBuilder: (context) => items
                .map((item) => Align(
                      alignment: Alignment.center,
                      child: CommonWidgets.buildText(
                          item, 12, Colors.white, TextAlign.center),
                    ))
                .toList(),
          ),
        ));
  }
}
