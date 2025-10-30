import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:termoandes/shared/theme/app_colors.dart';
import 'package:termoandes/widgets/termo_text.widget.dart';
import '../../../../widgets/termo_appbar.widget.dart';
import '../../../../widgets/termo_button.widget.dart';
import '../../../../widgets/termo_progress.widget.dart';
import '../../domain/entities/simulator.entity.dart';
import '../bloc/selection_bloc.dart';
import '../bloc/selection_event.dart';
import '../bloc/selection_state.dart';
import '../widgets/category.widget.dart';
import '../widgets/electric_question.widget.dart';
import '../widgets/question_one.widget.dart';
import '../widgets/simulator_result.widget.dart';
import '../widgets/simultaneus.widget.dart';
import 'simulator_final.page.dart';

class SimulatorPage extends StatefulWidget {
  final VoidCallback onBack;

  const SimulatorPage({super.key, required this.onBack});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  List<SelectionToolEntity> categories = [];
  QuestionEntity? currentQuestion;
  OptionEntity? selectedOption;
  SelectionToolEntity? _selectedCategory;

  // 1. Crear la GlobalKey para acceder al estado del formulario
  final GlobalKey<SimulatorUserFormPageState> _formKey =
      GlobalKey<SimulatorUserFormPageState>();

  OptionEntity? _step2SelectedOption;
  final Map<QuestionEntity, OptionEntity> _selectedOptionsMap = {};
  final List<QuestionEntity> _questionStack = [];
  final Map<int, QuestionEntity?> _questionsPerStep = {};
  int totalSteps = 5;
  int currentStep = 1;

  // 2. Variable de estado para controlar si el formulario es válido
  bool _isFormValid = false;

  double get progressValue =>
      totalSteps > 0 ? (currentStep / totalSteps).clamp(0.0, 1.0) : 0.0;

  @override
  void initState() {
    super.initState();
    _resetSimulator();
  }

  void _resetSimulator() {
    setState(() {
      categories = [];
      currentQuestion = null;
      selectedOption = null;
      _selectedCategory = null;
      _step2SelectedOption = null;
      _selectedOptionsMap.clear();
      _questionStack.clear();
      currentStep = 1;
    });
  }

  // void _goBackStep() {
  //   setState(() {
  //     if (currentStep == 1) {
  //       _resetSimulator();
  //       widget.onBack();
  //       return;
  //     }
  //     currentStep--;
  //     currentQuestion = _questionsPerStep[currentStep];
  //     selectedOption = _selectedOptionsMap[currentQuestion];
  //     if (currentStep == 2) {
  //       _step2SelectedOption = selectedOption;
  //     }
  //     // Reiniciar validación del formulario si volvemos del Step 5
  //     _isFormValid = false;
  //   });
  // }
  void _goBackStep() {
    setState(() {
      if (currentStep == 1) {
        _resetSimulator();
        widget.onBack();
        return;
      }

      // 🔹 Limpiar la selección del paso actual
      if (currentQuestion != null) {
        _selectedOptionsMap.remove(currentQuestion);
      }

      currentStep--;

      // Restaurar la pregunta y opción correspondiente al step anterior
      currentQuestion = _questionsPerStep[currentStep];
      selectedOption = _selectedOptionsMap[currentQuestion];

      if (currentStep == 2) {
        _step2SelectedOption = selectedOption;
      }

      // Reiniciar validación del formulario si volvemos del Step 5
      _isFormValid = false;
    });
  }

  void _selectOption(OptionEntity option) {
    setState(() {
      selectedOption = option;
      _selectedOptionsMap[currentQuestion!] = option;
      _questionsPerStep[currentStep] = currentQuestion;

      if (currentStep == 2) {
        _step2SelectedOption = option;
      }
    });
  }

