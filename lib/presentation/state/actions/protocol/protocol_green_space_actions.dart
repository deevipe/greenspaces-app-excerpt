import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';

class FetchingAvailableGSList {}

class UpdateGSAction {
  final ElementType selected;
  UpdateGSAction({required this.selected});
}

class FetchingAvailableGSListSuccess {
  final List<ElementType> list;

  FetchingAvailableGSListSuccess({
    required this.list,
  });
}

class ResetGreenSpace {
  final int? areaId;
  ResetGreenSpace({this.areaId});
}

class ProtocolGSError {
  final String errorMessage;

  ProtocolGSError({
    required this.errorMessage,
  });
}
