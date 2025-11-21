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
          builder: (_) => _buildPage(),
        ),
      );
    });
  }

  Widget _buildPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8.h),
        _buildLoginForm(),
        Container(
          height: 12.h,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 2.w),
          child: Image(
            image: HomeController.to.getImageBackground(),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Container(
        width: Device.screenType == ScreenType.mobile ? 60.w : 30.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
                child: Image(
                  image: HomeController.to.getImageBackgroundForm(),
                  fit: BoxFit.scaleDown,
                ),
              ),
              SizedBox(height: 4.h),
              _buildUserNameField(),
              _buildPasswordField(),
              _buildButtonLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin() {
    return Container(
      width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
      height: 6.h,
      margin: EdgeInsets.only(top: 2.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PersonalizedColors.skyBlue,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          textStyle: GoogleFonts.exo2(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        onPressed: HomeController.to.validateFields,
        child: AutoSizeText(
          "Entrar",
          maxLines: 1,
          style: GoogleFonts.exo2(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildUserNameField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: PersonalizedColors.skyBlue, width: 1.0),
    );

    return Container(
      width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
      height: 7.h,
      margin: EdgeInsets.only(top: 1.5.h),
      child: TextFormField(
        cursorColor: PersonalizedColors.skyBlue,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        style: GoogleFonts.exo2(
          fontSize: 14,
          color: PersonalizedColors.skyBlue,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: PersonalizedColors.skyBlue),
          hintText: "Nome de Usuário",
          labelText: 'Nome de Usuário',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: border,
          enabledBorder: border,
          hintStyle:
              GoogleFonts.exo2(fontSize: 14, color: PersonalizedColors.skyBlue),
          labelStyle:
              GoogleFonts.exo2(fontSize: 14, color: PersonalizedColors.skyBlue),
          errorStyle: GoogleFonts.exo2(fontSize: 14, color: Colors.red),
        ),
        onChanged: (value) => HomeController.to.username = value,
      ),
    );
  }

  Widget _buildPasswordField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: PersonalizedColors.skyBlue, width: 1.0),
    );

    return Get.Obx(() => Container(
          width: Device.screenType == ScreenType.mobile ? 55.w : 25.w,
          height: 7.h,
          margin: EdgeInsets.only(top: 1.5.h),
          child: TextFormField(
            cursorColor: PersonalizedColors.skyBlue,
            keyboardType: TextInputType.visiblePassword,
            obscureText: HomeController.to.hiddenPassword.value!,
            textAlign: TextAlign.center,
            style: GoogleFonts.exo2(
                fontSize: 14, color: PersonalizedColors.skyBlue),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: PersonalizedColors.skyBlue),
              suffixIcon: IconButton(
                icon: Icon(
                  HomeController.to.hiddenPassword.value!
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: PersonalizedColors.skyBlue,
                ),
                onPressed: () => HomeController.to.hiddenPassword.toggle(),
              ),
              hintText: "Senha",
              labelText: 'Senha',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: border,
              enabledBorder: border,
              hintStyle: GoogleFonts.exo2(
                  fontSize: 14, color: PersonalizedColors.skyBlue),
              labelStyle: GoogleFonts.exo2(
                  fontSize: 14, color: PersonalizedColors.skyBlue),
              errorStyle: GoogleFonts.exo2(fontSize: 14, color: Colors.red),
            ),
            onChanged: (value) => HomeController.to.password = value,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => HomeController.to.validateFields(),
          ),
        ));
  }
}
