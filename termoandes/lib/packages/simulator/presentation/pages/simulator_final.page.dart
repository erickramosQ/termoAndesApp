import 'package:flutter/material.dart';
import 'package:termoandes/widgets/termo_text.widget.dart';
import 'package:termoandes/widgets/termo_appbar.widget.dart';
import 'package:termoandes/shared/theme/app_colors.dart';
import '../../domain/entities/simulator.entity.dart';

class SimulatorFinalResultPage extends StatelessWidget {
  final OptionEntity selectedOption;
  final String userName;
  final String userPhone;
  final VoidCallback onGoHome;
  final Map<QuestionEntity, OptionEntity> allSelections;

  const SimulatorFinalResultPage({
    super.key,
    required this.selectedOption,
    required this.userName,
    required this.userPhone,
    required this.onGoHome,
    required this.allSelections,
  });

  void _abandonarCotizacion(BuildContext context) {
    onGoHome();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: TermoandesAppBar(
        centerImage: Image.asset(
          'assets/images/logotermo.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: AppColors.green500,
      ),
      // dentro del body de tu Scaffold
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 229, 247, 250),
                Color.fromARGB(255, 247, 240, 232),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              final bottomSheetHeight =
                  350.0; // altura del BottomSheet (ajusta a tu necesidad)
              final imageHeight = screenHeight - bottomSheetHeight;

              return Stack(
                children: [
                  // --- IMAGEN SUPERIOR ---
                  // --- IMAGEN SUPERIOR ---
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: imageHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32.0), // separa un poco del BottomSheet
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/${selectedOption.imageId}.png',
                                width: screenWidth * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Botón X
                          Positioned(
                            left: 16,
                            top: 8,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () => _abandonarCotizacion(context),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.darkText500,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- BOTTOMSHEET ---
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // altura máxima disponible para el BottomSheet
                        maxHeight: screenHeight - 100, // ajusta según tu diseño
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  'Resultado de tu cotización',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  selectedOption.result!,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.green700,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  'Precio de cotizacion:',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  selectedOption.label.contains('|')
                                      ? selectedOption.label
                                          .split('|')
                                          .last
                                          .trim()
                                      : selectedOption.label,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.lightGreen,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  'Características de cotización',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 12,
                                children: allSelections.entries.map((entry) {
                                  return SizedBox(
                                    width: (screenWidth - 48) / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TermoAndesText(
                                            entry.key.question,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        _buildChip(
                                            Icons.check, entry.value.label),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String text) {
    // Si contiene '|', tomar solo la parte antes; si no, usar el texto completo
    final displayText =
        text.contains('|') ? text.split('|').first.trim() : text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green500),
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.green500, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              displayText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B5E20), // AppColors.green700
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
