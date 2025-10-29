import 'package:flutter/material.dart';
import 'package:termoandes/shared/theme/app_colors.dart';

class TermoProgressBar extends StatefulWidget {
  final double progress; // Valor entre 0.0 y 1.0
  final VoidCallback? onCancel; // 🔹 Para cerrar (X)
  final VoidCallback? onBackStep; // 🔹 Nuevo callback para retroceder

  const TermoProgressBar({
    super.key,
    required this.progress,
    this.onCancel,
    this.onBackStep,
  });

  @override
  State<TermoProgressBar> createState() => _TermoProgressBarState();
}

class _TermoProgressBarState extends State<TermoProgressBar> {
  double oldProgress = 0.0;

  @override
  void didUpdateWidget(covariant TermoProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldProgress = oldWidget.progress;
  }

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;
    final circleSize = 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final extraWidth =
        ((widget.onCancel != null || widget.onBackStep != null) ? 24 + 12 : 0);
    final barWidth = screenWidth - 2 * padding - extraWidth - circleSize;

    // 🔹 Determinar si estamos en el primer paso o no
    final isFirstStep = widget.progress <= 0.25;

    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        children: [
          if (widget.onCancel != null || widget.onBackStep != null)
            GestureDetector(
              onTap: isFirstStep ? widget.onCancel : widget.onBackStep,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  isFirstStep ? Icons.close : Icons.arrow_back,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: oldProgress, end: widget.progress),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Fondo
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Progreso
                    Container(
                      width: barWidth * value + circleSize / 2,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.orange500,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Círculo inicial
                    Positioned(
                      left: 0,
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          color: AppColors.orange500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Círculo del progreso
                    Positioned(
                      left: barWidth * value,
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          color: AppColors.orange500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
