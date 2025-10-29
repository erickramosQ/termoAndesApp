import '../../domain/entities/simulator.entity.dart';

class SelectionToolModel extends SelectionToolEntity {
  SelectionToolModel({
    required super.title,
    required super.category,
    required super.questions,
  });

  factory SelectionToolModel.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List<dynamic>? ?? [];
    return SelectionToolModel(
      title: json['title'] as String,
      category: json['category'] as String,
      questions: questionsJson
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    required super.question,
    required super.options,
    super.details,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List<dynamic>? ?? [];
    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      details: json['details'] as String?,
      options: optionsJson
          .map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OptionModel extends OptionEntity {
  OptionModel({
    required super.label,
    super.next,
    super.result,
    super.imageId,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    final nextQuestionJson = json['next'] as Map<String, dynamic>?;
    final nextQuestion = nextQuestionJson != null
        ? QuestionModel.fromJson(nextQuestionJson)
        : null;

    return OptionModel(
      label: json['label'] as String,
      next: nextQuestion,
      result: json['result'] as String?,
      imageId: json['image_id'] as String?,
    );
  }
}

class DataModel extends DataModelEntity {
  DataModel({
    required super.initialQuestion,
    required super.selectionTools,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      initialQuestion: json['initial_question'] as String? ?? '', // nuevo campo
      selectionTools: (json['selection_tools'] as List<dynamic>)
          .map((t) => SelectionToolModel.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}