  void _goNextStep() {
    setState(() {
      if (currentStep == 1 && _selectedCategory != null) {
        // Step 1 → Step 2
        currentQuestion = _selectedCategory!.questions.first;
        currentStep = 2;
        selectedOption = null;
        return;
      }

      if (currentStep >= 2) {
        // Usar opción seleccionada actual
        selectedOption ??= _selectedOptionsMap[currentQuestion];

        // Determinar flujo corto
        final isShortFlow = _step2SelectedOption != null &&
            _step2SelectedOption!.label.contains("Eléctrico");

        // 🔹 Caso: Step 2 en flujo corto → ir a Step 3
        if (currentStep == 2 && isShortFlow) {
          currentQuestion = selectedOption?.next;
          currentStep = 3;
          selectedOption = null;
          return;
        }

        // 🔹 Caso: siguiente pregunta existe
        if (selectedOption?.next != null) {
          // Si la siguiente pregunta tiene resultado directo → Step 5
          final hasDirectResult = selectedOption!.next!.options.isNotEmpty &&
              selectedOption!.next!.options.first.result != null;
          if (hasDirectResult) {
            selectedOption = selectedOption!.next!.options.first;
            currentStep = 5;
            currentQuestion = null;
            return;
          }

          // Avanzar a la siguiente pregunta
          currentQuestion = selectedOption!.next;
          currentStep++;
          selectedOption = null;
          return;
        }

        // 🔹 Caso Step 4 o sin next → Step 5
        if (currentStep == 4 || selectedOption?.next == null) {
          currentStep = 5;
          currentQuestion = null;
          selectedOption ??= _selectedOptionsMap.values.last;
          return;
        }

        // Por seguridad → Step 5
        currentStep = 5;
        currentQuestion = null;
        selectedOption ??= _selectedOptionsMap.values.last;
      }
    });
  }

  // void _goNextStep() {
  //   setState(() {
  //     if (currentStep == 1 && _selectedCategory != null) {
  //       currentQuestion = _selectedCategory!.questions.first;
  //       currentStep = 2;
  //       selectedOption = null;
  //     } else if (currentStep >= 2 && selectedOption != null) {
  //       final hasDirectResult = selectedOption!.next != null &&
  //           selectedOption!.next!.options.isNotEmpty &&
  //           selectedOption!.next!.options.first.result != null;
  //       if (hasDirectResult) {
  //         selectedOption = selectedOption!.next!.options.first;
  //         currentStep = 5;
  //         currentQuestion = null;
  //         return;
  //       }
  //       final isShortFlow = _step2SelectedOption != null &&
  //           _step2SelectedOption!.label.contains("Eléctrico");
  //       if (currentStep == 3 && isShortFlow) {
  //         currentStep = 5;
  //         currentQuestion = null;
  //         return;
  //       }
  //       if (currentStep == 4) {
  //         currentStep = 5;
  //         currentQuestion = null;
  //       } else if (selectedOption!.next != null) {
  //         currentQuestion = selectedOption!.next;
  //         currentStep++;
  //         selectedOption = null;
  //       } else {
  //         currentStep = 5;
  //         currentQuestion = null;
  //       }
  //     }
  //   });
  // }
  // void _goNextStep() {
  //   setState(() {
  //     if (currentStep == 1 && _selectedCategory != null) {
  //       currentQuestion = _selectedCategory!.questions.first;
  //       currentStep = 2;
  //       selectedOption = null;
  //       return;
  //     }

  //     if (currentStep >= 2) {
  //       // Si no hay opción seleccionada, usar la del mapa
  //       selectedOption ??= _selectedOptionsMap[currentQuestion];

  //       // Flujo corto “Eléctrico”
  //       final isShortFlow = _step2SelectedOption != null &&
  //           _step2SelectedOption!.label.contains("Eléctrico");

  //       // Si hay resultado, ir directo a Step 5
  //       if (selectedOption?.result != null || isShortFlow) {
  //         currentStep = 5;
  //         currentQuestion = null;

  //         // Asignar selectedOption si es null
  //         selectedOption ??=
  //             _step2SelectedOption ?? _selectedOptionsMap.values.last;
  //         return;
  //       }

  //       // Si hay siguiente pregunta, avanzar normalmente
  //       if (selectedOption?.next != null) {
  //         currentQuestion = selectedOption!.next;
  //         currentStep++;
  //         selectedOption = null;
  //         return;
  //       }

