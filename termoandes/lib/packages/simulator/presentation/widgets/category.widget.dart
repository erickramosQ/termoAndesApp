import 'package:flutter/material.dart';
import '../../../../widgets/termo_card.widget.dart';
import '../../domain/entities/simulator.entity.dart';

class CategorySelector extends StatefulWidget {
  final List<SelectionToolEntity> categories;
  final Function(SelectionToolEntity) onCategorySelected;
  final SelectionToolEntity? selectedCategory; // 🔹 nuevo parámetro

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(widget.categories.length, (index) {
          final tool = widget.categories[index];

          String imagePath;
          String title = tool.category;

          if (tool.category == "Calefacción y agua caliente sanitaria") {
            imagePath = 'assets/images/calefaction-water.png';
            title = 'Calefacción y\nAgua Caliente';
          } else if (tool.category == "Calefacción") {
            imagePath = 'assets/images/calefaccion.png';
            title = 'Calefacción';
          } else if (tool.category == "Agua Caliente Sanitaria") {
            imagePath = 'assets/images/water.png';
            title = 'Agua Caliente\nSanitaria';
          } else {
            imagePath = 'assets/images/electric.png';
          }

          final isSelected = widget.selectedCategory?.category == tool.category;

          return TermoAndesCard(
            title: title,
            isSelected: isSelected, // 🔹 mantiene selección
            imagePath: imagePath,
            onTap: () {
              widget.onCategorySelected(tool);
            },
          );
        }),
      ),
    );
  }
}
