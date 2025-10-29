import 'package:flutter/material.dart';
import 'package:termoandes/shared/theme/app_colors.dart';
import 'package:termoandes/widgets/termo_text.widget.dart';

class TermoAndesHorizontalCard extends StatelessWidget {
  final List<String> imagePaths;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const TermoAndesHorizontalCard({
    super.key,
    required this.imagePaths,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = 95.0;
    final fontSize = 16.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: screenWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.green400 : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: imagePaths.take(3).map((path) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Image.asset(
                    path,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TermoAndesText(
                title,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.green500 : Colors.black87,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
