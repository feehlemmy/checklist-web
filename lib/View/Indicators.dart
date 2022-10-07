import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:get/get.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Indicators extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<ProductEntityReactive>>(
            future: Controller.to.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: LayoutBuilder(builder: (context, constrainsts) {
                    return OrientationBuilder(builder: (context, orientation) {
                      return orientation == Orientation.portrait
                          ? buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, true)
                          : buildPage(constrainsts.maxHeight,
                              constrainsts.maxWidth, false);
                    });
                  }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  buildPage(double width, double height, bool small) {
    // ignore: unused_local_variable
    RxBool? finded;
    // ignore: unused_local_variable
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
    // ignore: unused_local_variable
    var enableBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: PersonalizedColors.blueGrey,
        width: 1.0,
      ),
    );
    // ignore: unused_local_variable

    List<String> monthList = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    List<String> yearsList = [
      '2021',
      '2022',
      '2023',
      '2024',
      '2025',
      '2026',
      '2027',
      '2028',
      '2029',
      '2030',
      '2031',
      '2032',
      '2033',
      '2034',
      '2035',
      '2036',
      '2037',
      '2038',
      '2039',
      '2040',
      '2041',
      '2042',
      '2043',
      '2044',
      '2045',
      '2046',
      '2047',
      '2048',
      '2049',
      '2050',
      '2051',
    ];

    RxString monthValue = 'Janeiro'.obs;
    RxString yearValue = '2022'.obs;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: small == true ? width * .2 : width * .35,
                      height: height * .04,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        // Not necessary for Option 1
                        onChanged: (String? newValue) {
                          monthValue.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return monthList.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },

                        items: monthList.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: monthValue.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ),
                    Container(
                      width: small == true ? width * .2 : width * .35,
                      height: height * .04,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: DropdownButton(
                        // Not necessary for Option 1
                        onChanged: (String? newValue) {
                          yearValue.value = newValue!;
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return yearsList.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.center,
                              child: CommonWidgets.buildText(
                                  item, 14, Colors.white, TextAlign.center),
                            );
                          }).toList();
                        },

                        items: yearsList.map((String option) {
                          return DropdownMenuItem(
                            child: CommonWidgets.buildText(
                                option, 14, Colors.white, TextAlign.center),
                            value: option,
                          );
                        }).toList(),
                        value: yearValue.value,
                        dropdownColor: PersonalizedColors.skyBlue,
                        isExpanded: true,
                        isDense: false,
                        underline: SizedBox(),
                      ).marginOnly(
                        left: 10,
                        right: 10,
                      ),
                    ),
                    Container(
                      width: small == true ? width * .2 : width * .2,
                      height: height * .04,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: PersonalizedColors.lightGreen,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                              )),
                          onPressed: () async {
                            Controller.to.visibleIndicators.value = true;
                            bool aux = await Controller.to
                                .searchResponseCheckListForIndicators(
                                    monthValue.value!, yearValue.value!);

                            finded = aux.obs;
                            Controller.to.visibleIndicators.value = false;

                            if (Controller.to.ansewersListReactive.isEmpty) {
                              Controller.to.snackbar(
                                  'Por favor verifique os parâmetros de busca',
                                  'Não foi possível encontrar checklists',
                                  PersonalizedColors.errorColor);
                            }
                          },
                          child: CommonWidgets.buildText(
                              "Buscar", 14, Colors.white, TextAlign.center)),
                    ).marginOnly(left: width * 0.02),
                  ]).paddingAll(width * 0.05),
            ),
          ),
          Obx(() => Controller.to.visibleIndicators.value == true
              ? Container(
                  alignment: Alignment.center,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        angleRange: 360,
                        spinnerMode: true,
                        size: 80,
                        customColors: CustomSliderColors(
                            progressBarColor: PersonalizedColors.darkGreen)),
                  )).marginOnly(top: height * 0.2)
              : Container(
                  child: Controller.to.testedForReproved.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                        width: width * 0.25,
                                        child: AutoSizeText(
                                            "Total Testado: " +
                                                Controller
                                                    .to
                                                    .testedForReproved[
                                                        'Aprovado']!
                                                    .toInt()
                                                    .toString(),
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              color: Colors.white,
                                            )),
                                            maxLines: 2,
                                            maxFontSize: 14,
                                            textAlign: TextAlign.start))
                                    .marginOnly(top: height * 0.02),
                                Container(
                                        width: width * 0.25,
                                        child: AutoSizeText(
                                            "Total Reprovado: " +
                                                Controller
                                                    .to
                                                    .testedForReproved[
                                                        'Reprovado']!
                                                    .toInt()
                                                    .toString(),
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              color: Colors.white,
                                            )),
                                            maxLines: 2,
                                            maxFontSize: 14,
                                            textAlign: TextAlign.start))
                                    .marginOnly(top: height * 0.02),
                                Container(
                                        width: width * 0.25,
                                        child: AutoSizeText(
                                            "Taxa de Reprovação: " +
                                                ((Controller.to.testedForReproved[
                                                                'Reprovado']! /
                                                            Controller.to
                                                                    .testedForReproved[
                                                                'Aprovado']!) *
                                                        100)
                                                    .toStringAsFixed(2) +
                                                '%',
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                              color: Colors.white,
                                            )),
                                            maxLines: 2,
                                            maxFontSize: 14,
                                            textAlign: TextAlign.start))
                                    .marginOnly(top: height * 0.02),
                                PieChart(
                                  dataMap: Controller.to.testedForReproved,
                                  animationDuration:
                                      Duration(milliseconds: 1600),
                                  chartLegendSpacing: 20,
                                  chartRadius: 90,
                                  colorList: [
                                    PersonalizedColors.errorColor,
                                    PersonalizedColors.darkGreen
                                  ],
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 32,
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: true,
                                    legendPosition: LegendPosition.bottom,
                                    showLegends: true,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValueBackground: false,
                                    chartValueStyle: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    )),
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: true,
                                    decimalPlaces: 1,
                                  ),
                                ),
                              ],
                            ).marginOnly(
                                bottom: height * 0.05, top: height * 0.05),
                            Controller.to.causeMapTotal.isEmpty
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: width * 0.25,
                                          child: AutoSizeText(
                                              "Causas de Reprovas: ",
                                              style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                color: Colors.white,
                                              )),
                                              maxLines: 2,
                                              maxFontSize: 14,
                                              textAlign: TextAlign.start)),
                                      PieChart(
                                        dataMap: Controller.to.causeMapTotal,
                                        animationDuration:
                                            Duration(milliseconds: 1600),
                                        chartLegendSpacing: 32,
                                        chartRadius: 90,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,
                                        ringStrokeWidth: 32,
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: true,
                                          legendPosition: LegendPosition.right,
                                          showLegends: true,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: true,
                                          showChartValues: true,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                        ),
                                      ),
                                    ],
                                  ).marginOnly(
                                    right: small ? 0 : width * .9,
                                    left: width * .0),
                          ],
                        )
                      : Container())),
        ]);
  }

  buildCauses(double height, double width, bool small) {
    List<Widget> rows = List.empty(growable: true);
    Controller.to.causeMapTotal.forEach((key, value) {
      rows.add(Row(children: [
        CommonWidgets.buildText(key, 14, Colors.white, TextAlign.center),
        CommonWidgets.buildText(
            value.toInt().toString(), 14, Colors.white, TextAlign.center)
      ]));
    });
    return rows;
  }
}
