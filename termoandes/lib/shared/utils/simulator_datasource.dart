// selection_data_source.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SelectionDataSource {
  static const String _filePath = 'assets/json/simulator.json';

  // Método para cargar y decodificar el JSON del archivo de assets.
  Future<Map<String, dynamic>> getSelectionToolsJson() async {
    try {
      // 1. Cargar el contenido del archivo como una cadena de texto.
      final jsonString = await rootBundle.loadString(_filePath);

      // 2. Decodificar la cadena JSON a un mapa de Dart.
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      return jsonMap;
    } catch (e) {
      // Manejo de errores si el archivo no existe o no es un JSON válido.
      throw Exception('Failed to load JSON from $_filePath: $e');
    }
  }
}
