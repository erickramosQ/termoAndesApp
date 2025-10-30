import 'package:flutter/material.dart';
import 'package:termoandes/widgets/termo_text.widget.dart';
import '../../domain/entities/simulator.entity.dart';

class SimulatorUserFormPage extends StatefulWidget {
  final OptionEntity selectedOption;
  final void Function(String name, String phone) onSubmit;
  final void Function(bool isValid) onValidChange;

  const SimulatorUserFormPage({
    super.key,
    required this.selectedOption,
    required this.onSubmit,
    required this.onValidChange,
  });

  @override
  State<SimulatorUserFormPage> createState() => SimulatorUserFormPageState();
}

class SimulatorUserFormPageState extends State<SimulatorUserFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isValid = false;
  String get name => _nameController.text.trim();
  String get phone => _phoneController.text.trim();
  // void _validate() {
  //   final newIsValid = _nameController.text.trim().isNotEmpty &&
  //       _phoneController.text.trim().length >= 8;

  //   if (newIsValid != _isValid) {
  //     setState(() {
  //       _isValid = newIsValid;
  //     });
  //     widget.onValidChange(newIsValid);
  //   }
  // }
  void _validate() {
    final newIsValid = _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().length >= 8;
    if (newIsValid != _isValid) {
      setState(() {
        _isValid = newIsValid;
      });
      widget.onValidChange(newIsValid);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validate);
    _phoneController.addListener(_validate);
    _validate();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_isValid) {
      widget.onSubmit(
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  // 🔹 InputDecoration sin label interna, con estilo consistente
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.grey, width: 1), // mismo color
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TermoAndesText(
          label,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TermoAndesText(
              '¡Ya casi terminamos!',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
              color: Colors.black87,
            ),
            const SizedBox(height: 24),
            _buildLabeledField('Nombres y apellidos', _nameController),
            const SizedBox(height: 16),
            _buildLabeledField(
              'Celular',
              _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