  //       // Si estamos en Step 4 y no hay next, ir a Step 5
  //       if (currentStep == 4) {
  //         currentStep = 5;
  //         currentQuestion = null;
  //         // Asignar selectedOption si es null
  //         selectedOption ??= _selectedOptionsMap.values.last;
  //         return;
  //       }

  //       // Por seguridad, ir a Step 5
  //       currentStep = 5;
  //       currentQuestion = null;
  //       selectedOption ??= _selectedOptionsMap.values.last;
  //     }
  //   });
  // }

  // 3. Método para gestionar el envío del formulario con la Key
  // void _submitForm() {
  //   // Llama directamente al método submitForm() del widget hijo usando la key.
  //   _formKey.currentState?.submitForm();
  // }
  void _submitForm() async {
    // Llama al submitForm() del formulario
    _formKey.currentState?.submitForm();

    final state = _formKey.currentState;
    if (state == null || state.name.isEmpty || state.phone.length < 8) return;

    try {
      await FirebaseFirestore.instance.collection('cotizaciones').add({
        'nombre': state.name,
        'telefono': state.phone,
        'resultado cotización': selectedOption!.result,
        'respuestas':
            _selectedOptionsMap.map((q, o) => MapEntry(q.question, o.label)),
        'fecha de registro': DateTime.now(),
      });
    } catch (e) {
      print('Error guardando cotización: $e');
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => SimulatorFinalResultPage(
    //       selectedOption: selectedOption!,
    //       userName: state.name,
    //       userPhone: state.phone,
    //       onGoHome: () {
    //         _resetSimulator();
    //         widget.onBack();
    //         Navigator.pop(context);
    //       },
    //       allSelections: _selectedOptionsMap,
    //     ),
    //   ),
    // );
  }

  // 4. Método para actualizar la validez del formulario
  void _updateFormValidity(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final questionFontSize = screenWidth < 600 ? 24.0 : 32.0;

    return BlocProvider(
      create: (_) => SelectionBloc()..add(LoadSelectionTools()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TermoandesAppBar(
          centerImage: Image.asset(
            'assets/images/logotermo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
          backgroundColor: AppColors.green500,
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
          child: BlocBuilder<SelectionBloc, SelectionState>(
            builder: (context, state) {
              if (state is SelectionLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SelectionError) {
                return Center(
                  child: Text(
                    'Error al cargar: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is SelectionLoaded) {
                categories = state.dataModel.selectionTools;

                final isElectricFlow = _step2SelectedOption != null &&
                    _step2SelectedOption!.label.contains("Eléctrico");
                final isDepartmentFlow = _step2SelectedOption != null &&
                    (_step2SelectedOption!.label.contains("1 piso") ||
                        _step2SelectedOption!.label.contains("2 pisos") ||
                        _step2SelectedOption!.label.contains("3 pisos"));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    if (currentStep != 5)
                      TermoProgressBar(
                        progress: progressValue,
                        onCancel: widget.onBack,
                        onBackStep: _goBackStep,
                      ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: currentStep != 5
                          ? TermoAndesText(
                              currentQuestion?.question ??
                                  state.dataModel.initialQuestion,
                              fontSize: questionFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              textAlign: TextAlign.left,
                            )
                          : const SizedBox.shrink(),
                    ),

                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (currentStep == 5 && selectedOption != null) {
                            // 5. Pasar la key y el callback de validez al formulario

                            return SimulatorUserFormPage(
                              key: _formKey, // Usar la key aquí
                              selectedOption: selectedOption!,
                              onSubmit: (name, phone) {
                                // Esto se ejecuta cuando el formulario llama a widget.onSubmit
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SimulatorFinalResultPage(
                                      selectedOption: selectedOption!,
                                      userName: name,
                                      userPhone: phone,
                                      onGoHome: () {
                                        _resetSimulator();
                                        widget.onBack();
                                        Navigator.pop(context);
                                      },
                                      allSelections: _selectedOptionsMap,
                                    ),
                                  ),
                                );
                              },
                              onValidChange:
                                  _updateFormValidity, // Nuevo callback
                            );
                          } else if (currentStep == 1) {
                            return CategorySelector(
                              categories: categories,
                              selectedCategory: _selectedCategory,
                              onCategorySelected: (tool) {
                                setState(() {
                                  _selectedCategory = tool;
                                  selectedOption = null;
                                  currentQuestion =
                                      null; // ✅ mantiene el flujo en Step 1

                                  // 🔹 Guardar la selección inicial como primer step
                                  final initialQuestionId = 'initial_selection';
                                  QuestionEntity? initialQuestion =
                                      _selectedOptionsMap.keys.firstWhere(
                                    (q) => q.id == initialQuestionId,
                                    orElse: () => QuestionEntity(
                                      id: initialQuestionId,
                                      question: tool.title,
                                      options: [],
                                    ),
                                  );

                                  final initialOption = OptionEntity(
                                    label: tool.category,
                                  );

                                  _selectedOptionsMap[initialQuestion] =
                                      initialOption;
                                });
                              },
                            );
                          } else if (currentStep == 2) {
                            return QuestionSelector(
                              questionData: currentQuestion!,
                              selectedOption: selectedOption,
                              onOptionSelected: _selectOption,
                            );
                          } else if (currentStep == 3) {
                            if (isElectricFlow || isDepartmentFlow) {
                              return SimultaneousUseSelector(
                                questionData: currentQuestion!,
                                selectedOption: selectedOption,
                                onOptionSelected: _selectOption,
                              );
                            } else {
                              return ElectricQuestionSelector(
                                questionData: currentQuestion!,
                                selectedOption: selectedOption,
                                onOptionSelected: _selectOption,
                              );
                            }
                          } else if (currentStep == 4) {
                            final isUbicacionCaldera = currentQuestion !=
                                    null &&
                                (currentQuestion!.id
                                        .contains("ubicacion_caldera_1piso") ||
                                    currentQuestion!.id
                                        .contains("ubicacion_caldera_2pisos") ||
                                    currentQuestion!.id
                                        .contains("ubicacion_caldera_3pisos"));
                            if (isUbicacionCaldera) {
                              return ElectricQuestionSelector(
                                questionData: currentQuestion!,
                                selectedOption: selectedOption,
                                onOptionSelected: _selectOption,
                              );
                            } else {
                              return SimultaneousUseSelector(
                                questionData: currentQuestion!,
                                selectedOption: selectedOption,
                                onOptionSelected: _selectOption,
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // Botón SIGUIENTE / FINALIZAR SIMULACIÓN
                    // TermoAndesButton(
                    //   text: currentStep == 5
                    //       ? 'FINALIZAR SIMULACIÓN'
                    //       : 'SIGUIENTE',
                    //   // 6. Usar el método _submitForm para el Step 5
                    //   onTap: currentStep == 5 ? _submitForm : _goNextStep,
                    //   type: TermoAndesButtonType.primary,
                    //   // 7. Usar _isFormValid para habilitar/deshabilitar en Step 5
                    //   isEnabled: currentStep == 5
                    //       ? _isFormValid
                    //       : currentStep == 1
                    //           ? _selectedCategory != null
                    //           : selectedOption != null,
                    // ),
                    TermoAndesButton(
                      text: currentStep == 5
                          ? 'FINALIZAR SIMULACIÓN'
                          : 'SIGUIENTE',
                      onTap: currentStep == 5 ? _submitForm : _goNextStep,
                      type: TermoAndesButtonType.primary,
                      isEnabled: currentStep == 5
                          ? _isFormValid
                          : currentStep == 1
                              ? _selectedCategory != null
                              : selectedOption != null,
                    ),

                    TermoAndesButton(
                      text: 'ABANDONAR COTIZACIÓN',
                      onTap: () {
                        _resetSimulator();
                        widget.onBack();
                      },
                      type: TermoAndesButtonType.secondary,
                      isEnabled: true,
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              }

              return const Center(child: Text('Iniciando simulador...'));
            },
          ),
        ),
      ),
    );
  }
}
