import '../../../../shared/utils/simulator_datasource.dart';
import '../../domain/entities/simulator.entity.dart';
import '../models/simulator.entity.dart';

abstract class ISelectionRepository {
  Future<DataModelEntity> getSelectionTools();
}

class SelectionRepository implements ISelectionRepository {
  // Instanciamos el datasource directamente
  final SelectionDataSource _dataSource = SelectionDataSource();

  @override
  Future<DataModelEntity> getSelectionTools() async {
    try {
      // Obtener los datos crudos del DataSource
      final json = await _dataSource.getSelectionToolsJson();

      // Mapear el JSON crudo a los objetos Model.
      final dataModel = DataModel.fromJson(json);

      // Devolver la entidad
      return dataModel;
    } catch (e) {
      // Propagar errores de carga o mapeo.
      rethrow;
    }
  }
}
