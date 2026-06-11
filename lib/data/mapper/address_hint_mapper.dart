import 'package:gisogs_greenspacesapp/data/dto/address_hint_dto.dart';
import 'package:gisogs_greenspacesapp/domain/entity/address_hint_entity.dart';

class AddressHintMapper {
  static AddressHint mapDTO(AddressHintDTO data) {
    return AddressHint(value: data.value, coordinates: data.coordinates);
  }
}
