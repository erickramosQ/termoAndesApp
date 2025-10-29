import 'package:flutter/material.dart';
import '../home/presentation/pages/clients.page.dart';
import '../home/presentation/pages/products.page.dart';
import '../simulator/presentation/pages/simulator.page.dart';
import 'custom_navbar.dart';

class MainPages extends StatefulWidget {
  const MainPages({super.key});
  static const name = 'main_pages';

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get _isSimulator => _selectedIndex == 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductsPage(),
      SimulatorPage(
        onBack: () {
          setState(() {
            _selectedIndex = 0; // o 2 si prefieres volver a Clientes
          });
        },
      ),
      const ClientsPage(),
    ];

    return Scaffold(
      // 👇 esto es lo clave
      extendBody:
          true, // permite que el contenido del body se vea detrás del navbar
      backgroundColor: Colors.transparent, // evita fondo negro o blanco

      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      // 👇 deja el navbar igual, no lo toques
      bottomNavigationBar: _isSimulator
          ? null
          : CustomNavbar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
            ),
    );
  }
}
