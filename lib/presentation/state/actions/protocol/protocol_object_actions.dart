import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/detail/greenspace_object.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/stem_entity.dart';
import 'package:gisogs_greenspacesapp/domain/entity/select_entity.dart';
import 'package:gisogs_greenspacesapp/domain/enums/save_draft_redirect.dart';

class FetchingObjectSelectData {}

class FetchingWorkSubType {}

class DropWorkSubTypes {}

class IncrementObjectIndex {}

class ChangeStemAmount {
  final String newAmount;
  ChangeStemAmount({required this.newAmount});
}

class SetObjectGreenSpaceType {
  final ElementType type;
  SetObjectGreenSpaceType({required this.type});
}

class SetAreaAndElementId {
  final int elementId;
  final int areaId;
  SetAreaAndElementId({required this.elementId, required this.areaId});
}

class ReviseObject {
  final int index;
  final List<GreenSpaceObject> savedObjects;
  ReviseObject({required this.index, required this.savedObjects});
}

class ResetGreenSpaceItems {}

class FetchObjectSelectDataSuccess {
  final List<SelectObject> objectState;
  final List<SelectObject> kind;
  final List<SelectObject> workType;
  final List<SelectObject> workSubType;
  final List<SelectObject> diameters;
  final List<SelectObject> ages;

  FetchObjectSelectDataSuccess({
    required this.objectState,
    required this.kind,
    required this.workType,
    required this.workSubType,
    required this.ages,
    required this.diameters,
  });
}

class HandleMultistemCheckbox {
  final bool value;
  HandleMultistemCheckbox({required this.value});
}

class UpdateObjectData {
  final String? selectedKind;
  final String? selectedWorkType;
  final String? selectedWorkSubType;
  final String? selectedObjectState;
  final String? otherStateValue;
  final String? selectedDiameter;
  final String? selectedAge;
  final String? stemAmount;
  final String? areaValue;
  final String? amountValue;
  final List<Stem> stemList;
  final bool copy;

  UpdateObjectData({
    this.selectedKind,
    this.selectedWorkType,
    this.selectedWorkSubType,
    this.selectedObjectState,
    this.otherStateValue,
    this.selectedDiameter,
    this.selectedAge,
    this.stemAmount,
    this.areaValue,
    this.amountValue,
    required this.stemList,
    required this.copy,
  });
}

class SaveGreenSpaceItem {
  final List<GreenSpaceObject> savedItems;
  SaveGreenSpaceItem({required this.savedItems});
}

class ToogleSaveProtocolProcess {
  final bool isProcessing;
  final DraftRedirect option;
  ToogleSaveProtocolProcess({required this.isProcessing, required this.option});
}

class ProtocolObjectError {
  final String errorMessage;

  ProtocolObjectError({
    required this.errorMessage,
  });
}
