import 'package:flutter/material.dart';
import '../../../../widgets/termo_card.widget.dart';
import '../../domain/entities/simulator.entity.dart';

class ElectricQuestionSelector extends StatefulWidget {
  final QuestionEntity questionData;
  final Function(OptionEntity) onOptionSelected;
  final OptionEntity? selectedOption;

  const ElectricQuestionSelector({
    super.key,
    required this.questionData,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<ElectricQuestionSelector> createState() =>
      _ElectricQuestionSelectorState();
}

class _ElectricQuestionSelectorState extends State<ElectricQuestionSelector> {
  @override
  Widget build(BuildContext context) {
    final options = widget.questionData.options;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(options.length, (index) {
          final option = options[index];
          final title = option.label;

          final isSelected = widget.selectedOption?.label == option.label;
          String imagePath;

          if (title == "Cocina") {
            imagePath = 'assets/images/cocina.png';
          } else if (title == "Lavandería") {
            imagePath = 'assets/images/lavanderia.png';
          } else if (title == "Balcón") {
            imagePath = 'assets/images/balcon.png';
          } else if (title == "Terraza") {
            imagePath = 'assets/images/terraza.png';
          } else {
            imagePath = 'assets/images/electric.png';
          }
          return TermoAndesCard(
            title: title, // 🔹 Solo mostramos el label
            imagePath: imagePath, // Puedes cambiar si quieres íconos distintos
            isSelected: isSelected,
            onTap: () {
              widget.onOptionSelected(option);
            },
          );
        }),
      ),
    );
  }
}
