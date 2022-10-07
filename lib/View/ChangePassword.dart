import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  @override
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
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(height: height * 0.015),
      Obx(() => Container(
            width: small == true ? width * .7 : width * .25,
            height: height * .07,
            child: TextFormField(
              autofocus: false,
              keyboardType: TextInputType.visiblePassword,
              obscureText: Controller.to.hiddenPassword.value!,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      Controller.to.hiddenPassword.value!
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      Controller.to.hiddenPassword.toggle();
                      Controller.to.hiddenPassword.refresh();
                    }),
                hintText: "Senha",
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
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
              onChanged: (value) => Controller.to.password = value,
            ),
          )),
      Container(height: height * 0.015),
      Obx(() => Container(
            width: small == true ? width * .7 : width * .25,
            height: height * .07,
            child: TextFormField(
              autofocus: false,
              keyboardType: TextInputType.visiblePassword,
              obscureText: Controller.to.hiddenPassword.value!,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      Controller.to.hiddenPassword.value!
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      Controller.to.hiddenPassword.toggle();
                      Controller.to.hiddenPassword.refresh();
                    }),
                hintText: "Confime a senha",
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
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
              onChanged: (value) => Controller.to.confirmPassword = value,
            ),
          )),
      Container(height: height * 0.015),
      Container(
        width: small == true ? width * .3 : width * .1,
        height: height * .05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: PersonalizedColors.lightGreen,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(60.0),
              )),
          onPressed: () => {Controller.to.comparePasswords()},
          child: AutoSizeText(
            "Salvar",
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            maxLines: 1,
          ),
        ),
      )
    ]));
  }
}
