import 'package:flutter/material.dart';
import '../../../../widgets/termo_card.widget.dart';
import '../../../../widgets/termo_horizontal_card.widget.dart';
import '../../domain/entities/simulator.entity.dart'; // QuestionEntity y OptionEntity

class QuestionSelector extends StatefulWidget {
  final QuestionEntity questionData;
  final Function(OptionEntity) onOptionSelected;
  final OptionEntity? selectedOption; // 🔹 nuevo parámetro

  const QuestionSelector({
    super.key,
    required this.questionData,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<QuestionSelector> createState() => _QuestionSelectorState();
}

class _QuestionSelectorState extends State<QuestionSelector> {
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
          String imagePath;

          if (title == "Eléctrico") {
            imagePath = 'assets/images/electric.png';
          } else if (title == "Gas Natural o GLP") {
            imagePath = 'assets/images/gas.png';
          } else if (title == "1 piso") {
            imagePath = 'assets/images/1piso.png';
          } else if (title == "2 pisos") {
            imagePath = 'assets/images/2piso.png';
          } else if (title == "3 pisos") {
            imagePath = 'assets/images/3piso.png';
          } else {
            imagePath = 'assets/images/electric.png';
          }

          final isSelected = widget.selectedOption?.label == option.label;

          return TermoAndesCard(
            title: title,
            isSelected: isSelected, // 🔹 mantiene selección
            imagePath: imagePath,
            onTap: () {
              widget.onOptionSelected(option);
            },
          );
        }),
      ),
    );
  }
}
