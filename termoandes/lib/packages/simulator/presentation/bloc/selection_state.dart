import '../../domain/entities/simulator.entity.dart';

abstract class SelectionState {}

/// Estado inicial/vacío.
class SelectionInitial extends SelectionState {}

/// Estado cuando los datos están siendo cargados.
class SelectionLoading extends SelectionState {}

/// Estado cuando los datos se han cargado con éxito.
class SelectionLoaded extends SelectionState {
  final DataModelEntity dataModel;

  SelectionLoaded({required this.dataModel});
}

/// Estado si ocurre un error durante la carga.
class SelectionError extends SelectionState {
  final String message;

  SelectionError({required this.message});
}
