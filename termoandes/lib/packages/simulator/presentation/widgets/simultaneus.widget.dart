import 'package:flutter/material.dart';
// ... otros imports
import '../../../../widgets/termo_horizontal_card.widget.dart';
import '../../domain/entities/simulator.entity.dart';

class SimultaneousUseSelector extends StatefulWidget {
  final QuestionEntity questionData;
  final OptionEntity? selectedOption;
  final Function(OptionEntity) onOptionSelected;

  const SimultaneousUseSelector({
    super.key,
    required this.questionData,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<SimultaneousUseSelector> createState() =>
      _SimultaneousUseSelectorState();
}

class _SimultaneousUseSelectorState extends State<SimultaneousUseSelector> {
  OptionEntity? _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedOption;
  }

  // Aquí es donde se llama a onOptionSelected, que SOLO guarda el estado en SimulatorPage
  void _selectOption(OptionEntity option) {
    setState(() {
      _currentSelected = option;
    });
    widget.onOptionSelected(option);
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.questionData.options;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: options.map((option) {
          final isSelected = _currentSelected?.label == option.label;

          List<String> images;
          if (option.label.contains("2 duchas y 1 lavaplatos")) {
            images = [
              'assets/images/ducha.png',
              'assets/images/ducha.png',
              'assets/images/lavaplatos.png'
            ];
          } else if (option.label.contains("2 duchas")) {
            images = ['assets/images/ducha.png', 'assets/images/ducha.png'];
          } else if (option.label.contains("1 ducha")) {
            images = ['assets/images/ducha.png'];
          } else if (option.label.contains("1 dormitorio")) {
            images = ['assets/images/dormitorio.png']; // fallback
          } else if (option.label.contains("3 dormitorios")) {
            images = [
              'assets/images/dormitorio.png',
              'assets/images/dormitorio.png',
              'assets/images/dormitorio.png',
            ];
          } else if (option.label.contains("2 dormitorios")) {
            images = [
              'assets/images/dormitorio.png',
              'assets/images/dormitorio.png'
            ];
          } else {
            images = ['assets/images/ducha.png']; // fallback
          }

          return TermoAndesHorizontalCard(
            imagePaths: images,
            // Mostrar solo la parte antes de '|' si existe
            title: option.label.contains('|')
                ? option.label.split('|').first.trim()
                : option.label,
            isSelected: isSelected,
            onTap: () => _selectOption(option),
          );
        }).toList(),
      ),
    );
  }
}
