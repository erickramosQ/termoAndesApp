class DataModelEntity {
  final String initialQuestion;
  final List<SelectionToolEntity> selectionTools;

  DataModelEntity({
    required this.initialQuestion,
    required this.selectionTools,
  });
}

class SelectionToolEntity {
  final String title;
  final String category;
  final List<QuestionEntity> questions;

  SelectionToolEntity({
    required this.title,
    required this.category,
    required this.questions,
  });
}

class QuestionEntity {
  final String id;
  final String question;
  final List<OptionEntity> options;
  final String? details;

  QuestionEntity({
    required this.id,
    required this.question,
    required this.options,
    this.details,
  });

  Map<String, dynamic>? toJson() {}
}

class OptionEntity {
  final String label;
  final QuestionEntity? next;
  final String? result;
  final String? imageId;

  OptionEntity({
    required this.label,
    this.next,
    this.result,
    this.imageId,
  });
}
