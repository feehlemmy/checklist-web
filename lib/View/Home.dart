import 'package:flutter/material.dart';

import 'package:get/get.dart' as Get;
import 'package:projeto_kva/Controller/HomeController.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return Scaffold(
        backgroundColor: PersonalizedColors.skyBlue,
        body: Get.GetBuilder<HomeController>(
            init: HomeController(),
            builder: (_) {
              return buildPage();
            }),
      );
    });
  }

  buildPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 12.w, height: 12.h),
        buildLoginForm(),
        Container(
          height: 12.h,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: HomeController.to.getImageBackground(),
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight),
          ),
        ).marginOnly(right: 02.w),
      ],
    );
  }

  buildButtonLogin() {
    return Container(
      width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
      height: 5.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: PersonalizedColors.skyBlue,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(60.0),
            )),
        onPressed: () => {HomeController.to.validateFields()},
        child: AutoSizeText(
          "Entrar",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          maxLines: 1,
        ),
      ),
    ).marginOnly(top: 1.h);
  }

  buildLoginForm() {
    print(Device.screenType);
    return Center(
      child: Column(
        children: [
          Container(
            width: Device.screenType == ScreenType.mobile ? 60.w : 30.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: HomeController.to.getImageBackgroundForm(),
                          fit: BoxFit.scaleDown,
                          alignment: Alignment(0, -1)),
                    ),
                  ),
                  Container(height: 5.h),
                  buildUserNameField(),
                  buildPasswordField(),
                  buildButtonLogin(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildPasswordField() {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.skyBlue,
        width: 1.0,
      ),
    );

    return Get.Obx(() => Container(
          width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
          height: 7.h,
          child: TextFormField(
            autofocus: false,
            cursorColor: PersonalizedColors.skyBlue,
            keyboardType: TextInputType.visiblePassword,
            obscureText: HomeController.to.hiddenPassword.value!,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              fontSize: 12,
              color: PersonalizedColors.skyBlue,
            )),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: PersonalizedColors.skyBlue,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    HomeController.to.hiddenPassword.value!
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: PersonalizedColors.skyBlue,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    HomeController.to.hiddenPassword.toggle();
                    HomeController.to.hiddenPassword.refresh();
                  }),
              hintText: "Senha",
              labelText: 'Senha',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 12,
                color: PersonalizedColors.skyBlue,
              )),
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              errorStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 12,
                color: Colors.red,
              )),
              hintStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 12,
                color: PersonalizedColors.skyBlue,
              )),
            ),
            textAlign: TextAlign.center,
            onChanged: (value) => HomeController.to.password = value,
            onEditingComplete: () {
              HomeController.to.validateFields();
            },
          ),
        ).marginOnly(top: 1.h));
  }

  buildUserNameField() {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.skyBlue,
        width: 1.0,
      ),
    );
    return Container(
      width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
      height: 7.h,
      child: TextFormField(
        autofocus: false,
        cursorColor: PersonalizedColors.skyBlue,
        keyboardType: TextInputType.text,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: PersonalizedColors.skyBlue, fontSize: 12)),
        decoration: InputDecoration(
          fillColor: Colors.white24,
          prefixIcon: Icon(
            Icons.person,
            color: PersonalizedColors.skyBlue,
          ),
          hintText: "Nome de Usuário",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Nome de Usuário',
          labelStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
            fontSize: 12,
            color: PersonalizedColors.skyBlue,
          )),
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          errorStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
            fontSize: 12,
            color: Colors.red,
          )),
          hintStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
            fontSize: 12,
            color: PersonalizedColors.skyBlue,
          )),
        ),
        textAlign: TextAlign.center,
        onChanged: (value) => HomeController.to.username = value,
      ),
    ).marginOnly(top: 1.h);
  }
}
