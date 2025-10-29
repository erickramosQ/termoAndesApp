// termo_andes_button.widget.dart

import 'package:flutter/material.dart';
import 'package:termoandes/shared/theme/app_colors.dart';

import 'termo_text.widget.dart'; // Asumiendo AppColors existe

enum TermoAndesButtonType {
  primary,
  secondary,
}

class TermoAndesButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TermoAndesButtonType type;

  // Si el botón primario está deshabilitado
  final bool isEnabled;

  const TermoAndesButton({
    super.key,
    required this.text,
    required this.onTap,
    this.type =
        TermoAndesButtonType.primary, // Por defecto es el botón primario
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Definir estilos basados en el tipo
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;
    double elevation;

    switch (type) {
      case TermoAndesButtonType.primary:
        backgroundColor = AppColors.orange500; // Naranja relleno
        foregroundColor = Colors.white; // Texto blanco
        borderColor = AppColors.orange500;
        elevation = 4.0;
        break;
      case TermoAndesButtonType.secondary:
        backgroundColor = Colors.white; // Fondo blanco
        foregroundColor = AppColors.orange500; // Texto naranja
        borderColor = Colors.grey.shade300; // Borde sutil
        elevation = 1.0;
        break;
    }

    // El botón se deshabilita si isEnabled es false O si onTap es nulo
    final bool effectiveEnabled = isEnabled && onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: effectiveEnabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveEnabled
                ? backgroundColor
                : Colors.grey.shade400, // Color para deshabilitado
            foregroundColor: type == TermoAndesButtonType.primary
                ? foregroundColor
                : effectiveEnabled
                    ? foregroundColor
                    : Colors.grey.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: type == TermoAndesButtonType.secondary
                    ? borderColor
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            elevation: elevation,
            // Sobreescribir el color del texto si está deshabilitado
            disabledForegroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
          ),
          child: TermoAndesText(
            text,
            fontSize: type == TermoAndesButtonType.primary ? 18 : 16,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: effectiveEnabled ? foregroundColor : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
