import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../widgets/termo_appbar.widget.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  static const name = 'ProductsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TermoandesAppBar(
          // onBack: Navigator.of(context).pop,
          centerImage: Image.asset(
            'assets/images/logotermo.png', // PNG de tu logo
            height: 40, // tamaño del logo
            fit: BoxFit.contain,
          ),
          backgroundColor: AppColors.green500 // color corporativo
          ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 229, 247, 250), // #EEF4F5
                Color.fromARGB(255, 247, 240, 232), // #FFF7EE
              ],
            ),
          ),
          child: const Center(child: Text('Página de productos'))),
    );
  }
}
