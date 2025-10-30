import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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

  SimulatorFinalResultPage({
    super.key,
    required this.selectedOption,
    required this.userName,
    required this.userPhone,
    required this.onGoHome,
    required this.allSelections,
  });

  final ScreenshotController _screenshotController = ScreenshotController();

  void _abandonarCotizacion(BuildContext context) {
    onGoHome();
  }

  Future<void> _guardarImagenEnGaleria(Uint8List imageBytes) async {
    try {
      final directory = Directory('/storage/emulated/0/Pictures/Termoandes');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath =
          '${directory.path}/cotizacion_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      debugPrint('Imagen guardada en galería manualmente en: $filePath');

      // 🔹 Notifica al sistema Android para que aparezca en galería inmediatamente
      const platform = MethodChannel('app.channel.shared.data');
      try {
        await platform.invokeMethod('scanFile', {'path': file.path});
      } on PlatformException catch (e) {
        debugPrint('Error al notificar MediaStore: $e');
      }
    } catch (e) {
      debugPrint('Error guardando imagen en galería: $e');
    }
  }

  /// 📸 Captura pantalla y la envía por WhatsApp

  Future<void> _compartirPorWhatsapp(BuildContext context) async {
    try {
      // Captura la pantalla
      final image = await _screenshotController.capture();
      if (image == null) return;

      // 🔹 Guardar en galería manualmente
      await _guardarImagenEnGaleria(Uint8List.fromList(image));

      // 🔹 Prepara número de WhatsApp
      String phone = userPhone.replaceAll(RegExp(r'[^0-9]'), '');
      if (!phone.startsWith('591')) phone = '591$phone'; // Código Bolivia

      final message =
          'Hola $userName 👋, aquí te envío el resultado de tu cotización con Termoandes. '
          'También puedes visitarnos en nuestra página web: https://www.termoandes.com/';

      // 🔹 URL oficial de WhatsApp (más confiable que whatsapp://send)
      final whatsappUrl = Uri.parse(
          'https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error al compartir: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
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
                final priceLines = selectedOption.label.split('\n');

                return Column(
                  children: [
                    // --- IMAGEN SUPERIOR ---
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: buildImage(
                                    selectedOption.imageId!, screenWidth),
                              ),
                            ),
                            // ❌ Botón X
                            Positioned(
                              left: 16,
                              top: 8,
                              child: _buildCircleButton(
                                icon: Icons.close,
                                onTap: () => _abandonarCotizacion(context),
                              ),
                            ),
                            // 📤 Botón compartir
                            Positioned(
                              right: 16,
                              top: 8,
                              child: _buildCircleButton(
                                icon: Icons.share,
                                onTap: () => _compartirPorWhatsapp(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- BOTTOMSHEET ---
                    Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            TermoAndesText(
                              'Resultado de tu cotización',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TermoAndesText(
                                  selectedOption.result!,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.green700,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TermoAndesText(
                              'Precio de cotización:',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 8,
                                childAspectRatio: 3.6,
                              ),
                              itemCount: priceLines.length,
                              itemBuilder: (context, index) {
                                final line = priceLines[index];
                                final partsAfterPipe = line.contains('|')
                                    ? line.split('|')[1].trim()
                                    : line;
                                final priceParts = partsAfterPipe.split('\n');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: priceParts.map((priceLine) {
                                    final splitPrice = priceLine.split(':');
                                    final title = splitPrice.first.trim();
                                    final value = splitPrice.length > 1
                                        ? splitPrice[1].trim()
                                        : '';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            value,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            TermoAndesText(
                              'Características de cotización',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
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
                                      SizedBox(
                                        width: double.infinity,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TermoAndesText(
                                            entry.key.question,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            textAlign: TextAlign.left,
                                          ),
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String text) {
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
                color: Color(0xFF1B5E20),
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Icon(icon, color: AppColors.darkText500, size: 24),
      ),
    );
  }
}

Widget buildImage(String imageId, double width) {
  return FutureBuilder<bool>(
    future: _assetExists('assets/images/$imageId.png'),
    builder: (context, snapshot) {
      String path;
      if (snapshot.connectionState == ConnectionState.done) {
        path = (snapshot.data == true)
            ? 'assets/images/$imageId.png'
            : 'assets/images/$imageId.jpeg';
        return Image.asset(
          path,
          width: width,
          fit: BoxFit.contain,
        );
      }
      // Mientras verifica
      return SizedBox(width: width, height: width * 0.6);
    },
  );
}

// Función que revisa si el asset existe
Future<bool> _assetExists(String path) async {
  try {
    await rootBundle.load(path);
    return true;
  } catch (_) {
    return false;
  }
}
