import 'package:flutter/material.dart';
import 'package:termoandes/shared/theme/app_colors.dart';
import 'package:termoandes/widgets/termo_text.widget.dart';

class TermoAndesCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const TermoAndesCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth / 2) - 24;

    // Altura fija para todos los cards
    final cardHeight = 250.0;

    // Altura fija para la imagen
    final imageHeight = 120.0;

    // Tamaño de texto proporcional (puedes ajustar)
    final fontSize = 18.0;
    final lineHeight = fontSize * 1.35;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: imageHeight,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: TermoAndesText(
                  title,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  lineHeight: lineHeight,
                  color: isSelected ? AppColors.green500 : Colors.black87,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
