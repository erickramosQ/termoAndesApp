// selection_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/simulator.repository.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  // Instanciamos el repositorio directamente aquí
  final ISelectionRepository repository = SelectionRepository();

  SelectionBloc() : super(SelectionInitial()) {
    on<LoadSelectionTools>(_onLoadSelectionTools);
  }

  // Lógica de manejo del evento LoadSelectionTools
  Future<void> _onLoadSelectionTools(
    LoadSelectionTools event,
    Emitter<SelectionState> emit,
  ) async {
    emit(SelectionLoading());

    try {
      final dataModel = await repository.getSelectionTools();
      emit(SelectionLoaded(dataModel: dataModel));
    } catch (e) {
      emit(SelectionError(
          message: 'No se pudieron cargar las herramientas: ${e.toString()}'));
    }
  }
}
