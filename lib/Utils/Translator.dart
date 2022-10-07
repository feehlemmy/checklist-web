import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailAnswerReactiveEntity.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/QuestionSkeletonReactive.dart';
import 'package:get/get.dart';

class Translator {
  static CheckListAnswerReactive
      checkListSkeletonReactiveToCheckListAnswerReactive(
          CheckListSkeletonReactive skeleton) {
    return new CheckListAnswerReactive(
        interestedPartiesEmailList:
            interestedPartiesEmailReactiveEntityToInterestedPartiesEmailAnswerReactiveEntity(
                skeleton.interestedPartiesEmailList),
        productId: skeleton.productId,
        sector: skeleton.sector,
        batch: ''.obs,
        productVersion: ''.obs,
        serieNumber: ''.obs,
        title: skeleton.title,
        questions: questionSkeletonReactiveToQuestionAnswerReactive(
            skeleton.questions!));
  }

  static questionSkeletonReactiveToQuestionAnswerReactive(
      List<QuestionSkeletonReactive> skeletonList) {
    List<QuestionAnswerReactive> answers = List.empty(growable: true);
    for (var item in skeletonList) {
      answers.add(new QuestionAnswerReactive(
          approved: null,
          disapproved: null,
          category: item.category,
          position: item.position,
          description: item.description,
          tooltip: item.tooltip));
    }
    return answers;
  }

  static interestedPartiesEmailReactiveEntityToInterestedPartiesEmailAnswerReactiveEntity(
      List<InterestedPartiesEmailReactiveEntity>? interestedPartiesEmailList) {
    List<InterestedPartiesEmailAnswerReactiveEntity> answers =
        List.empty(growable: true);
    for (var item in interestedPartiesEmailList!) {
      answers.add(new InterestedPartiesEmailAnswerReactiveEntity(
        email: item.email,
      ));
    }
    return answers;
  }
}
