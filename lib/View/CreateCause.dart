import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/Repository/Entity/Cause.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';

class CreateCause extends StatelessWidget {
  const CreateCause({Key? key}) : super(key: key);
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
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );
    Cause cause = Cause(cause: '');
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(height: height * 0.015),
      Container(
        width: small == true ? width * .7 : width * .25,
        height: height * .07,
        child: TextFormField(
          autofocus: false,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: Colors.white, fontSize: 14)),
          decoration: InputDecoration(
            hintText: "Resumo da Causa",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Resumo da Causa',
            labelStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            )),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: enableBorder,
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
          onChanged: (value) => cause.cause = value,
        ),
      ),
      Container(height: height * 0.015),
      Container(height: height * 0.025),
      Container(
        width: small == true ? width * .3 : width * .1,
        height: height * .05,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: PersonalizedColors.lightGreen,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(60.0),
                )),
            onPressed: () => {Controller.to.createCause(cause)},
            child: CommonWidgets.buildText(
                "Salvar", 14, Colors.white, TextAlign.center)),
      ),
    ]));
  }
}
