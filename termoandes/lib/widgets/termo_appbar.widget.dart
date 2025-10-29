// termoandes_appbar.dart
import 'package:flutter/material.dart';

class TermoandesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // opcional si quieres usar texto además de la imagen
  final Widget? centerImage; // imagen que se mostrará en el centro
  final VoidCallback? onBack; // callback para el botón de retroceso
  final Color backgroundColor;
  final List<Widget>? actions;

  const TermoandesAppBar({
    super.key,
    this.title,
    this.centerImage,
    this.onBack,
    this.backgroundColor = const Color(0xFFFF6600), // ejemplo color corporativo
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false, // para manejar el back nosotros
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            )
          : null,
      title: Stack(
        alignment: Alignment.center,
        children: [
          if (centerImage != null) centerImage!,
          if (title != null)
            Text(title!, style: const TextStyle(color: Colors.white)),
        ],
      ),
      centerTitle: true,

      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
