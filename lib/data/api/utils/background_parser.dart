import 'package:flutter/foundation.dart';
import 'package:gisogs_greenspacesapp/data/dto/address_hint_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/dictionaries/organisation_dto.dart';
import 'package:gisogs_greenspacesapp/data/dto/select_object_dto.dart';

class BackgroundParser {
  Future<List<AddressHintDTO>> parseDadataHints(List<dynamic> data) {
    // compute spawns an isolate, runs a callback on that isolate, and returns a Future with the result
    return compute(_parseDadataJson, data);
  }

  List<AddressHintDTO> _parseDadataJson(List<dynamic> data) {
    return data.map((json) => AddressHintDTO.fromJson(json)).toList();
  }

  Future<List<OrganisationDTO>> parseOtherOrgs(List<dynamic> data) {
    return compute(_parseOtherOrgsJson, data);
  }

  List<OrganisationDTO> _parseOtherOrgsJson(List<dynamic> data) {
    return data.map((json) => OrganisationDTO.fromJson(json)).toList().cast<OrganisationDTO>();
  }

  Future<List<SelectObjectDTO>> parseSelectObject(List<dynamic> data) {
    return compute(_parseSelectObjectJson, data);
  }

  List<SelectObjectDTO> _parseSelectObjectJson(List<dynamic> data) {
    return data.map((json) => SelectObjectDTO.fromJson(json)).toList().cast<SelectObjectDTO>();
  }
}
