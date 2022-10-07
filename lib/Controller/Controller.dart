import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/ModelReactive/UserEntityReactive.dart';
import 'package:projeto_kva/Repository/CheckListAnswerRepository.dart';
import 'package:projeto_kva/Repository/CheckListSkeletonRepository.dart';
import 'package:projeto_kva/Repository/Entity/Cause.dart';
import 'package:projeto_kva/Repository/ProductRepository.dart';
import 'package:projeto_kva/Repository/UserRespository.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';
import 'package:projeto_kva/View/AnswerChecklist.dart';
import 'package:projeto_kva/View/ChecklistDisapproved.dart';
import 'package:projeto_kva/View/ChecklistReport.dart';
import 'package:projeto_kva/View/Home.dart';
import 'package:projeto_kva/View/Indicators.dart';
import 'package:projeto_kva/View/ViewCheckListSkeleton.dart';

import '../ModelReactive/ItemDrawer.dart';
import '../Utils/Constansts.dart';
import '../View/AdministrateCheckList.dart';
import '../View/AdministrateProduct.dart';
import '../View/AdministrateUser.dart';
import '../View/ChangePassword.dart';
import '../View/ChecklistAnswered.dart';
import '../View/CreateCause.dart';
import '../View/CreateCheckList.dart';
import '../View/CreateProduct.dart';
import '../View/CreateUser.dart';
import '../View/DeleteChecklist.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    await getUser();
    await getUsers();
    await getProducts();
    await getChecklistSkeleton();
    await getAllCause();

    super.onInit();
  }

  static Controller get to => Get.find();
  List<String> productNameList = List.empty(growable: true);
  Map<String, double> testedForReproved = Map();

  Map<String, double> causeMapTotal = Map();
  RxString filter = ''.obs;
  RxBool visible = false.obs;
  RxBool visibleIndicators = false.obs;

  RxBool allPdf = false.obs;
  late CheckListSkeletonReactive checkListToAnswer;
  RxInt countSearch = 0.obs;
  RxInt offset = 0.obs;
  RxBool hiddenPassword = true.obs;
  String password = '';
  String confirmPassword = '';
  RxInt index = 99.obs;
  RxInt position = 1.obs;
  RxString productVersion = ''.obs;
  RxString batch = ''.obs;
  RxBool saved = false.obs;
  RxBool confirmed = false.obs;
  RxList<Obx> cards = RxList.empty(growable: true);
  RxList<TableRow> cards2 = RxList.empty(growable: true);

  List<CheckListSkeletonReactive> auxSkeletonList = [];
  late String token;
  UserRepository userRepository = UserRepository();
  CheckListAnswerRepository answerRepository = CheckListAnswerRepository();
  ProductRepository productRepository = ProductRepository();
  ChecklistSketonRepository checklistSketonRepository =
      new ChecklistSketonRepository();
  UserEntityReactive user = new UserEntityReactive();
  List<UserEntityReactive> users = [];
  UserEntityReactive? userToEdit;
  ProductEntityReactive? productToEdit;
  CheckListSkeletonReactive? checklistToEdit;
  CheckListSkeletonReactive? checklistToCopy;
  List<ProductEntityReactive> products = [];
  List<InterestedPartiesEmailReactiveEntity> interestedPartiesList = [];
  List<CheckListSkeletonReactive> checklistSkeletonList = [];
  List<CheckListAnswerReactive> ansewersListReactive = [];
  RxInt previousindex = 0.obs;
  RxInt sizeOfResponse = 0.obs;
  RxInt sizeOfResponse2 = 0.obs;

  RxString productName = 'Todos'.obs;
  DateTime? initialDate;
  DateTime? endDate;
  List<ItemDrawer> items = List.empty(growable: true);
  CheckListSkeletonReactive checklist = new CheckListSkeletonReactive(
      productId: 0.obs,
      sector: ''.obs,
      title: ''.obs,
      interestedPartiesEmailList: new RxList.empty(growable: true),
      questions: new RxList.empty(growable: true));
  List<Cause> causesList = [];
  TextEditingController textController = new TextEditingController();

  Widget buildScreen() {
    final box = GetStorage();
    switch (index.value) {
      case 0:
        return ChecklistAnswered();
      case 1:
        return CreateChecklist();
      case 2:
        return AdministrateCheckList();
      case 3:
        return AdministrateProduct();
      case 4:
        return CreateProduct();
      case 5:
        return AdministrateUser();
      case 6:
        return CreateUser();
      case 7:
        return CreateCause();
      case 8:
        return ChangePassword();
      case 9:
        return DeleteChecklist();

      //     return EmptyScreen();
      //
      //   case 10:
      //     checklistSkeletonList = [];
      //     previousindex.value = 10;
      //     return AnswerChecklistAdministrate(
      //       checkListSkeletonReactive: checkListToAnswer,
      //       firstTime: true,
      //       batch: '',
      //       versionNumber: '',
      //     );
      case 11:
        checklistSkeletonList = [];
        return ViewCheckListSkeleton();
      case 12:
        checklistSkeletonList = [];
        return ChecklistDisapproved();
      case 13:
        checklistSkeletonList = [];
        return ChecklistReport();
      case 44:
        checklistSkeletonList = [];
        return Indicators();
      case 70:
        return AnswerChecklist(
          checkListSkeletonReactive: checkListToAnswer,
          firstTime: true,
          batch: '',
          versionNumber: '',
        );

      default:
        return box.read('sector') == Constants.administrativo
            ? ChecklistAnswered()
            : ViewCheckListSkeleton();
    }
  }

  Future<void> editAnswer(CheckListAnswerReactive checkListAnswer) async {
    bool created = await answerRepository.update(checkListAnswer);
    if (created) {
      List<CheckListAnswerReactive> auxList = List.empty(growable: true);

      auxList = await answerRepository.findByDate(
          checkListAnswer.productId!.value,
          DateTime.now().subtract(Duration(days: 2)),
          DateTime.now().add(Duration(hours: 6)),
          null,
          null,
          'Reprovado',
          'Todos');
      for (var item in auxList) {
        if (item.sector!.value!.trim() == user.sector!.value.trim()) {
          if (item.statusOfCheckList!.trim() == 'Reprovado') {
            ansewersListReactive.add(item);
          }
        }
      }
      Get.back();

      snackbar(
          "CheckList atualizado com sucesso!", 'Sucesso', Colors.green[200]!);
    } else {
      snackbar(
          "Não foi possível atualizar o CheckList", 'Erro', Colors.red[200]!);
    }
  }

  searchResponseCheckListForIndicators(String month, String year) async {
    double disapprovedCount = 0;
    double total = 0;
    Map<String, double> causeMap = Map(); // creates an empty List<Map>
    testedForReproved = Map();
    causeMapTotal = causeMap;
    List<CheckListAnswerReactive> aux =
        await answerRepository.findForIndicators(month, year);
    if (aux.isNotEmpty) {
      for (var item in aux) {
        total++;
        if (item.statusOfCheckList == 'Reprovado') {
          disapprovedCount++;
          if (item.cause != null) {
            if (causeMap.containsKey(item.cause)) {
              double qtd = causeMap[item.cause!]! + 1;
              causeMap[item.cause!] = qtd;
            } else {
              causeMap[item.cause!] = 1;
            }
          }
        }
        if (item.statusOfCheckList == 'Retrabalhado' ||
            item.statusOfCheckList == 'Retrabalho') {
          disapprovedCount++;

          if (item.cause != null) {
            if (causeMap.containsKey(item.cause)) {
              double qtd = causeMap[item.cause!]! + 1;
              causeMap[item.cause!] = qtd;
            } else {
              causeMap[item.cause!] = 1;
            }
          }
        }
      }

      testedForReproved['Reprovado'] = disapprovedCount;
      testedForReproved['Aprovado'] = total;
      causeMapTotal = causeMap;
      causeMap = new SplayTreeMap.from(
          causeMap, (key1, key2) => causeMap[key1]!.compareTo(causeMap[key2]!));
      ansewersListReactive = aux;
      return true;
    } else {
      return false;
    }
  }

  String getTitle() {
    String title = '';
    for (ItemDrawer item in items) {
      if (item.index == index.value) {
        title = item.name;
        break;
      }
      if (index.value == 99) {
        if (user.sector!.value == "Constants.administrativo") {
          title = 'CheckLists Respondidos';
        } else {
          title = 'Responder CheckLists';
        }
      }
    }
    return title;
  }

  searchReprovedProductionCheckList(
    String productName,
    String searchType,
    String parameter,
    String? limit,
    String? offset,
  ) async {
    int? productId;
    ansewersListReactive = [];
    if (productName.trim().toLowerCase() == 'Todos'.trim().toLowerCase()) {
      productId = -1;
    } else {
      for (ProductEntityReactive item in products) {
        String name = item.name!.value!;
        if (name == productName) {
          productId = item.id!;
          break;
        }
      }
    }
    List<CheckListAnswerReactive> auxList = List.empty(growable: true);
    String status = "Reprovado";
    if (searchType == 'Data') {
      sizeOfResponse.value = await answerRepository.countResponseData(
          productId, initialDate, endDate, status);

      auxList = await answerRepository.findByDate(
          productId, initialDate, endDate, limit, offset, status, 'Todos',
          reprovedOrAll: "onlyReproved");
    } else {
      sizeOfResponse.value = await answerRepository.countResponse(
          productId, searchType, parameter, status);

      auxList = await answerRepository.findByPaginationBatchOrSerialNumer(
          productId, searchType, parameter, limit!, offset!, status, "Todos",
          reprovedOrAll: "onlyReproved");
    }
    for (var item in auxList) {
      if (item.statusOfCheckList!.trim() == 'Reprovado') {
        if (item.sector!.value.trim() == user.sector!.value.trim()) {
          if (item.redirectTo != null) {
            if (item.redirectTo!.trim() == user.sector!.value.trim()) {
              ansewersListReactive.add(item);
            }
          } else {
            ansewersListReactive.add(item);
          }
        } else {
          if (item.redirectTo != null) {
            if (item.redirectTo!.trim() == user.sector!.value.trim()) {
              ansewersListReactive.add(item);
            }
          }
        }
      }
    }
  }

  getAllCause() async {
    List<Cause> auxCausesList = await checklistSketonRepository.getAllCause();
    for (Cause causeAux in auxCausesList) {
      causesList.add(causeAux);
    }
    return causesList;
  }

  buildCauseListList() {
    List<String> causeList = List.empty(growable: true);
    bool duplicated = true;

    for (var causeAux in causesList) {
      if (causeList.isNotEmpty) {
        for (int i = 0; i < causeList.length; i++) {
          if (causeAux.cause! == causeList[i]) {
            duplicated = true;
            break;
          } else {
            duplicated = false;
          }
        }
        if (!duplicated) {
          causeList.add(causeAux.cause!);
        }
      } else {
        causeList.add(causeAux.cause!);
      }
    }
    return causeList;
  }

  Future<void> saveCheckListAnswer(
      CheckListAnswerReactive checkListAnswer) async {
    bool created = await answerRepository.saveAnswer(checkListAnswer);
    if (created) {
      snackbar("CheckList salvo com sucesso!", 'Sucesso', Colors.green[200]!);
    } else {
      snackbar("Não foi possível salvar o CheckList", 'Erro', Colors.red[200]!);
    }
  }

  Future<UserEntityReactive> getUser() async {
    user = await userRepository.getUser();
    return user;
  }

  Future<void> getUsers() async {
    users = await userRepository.getAllUsers();
  }

  List<UserEntityReactive> getUserList() {
    return users;
  }

  List<InterestedPartiesEmailReactiveEntity> getInterestedPartiesList() {
    return interestedPartiesList;
  }

  Future<List<ProductEntityReactive>> getProducts() async {
    products = await productRepository.getAllProducts();
    return products;
  }

  List<ProductEntityReactive> getProductsList() {
    return products;
  }

  Future<void> getChecklistSkeleton() async {
    checklistSkeletonList =
        await checklistSketonRepository.getAllChecklistSkeleton(
            UserEntityReactive(sector: "Constants.administrativo".obs));
  }

  List<CheckListSkeletonReactive> getChecklistSkeletonList() {
    return checklistSkeletonList;
  }

  createUser(UserEntityReactive user) async {
    bool created = await userRepository.createUser(user);
    if (created) {
      snackbar("Usuário salvo com sucesso!", 'Sucesso', Colors.green[200]!);
      getUsers();
    } else {
      snackbar("Não foi possível salvar o usuário", 'Erro', Colors.red[200]!);
    }
  }

  createProduct(ProductEntityReactive product) async {
    bool created = await productRepository.createProduct(product);
    if (created) {
      snackbar("Produto salvo com sucesso!", 'Sucesso', Colors.green[200]!);
      getProducts();
    } else {
      snackbar("Não foi possível salvar o Produto", 'Erro', Colors.red[200]!);
    }
  }

  saveCheckListSkeleton(
      CheckListSkeletonReactive checklistEntityReactive) async {
    checklistEntityReactive.status = 'Active'.obs;
    bool created = await checklistSketonRepository
        .createChecklistSkeleton(checklistEntityReactive);
    if (created) {
      snackbar("Checklist salvo com sucesso!", 'Sucesso', Colors.green[200]!);
      getChecklistSkeleton();
    } else {
      snackbar("Não foi possível salvar o Checklist", 'Erro', Colors.red[200]!);
    }
  }

  disableUser(UserEntityReactive user) async {
    user.status!.value == "Active"
        ? user.status!.value = "Deactivate"
        : user.status!.value = "Active";
    bool logged = await userRepository.disableUser(user);
    if (logged) {
      if (user.status!.value! == "Active") {
        snackbar(
            "Usuário habilitado com sucesso!", 'Sucesso', Colors.green[200]!);
      } else {
        snackbar(
            "Usuário desabilitado com sucesso!", 'Sucesso', Colors.green[200]!);
      }
    } else {
      snackbar(
          "Não foi possível desabilitar o usuário", 'Erro', Colors.red[200]!);
    }
  }

  disableProduct(ProductEntityReactive product) async {
    product.status!.value == "Active"
        ? product.status!.value = "Deactivate"
        : product.status!.value = "Active";
    bool logged = await productRepository.deleteProduct(product);
    if (logged) {
      if (product.status!.value! == "Active") {
        snackbar(
            "Produto habilitado com sucesso!", 'Sucesso', Colors.green[200]!);
      } else {
        snackbar(
            "Produto desabilitado com sucesso!", 'Sucesso', Colors.green[200]!);
      }
    } else {
      snackbar(
          "Não foi possível desabilitar o usuário", 'Erro', Colors.red[200]!);
    }
  }

  getIconDeleteOrRestore(UserEntityReactive user) {
    if (user.status!.value == "Active") {
      return IconButton(
          tooltip: 'Desativar',
          onPressed: () => disableUser(user),
          icon: Icon(Icons.delete, color: Colors.white));
    } else {
      return IconButton(
          tooltip: 'Ativar',
          onPressed: () => disableUser(user),
          icon: Icon(Icons.autorenew, color: Colors.white));
    }
  }

  getIconDeleteOrRestoreProduct(ProductEntityReactive product) {
    if (product.status!.value == "Active") {
      return IconButton(
          tooltip: 'Desativar',
          onPressed: () => disableProduct(product),
          icon: Icon(Icons.delete, color: Colors.white));
    } else {
      return IconButton(
          tooltip: 'Ativar',
          onPressed: () => disableProduct(product),
          icon: Icon(Icons.autorenew, color: Colors.white));
    }
  }

  userIsDisableText(String? value) {
    if (value == "Active") {
      return CommonWidgets.buildText(
          "Ativo", 14, Colors.white, TextAlign.center);
    } else {
      return CommonWidgets.buildText(
          "Inativo", 14, Colors.white, TextAlign.center);
    }
  }

  logout() async {
    final box = GetStorage();
    await box.erase();
    Get.offAll(Home());
  }

  snackbar(String text, String title, Color color) {
    return Get.snackbar(title, text,
        backgroundColor: color,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        messageText: buildTextSnackBar(text),
        titleText: buildTextSnackBar(title),
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

  deleteProduct(ProductEntityReactive product) async {
    bool deleted = await productRepository.deleteProduct(product);
    if (deleted) {
      await getProducts();
      snackbar(
          "Produto desabilitado com sucesso!", 'Sucesso', Colors.green[200]!);
    } else {
      snackbar(
          "Não foi possível desabilitar o Produto", 'Erro', Colors.red[200]!);
    }
  }

  getIconDeleteOrRestoreChecklist(
      CheckListSkeletonReactive checkListSkeletonReactive) {
    if (checkListSkeletonReactive.status!.value == "Active") {
      return IconButton(
          tooltip: 'Desativar',
          onPressed: () => disableChecklist(checkListSkeletonReactive),
          icon: Icon(Icons.remove_circle, color: Colors.white));
    } else {
      return IconButton(
          tooltip: 'Ativar',
          onPressed: () => disableChecklist(checkListSkeletonReactive),
          icon: Icon(Icons.autorenew, color: Colors.white));
    }
  }

  deleteCheklist(int id) async {
    bool deleted = await checklistSketonRepository.deleteCheckList(id);
    if (deleted) {
      snackbar(
          "Checklist excluído com sucesso!", 'Sucesso', Colors.green[200]!);
      await getChecklistSkeleton();
      index.value = 9;
      index.value = 2;

      getChecklistSkeleton();
    } else {
      snackbar(
          "Não foi possível excluir o Checklist", 'Erro', Colors.red[200]!);
    }
  }

  searchResponseCheckList(
      String productName,
      String searchType,
      String parameter,
      String? limit,
      String? offset,
      String status,
      String productFilterName) async {
    int? productId;
    ansewersListReactive = RxList.empty(growable: true);
    if (productName.trim().toLowerCase() == 'Todos'.trim().toLowerCase()) {
      productId = -1;
    } else {
      for (ProductEntityReactive item in products) {
        String name = item.name!.value!;
        if (name == productName) {
          productId = item.id!;
          break;
        }
      }
    }
    List<CheckListAnswerReactive> auxList = [];
    if (searchType == 'Data') {
      sizeOfResponse.value = await answerRepository.countResponseData(
          productId, initialDate, endDate, status);
      ansewersListReactive = await answerRepository.findByDate(productId,
          initialDate, endDate, limit, offset, status, productFilterName);
      sizeOfResponse2.value = ansewersListReactive.length;
    } else {
      sizeOfResponse.value = await answerRepository.countResponse(
          productId, searchType, parameter, status);
      ansewersListReactive =
          await answerRepository.findByPaginationBatchOrSerialNumer(
              productId,
              searchType,
              parameter,
              limit!,
              offset!,
              status,
              productFilterName);
      sizeOfResponse2.value = ansewersListReactive.length;
    }

    if (status != 'Todos') {
      if (status == "Retrabalhado") {
        ansewersListReactive.retainWhere(
            (element) => element.statusOfCheckList!.contains("Retrab"));
        countSearch.value = ansewersListReactive.length;
      } else {
        ansewersListReactive
            .removeWhere((element) => element.statusOfCheckList != status);
        countSearch.value = ansewersListReactive.length;
      }
    }
  }

  buildProductNameList() {
    getProducts();

    List<String> auxProductNameList = List.empty(growable: true);
    for (var product in getProductsList()) {
      if (product.status!.value == 'Active') {
        auxProductNameList.add(product.name!.value!);
      }
    }
    productNameList = auxProductNameList;
    if (auxProductNameList.isNotEmpty) {
      productName.value = auxProductNameList[0];
    }
    return productNameList;
  }

  createCause(Cause cause) async {
    bool created = await checklistSketonRepository.createCause(cause);
    if (created) {
      snackbar("Causa salvo com sucesso!", 'Sucesso', Colors.green[200]!);
      getProducts();
    } else {
      snackbar("Não foi possível salvar a Causa", 'Erro', Colors.red[200]!);
    }
  }

  Future<void> editUser() async {
    bool edited = await userRepository.edit(userToEdit!);
    if (edited) {
      snackbar("Usuário editado com sucesso!", 'Sucesso', Colors.green[200]!);
      getUsers();
    } else {
      snackbar("Não foi possível editar ou usuário", 'Erro', Colors.red[200]!);
    }
  }

  Future<void> editProduct() async {
    bool edited = await productRepository.edit(productToEdit!);
    if (edited) {
      snackbar("Produto editado com sucesso!", 'Sucesso', Colors.green[200]!);
      getProducts();
    } else {
      snackbar("Não foi possível editar ou produto", 'Erro', Colors.red[200]!);
    }
  }

  Future<void> editChecklist() async {
    bool edited = await checklistSketonRepository.edit(checklistToEdit!);
    if (edited) {
      snackbar("Checklist editado com sucesso!", 'Sucesso', Colors.green[200]!);
      await getChecklistSkeleton();
      index.value = 9;
      index.value = 2;
    } else {
      snackbar(
          "Não foi possível editar ou checklist", 'Erro', Colors.red[200]!);
      await getChecklistSkeleton();
      index.value = 9;
      index.value = 2;
    }
  }

  Future<void> editClonelist() async {
    await saveCheckListSkeleton(checklistToCopy!);
    await getChecklistSkeleton();
    index.value = 9;
    index.value = 2;
  }

  comparePasswords() async {
    if (password == confirmPassword) {
      user.password = password.obs;
      bool logged = await userRepository.updatePassword(user);
      if (logged) {
        snackbar("Senha alterada com sucesso!", 'Sucesso', Colors.green[200]!);
      } else {
        snackbar("Não foi possível alterar a senha!", 'Erro', Colors.red[200]!);
      }
    } else {
      snackbar("As senhas não são iguais!", 'Erro', Colors.red[200]!);
    }
  }

  disableChecklist(CheckListSkeletonReactive checkListSkeletonReactive) async {
    checkListSkeletonReactive.status!.value == "Active"
        ? checkListSkeletonReactive.status!.value = "Deactivate"
        : checkListSkeletonReactive.status!.value = "Active";
    bool deleted = await checklistSketonRepository
        .disableChecklist(checkListSkeletonReactive);
    if (deleted) {
      if (checkListSkeletonReactive.status!.value! == "Active") {
        snackbar(
            "Checklist habilitado com sucesso!", 'Sucesso', Colors.green[200]!);
      } else {
        snackbar("Checklist desabilitado com sucesso!", 'Sucesso',
            Colors.green[200]!);
      }
      await getChecklistSkeleton();
    } else {
      snackbar(
          "Não foi possível desabilitar o Checklist", 'Erro', Colors.red[200]!);
    }
  }

  Future<void> resetPassword(UserEntityReactive user) async {
    user.password = '123456'.obs;
    bool logged = await userRepository.updatePassword(user);
    if (logged) {
      snackbar("Senha alterada com sucesso!", 'Sucesso', Colors.green[200]!);
    } else {
      snackbar("Não foi possível alterar a senha!", 'Erro', Colors.red[200]!);
    }
  }

  getChecklistFirstTime() async {
    var auxList = await checklistSketonRepository.getAllChecklistSkeleton(user);
    List<CheckListSkeletonReactive> aux2 = List.empty(growable: true);
    print('here');
    for (var item in auxList) {
      if (item.status!.value!.trim() == 'Active') {
        aux2.add(item);
      }
    }
    print('here');

    if (aux2.length <= checklistSkeletonList.length) {
      if (user.sector!.value != Constants.controleDeQualidade) {
        checklistSkeletonList.removeWhere(
            (element) => element.sector!.value != user.sector!.value);
      } else {
        checklistSkeletonList.removeWhere((element) =>
            element.sector!.value != user.sector!.value &&
            element.sector!.value != Constants.inspecaoVisual);
      }
      return checklistSkeletonList;
    } else {
      checklistSkeletonList = [];
      checklistSkeletonList = aux2;
      if (user.sector!.value != Constants.controleDeQualidade) {
        checklistSkeletonList.removeWhere(
            (element) => element.sector!.value != user.sector!.value);
      } else {
        checklistSkeletonList.removeWhere((element) =>
            element.sector!.value != user.sector!.value &&
            element.sector!.value != Constants.inspecaoVisual);
      }
      return checklistSkeletonList;
    }
  }

  bool validateField(String? field, String hint) {
    if (field != null) {
      if (field.length < 0) {
        errorSnackbar("Por favor preencha o campo " + hint);
        return false;
      }
      return true;
    }
    errorSnackbar("Por favor preencha o campo " + hint);
    return false;
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

  deleteChecklist(CheckListAnswerReactive answer, String password) async {
    bool validated = await userRepository.validatePasswordForDelete(password);
    if (validated) {
      bool deleted = await answerRepository.deleteChecklist(answer.id);
      if (deleted) {
        await getChecklistSkeleton();
        Get.back();
        Get.back();
        return true;
      }
    } else {
      snackbar("Senha incorreta!", 'Erro', Colors.red[200]!);
    }
  }

  getMapOfProductIdChecklistTitle() {
    findAllChecklistSkeleton();
    Map<String, int> titleProductIdMap = Map();
    for (var item in checklistSkeletonList) {
      titleProductIdMap[item.title!.value] = item.productId!.value;
    }
    return titleProductIdMap;
  }

  findAllChecklistSkeleton() async {
    auxSkeletonList =
        await checklistSketonRepository.getAllChecklistSkeleton(user);
  }

  int findProductIdByName(String productName) {
    int productId = 0;
    for (ProductEntityReactive item in products) {
      String name = item.name!.value!;
      if (name == productName) {
        productId = item.id!;
        break;
      }
    }
    return productId;
  }
}
