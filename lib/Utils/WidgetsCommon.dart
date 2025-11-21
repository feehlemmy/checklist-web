import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/Utils/PersonalizedColors.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:responsive_sizer/responsive_sizer.dart';

class CommonWidgets {
  static DateFormat getFormatter() {
    return new DateFormat('dd/MM/yyyy HH:mm:ss');
  }

  static AutoSizeText buildText(
      String text, double size, Color color, TextAlign align) {
    return AutoSizeText(
      text,
      style: GoogleFonts.exo2(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
        ),
      ),
      textAlign: align,
      maxLines: 2,
    );
  }

  static buildTextFormWithoutValidationForEntities(double height, double width,
      Color color, Icon? icon, String hint, double fontSize, variable) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: color,
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

    return Container(
      width: width,
      height: height,
      child: TextFormField(
        autofocus: false,
        cursorColor: Colors.white,
        style: GoogleFonts.exo2(
            textStyle: TextStyle(color: color, fontSize: fontSize)),
        decoration: InputDecoration(
          prefixIcon: icon,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hint,
          labelText: hint,
          labelStyle: GoogleFonts.exo2(
              textStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          )),
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
            color: color,
          )),
        ),
        textAlign: TextAlign.center,
        onChanged: (value) => variable.value = value,
      ),
    );
  }

  static generatePdf(
      CheckListAnswerReactive checkListAnswer,
      double height,
      double width,
      bool small,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory) {
    final formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');

    return [
      pw.Column(children: [
        pw.Container(
            child: pw.Text(checkListAnswer.title!.value!,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 14,
                ))),
        pw.Container(height: height * 0.02),
        pw.Container(
            width: width * 0.8,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Container(
                      width: width * 0.26,
                      child: pw.Text("Lote: " + checkListAnswer.batch!.value!,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 14,
                          ))),
                  pw.Container(
                    width: width * 0.26,
                    child: pw.Text(
                        "Nº de Série: " + checkListAnswer.serieNumber!.value!,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14,
                        )),
                  ),
                  pw.Container(
                    width: width * 0.26,
                    child: pw.Text(
                        "Versão: " + checkListAnswer.productVersion!.value!,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14,
                        )),
                  ),
                ])),
        pw.Container(height: height * 0.02),
        pw.Container(
            width: width * 0.8,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Container(
                    width: width * 0.4,
                    child: pw.Text(
                        "Reponsável: " + checkListAnswer.nameOfUser!.value!,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14,
                        )),
                  ),
                  pw.Container(
                    width: width * 0.4,
                    child: pw.Text(
                        "Data: " + formatter.format(checkListAnswer.date!),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14,
                        )),
                  ),
                ])),
        pw.Container(height: height * 0.02),
        pw.Container(
            width: width * 0.8,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Column(children: [
                  pw.Container(
                    width: width * 0.25,
                    child: pw.Text("Setor: " + checkListAnswer.sector!.value!,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14,
                        )),
                  ),
                  checkListAnswer.origin != null &&
                          checkListAnswer.origin!.value! != ""
                      ? pw.Container(
                          width: width * 0.25,
                          child: pw.Text(
                              "Origem: " + checkListAnswer.origin!.value!,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 14,
                              )),
                        )
                      : pw.Container(
                          width: width * 0.25,
                        ),
                  checkListAnswer.testEnvironment != null &&
                          checkListAnswer.testEnvironment!.value! != ""
                      ? pw.Container(
                          width: width * 0.25,
                          child: pw.Text(
                              "Ambiente de Teste: " +
                                  checkListAnswer.testEnvironment!.value!,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 14,
                              )),
                        )
                      : pw.Container(
                          width: width * 0.25,
                        ),
                ]),
              ],
            )),
        pw.Container(height: height * 0.02),
        checkListAnswer.statusOfCheckList! == "Retrabalhado" ||
                checkListAnswer.statusOfCheckList! == "Retrabalho"
            ? pw.Container(
                width: width * 0.8,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Container(
                        width: width * 0.4,
                        child: pw.Text(
                            "Responsável Manutenção: " +
                                checkListAnswer.nameOfUserAssistance!,
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 14,
                            )),
                      ),
                      pw.Container(
                        width: width * 0.4,
                        child: pw.Text(
                            "Data Manutenção: " +
                                formatter
                                    .format(checkListAnswer.dateAssistance!),
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 14,
                            )),
                      ),
                      pw.Container(
                        width: width * 0.25,
                      )
                    ]))
            : pw.Container(),
        pw.Container(height: height * 0.02),
        checkListAnswer.statusOfCheckList! == "Retrabalhado" ||
                checkListAnswer.statusOfCheckList! == "Retrabalho"
            ? pw.Container(
                width: width * 0.8,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Container(
                      width: width * 0.25,
                      child: pw.Text("Retrabalhado: ",
                          style: pw.TextStyle(
                            color: PdfColors.orange,
                          )),
                    ),
                    pw.Column(children: [
                      pw.Container(
                          width: width * 0.4,
                          child: pw.Text("Causa: " + checkListAnswer.cause!,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 14,
                              ))),
                      checkListAnswer.causeDescription != null
                          ? pw.Container(
                              width: width * 0.4,
                              child: pw.Text(
                                  "Solução: " +
                                      checkListAnswer.causeDescription!,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 14,
                                  )),
                            )
                          : pw.Container()
                    ]),
                    pw.Container(
                      width: width * 0.25,
                    ),
                  ],
                ))
            : checkListAnswer.statusOfCheckList == "Aprovado"
                ? pw.Container(
                    width: width * 0.8,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: width * 0.25,
                            child: pw.Text("Produto Aprovado",
                                style: pw.TextStyle(
                                  color: PdfColors.green,
                                )),
                          )
                        ]))
                : pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                        pw.Container(
                          width: width * 0.25,
                          child: pw.Text("Produto Reprovado",
                              style: pw.TextStyle(
                                color: PdfColors.red,
                              )),
                        )
                      ]),
        pw.Container(height: height * 0.04),
        pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.Container(
                  child: buildQuestions(height, width, small,
                      listQuestionsSplitedByCategory, checkListAnswer)),
              checkListAnswer.observation!.value! != ""
                  ? pw.Container(
                      width: width * 0.5,
                      child: pw.Text(
                          "Observação: " + checkListAnswer.observation!.value!,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 14,
                          )),
                    )
                  : pw.Container(),
              checkListAnswer.statusOfProduct != null
                  ? pw.Container(
                      width: width * 0.5,
                      child: pw.Text(
                          "Motivo da Reprova: " +
                              checkListAnswer.statusOfProduct!,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 14,
                          )),
                    )
                  : pw.Container()
            ]))
      ])
    ];
  }

  static pw.Table buildQuestions(
      double height,
      double width,
      bool small,
      List<QuestionAnswerReactive> listQuestionsSplitedByCategory,
      CheckListAnswerReactive answer) {
    String category = "A";

    List<pw.TableRow> rows = [];
    rows.add(pw.TableRow(children: [
      pw.Container(
        height: height * 0.02,
      ),
      pw.Container(),
      pw.Container(),
      pw.Container(),
    ]));
    for (QuestionAnswerReactive question in listQuestionsSplitedByCategory) {
      buildCategoryWidget(category, question, rows, width);

      buildQuestionWidget(rows, question, height, width, small, answer);

      category == question.category!.value!
          ? category = category
          : category = question.category!.value!;
    }

    return pw.Table(
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: {
        0: pw.FlexColumnWidth(width * 0.1),
        1: pw.FlexColumnWidth(width * 0.2),
        2: pw.FlexColumnWidth(width * 0.05),
        3: pw.FlexColumnWidth(width * 0.01),
      },
      children: rows,
    );
  }

  static void buildQuestionWidget(
      List<pw.TableRow> rows,
      QuestionAnswerReactive question,
      double height,
      double width,
      small,
      CheckListAnswerReactive answer) {
    String status = '';
    // ignore: unused_local_variable
    PdfColor colorStatus = PdfColors.black;
    if (question.approved == null) {
      question.approved = false.obs;
    }
    if (question.disapproved == null) {
      question.disapproved = false.obs;
    }
    if (question.approved!.value! == false &&
        question.disapproved!.value! == false) {
      status = "Não testado";
    } else if (question.approved!.value! == false &&
        question.disapproved!.value! == true) {
      status = "Reprovado";
      colorStatus = PdfColors.red;
    } else if (question.approved!.value! == true &&
        question.disapproved!.value! == false) {
      status = "Aprovado";
      colorStatus = PdfColors.green;
    }
    rows.add(pw.TableRow(
      children: [
        pw.Container(),
        pw.Container(
          child: pw.Text(
            question.description!.value!,
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Container(
          width: width * 0.01,
          child: pw.Text(status,
              style: pw.TextStyle(
                color: colorStatus,
                fontSize: 14,
              )),
        ),
        pw.Container(height: height * 0.02),
      ],
    ));
  }

  static void buildCategoryWidget(String category,
      QuestionAnswerReactive question, List<pw.TableRow> rows, double width) {
    category == question.category!.value!
        ? rows.isEmpty
            ? rows.add(pw.TableRow(children: [
                pw.Container(
                    child: pw.Text(
                  question.category!.value!,
                )),
                pw.Container(),
                pw.Container(),
                pw.Container(),
              ]))
            : pw.TableRow(children: [
                pw.Container(),
                pw.Container(),
                pw.Container(),
                pw.Container(),
              ])
        : rows.add(pw.TableRow(children: [
            pw.Container(
                child: pw.Text(
              question.category!.value!,
              style: pw.TextStyle(
                fontSize: 14,
              ),
            )),
            pw.Container(),
            pw.Container(),
            pw.Container(),
          ]));
  }
}
