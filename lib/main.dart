import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:projeto_kva/Utils/PersonalizedColors.dart';

import 'View/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CheckList KVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: PersonalizedColors.skyBlue,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
          )),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Get.deviceLocale,
      home: Home(),
    );
  }
}
