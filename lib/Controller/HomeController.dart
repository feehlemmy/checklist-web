import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projeto_kva/Repository/UserRespository.dart';
import 'package:projeto_kva/Utils/Constansts.dart';

import '../ModelReactive/ItemDrawer.dart';
import '../View/Dashboard.dart';

class HomeController extends GetxController {
  late String token;

  RxBool hiddenPassword = true.obs;
  UserRepository userRepository = UserRepository();
  String username = '';
  String password = '';
  static HomeController get to => Get.find();

  Image image1 = Image.asset(
    "assets/images/logo.png",
    height: 400,
  );

  Image image2 = Image.asset(
    "assets/images/logo_checklist.png",
  );

  getImageBackground() {
    return image1.image;
  }

  getImageBackgroundForm() {
    return image2.image;
  }

  validateFields() async {
    if (validateUserName()) {
      if (validatePassword()) {
        var logged = await userRepository.login(username, password);

        List<ItemDrawer> listOfPagesForUser = filterTypeOfUser(logged.sector);
        if (logged.sector != null) {
          Get.off(Dashboard(items: listOfPagesForUser));
        }
      }
    }
  }

  bool validateUserName() {
    if (username.length < 3) {
      errorSnackbar("Digite um nome de usuário válido");
      return false;
    }
    return true;
  }

  bool validatePassword() {
    if (password.length < 3) {
      errorSnackbar("A senha deve conter no mínimo 6 caracteres");
      return false;
    }
    return true;
  }

  errorSnackbar(String text) {
    return Get.snackbar('Erro', text,
        backgroundColor: Colors.red[200],
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        messageText: buildTextSnackBar(text),
        titleText: buildTextSnackBar('Erro'),
        colorText: Colors.white,
        margin: EdgeInsets.all(10));
  }

  buildTextSnackBar(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 14,
        color: Colors.white,
      )),
      textAlign: TextAlign.center,
    );
  }

  void upDateHiddenPassword(bool bool) {
    hiddenPassword.toggle();
  }
}

filterTypeOfUser(String? sector) {
  List<ItemDrawer> items = List.empty(growable: true);
  if (sector == null) {
    return [];
  } else if (sector == Constants.administrativo) {
    items = [
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(name: 'Criar CheckList', iconData: Icons.add, index: 1),
      ItemDrawer(
          name: 'Administrar CheckLists', iconData: Icons.edit, index: 2),
      ItemDrawer(name: 'Administrar Produtos', iconData: Icons.edit, index: 3),
      ItemDrawer(name: 'Criar Produto', iconData: Icons.add, index: 4),
      ItemDrawer(name: 'Administrar Usuários', iconData: Icons.edit, index: 5),
      ItemDrawer(name: 'Criar Usuário', iconData: Icons.person_add, index: 6),
      ItemDrawer(name: 'Cadastrar Resumo Causa', iconData: Icons.add, index: 7),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
      ItemDrawer(
          name: 'Indicadores', iconData: Icons.bar_chart_rounded, index: 44),
      ItemDrawer(
          name: 'Excluir Checklists Respondidos',
          iconData: Icons.delete_forever,
          index: 9)
    ];
  } else if (sector == Constants.producao) {
    items = [
      ItemDrawer(name: 'Responder CheckLists', iconData: Icons.list, index: 11),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(
        name: 'CheckLists Reprovados',
        iconData: Icons.list,
        index: 12,
      ),
      ItemDrawer(
        name: 'Relatório',
        iconData: Icons.report,
        index: 13,
      ),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  } else if (sector == Constants.assistencia) {
    items = [
      ItemDrawer(name: 'Responder CheckLists', iconData: Icons.list, index: 11),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(
          name: 'CheckLists Reprovados', iconData: Icons.list, index: 12),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  } else if (sector == Constants.controleDeQualidade) {
    items = [
      ItemDrawer(name: 'Responder CheckLists', iconData: Icons.list, index: 11),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(
        name: 'Relatório',
        iconData: Icons.report,
        index: 13,
      ),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  } else if (sector == Constants.gerenteDeProducao) {
    items = [
      ItemDrawer(name: 'Indicadores', iconData: Icons.bar_chart, index: 44),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  } else if (sector == Constants.inspecaoFinal) {
    items = [
      ItemDrawer(name: 'Responder CheckLists', iconData: Icons.list, index: 11),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(
        name: 'CheckLists Reprovados',
        iconData: Icons.list,
        index: 12,
      ),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  } else if (sector == Constants.inspecaoVisual) {
    items = [
      ItemDrawer(name: 'Responder CheckLists', iconData: Icons.list, index: 11),
      ItemDrawer(
          name: 'CheckLists Respondidos', iconData: Icons.list, index: 0),
      ItemDrawer(
        name: 'CheckLists Reprovados',
        iconData: Icons.list,
        index: 12,
      ),
      ItemDrawer(
        name: 'Relatório',
        iconData: Icons.report,
        index: 13,
      ),
      ItemDrawer(name: 'Trocar Senha', iconData: Icons.change_circle, index: 8),
    ];
  }
  return items;
}
