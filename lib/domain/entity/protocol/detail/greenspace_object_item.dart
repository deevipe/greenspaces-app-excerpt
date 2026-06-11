import 'package:gisogs_greenspacesapp/domain/entity/dictionaries/element_type.dart';
import 'package:gisogs_greenspacesapp/domain/entity/protocol/stem_entity.dart';

class GreenSpaceObjectItem {
  final int? id;
  final int typeId;
  ElementType? type;
  final bool multiStem;
  final String? selectedKind;
  final String? selectedWorkType;
  final String? selectedWorkSubType;
  final String? selectedObjectState;
  final String? selectedDiameter;
  final String? otherStateValue;
  final List<String?> pictures;
  final String? selectedAge;
  final String? areaValue;
  final String? amountValue;
  final String? stemAmount;
  final List<Stem> stemList;

  GreenSpaceObjectItem({
    this.id,
    required this.typeId,
    this.type,
    required this.multiStem,
    this.selectedKind,
    this.selectedWorkType,
    this.selectedWorkSubType,
    this.selectedObjectState,
    this.selectedDiameter,
    this.otherStateValue,
    required this.pictures,
    this.selectedAge,
    this.areaValue,
    this.amountValue,
    this.stemAmount,
    required this.stemList,
  });

  GreenSpaceObjectItem updateWith({
    int? id,
    int? typeId,
    ElementType? type,
    bool? multiStem,
    String? selectedKind,
    String? selectedWorkType,
    String? selectedWorkSubType,
    String? selectedObjectState,
    String? selectedDiameter,
    String? otherStateValue,
    List<String?>? pictures,
    String? selectedAge,
    String? areaValue,
    String? amountValue,
    String? stemAmount,
    List<Stem>? stemList,
  }) =>
      GreenSpaceObjectItem(
        id: id ?? this.id,
        typeId: typeId ?? this.typeId,
        type: type ?? this.type,
        multiStem: multiStem ?? this.multiStem,
        selectedKind: selectedKind,
        selectedWorkType: selectedWorkType,
        selectedWorkSubType: selectedWorkSubType,
        selectedObjectState: selectedObjectState,
        selectedDiameter: selectedDiameter,
        otherStateValue: otherStateValue,
        pictures: pictures ?? this.pictures,
        selectedAge: selectedAge,
        areaValue: areaValue,
        amountValue: amountValue,
        stemAmount: stemAmount,
        stemList: stemList ?? this.stemList,
      );
}
