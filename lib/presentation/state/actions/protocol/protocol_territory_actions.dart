import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/area_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/ogs_entity.dart';

class FetchingTerritoryData {}

class DropSelectedTerritory {}

class FetchingTerritoryDataSuccess {
  List<AreaType> list;
  FetchingTerritoryDataSuccess({required this.list});
}

class UpdateTerritoryStepAction {
  final Ogs? ogs;
  final int selectedType;
  final String address;
  final String typeUrl;

  UpdateTerritoryStepAction({required this.selectedType, required this.address, required this.typeUrl, this.ogs});
}

class ProtocolTerritoryError {
  final String errorMessage;

  ProtocolTerritoryError({
    required this.errorMessage,
  });
}
