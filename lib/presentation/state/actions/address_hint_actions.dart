// Project imports:
import 'package:gisogs_greenspacesapp/domain/entity/address_hint_entity.dart';

class FetchingSuggestionsAction {
  final String query;
  FetchingSuggestionsAction({required this.query});
}

class ClearSuggestionsAction {}

class GetSuggestionsSuccess {
  final List<AddressHint> suggestions;
  GetSuggestionsSuccess({required this.suggestions});
}

class GetSuggestionsError {
  final String errorMessage;
  GetSuggestionsError({required this.errorMessage});
}
