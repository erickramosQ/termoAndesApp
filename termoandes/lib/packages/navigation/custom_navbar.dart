import 'package:flutter/material.dart';
import 'package:termoandes/shared/theme/app_colors.dart';
import '../../widgets/termo_text.widget.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Padding general responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.02; // 2% ancho
    final verticalPadding = 8.0; // fijo para no subir mucho la altura

    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            3,
            (index) => Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => onItemSelected(index),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: horizontalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? AppColors.green500
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.inventory_2
                              : index == 1
                                  ? Icons.description
                                  : Icons.people,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.grey,
                          size: 24, // tamaño fijo de icono
                        ),
                        const SizedBox(height: 4),
                        TermoAndesText(
                          index == 0
                              ? 'Productos'
                              : index == 1
                                  ? 'Cotización'
                                  : 'Clientes',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.grey,
                          textAlign: TextAlign.center,
                          lineHeight: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
