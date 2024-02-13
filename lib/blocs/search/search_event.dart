part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}
class OnDeactivateManualMarkerEvent extends SearchEvent {}

class OnResultSuggestionsEvent extends SearchEvent {
  final List<String> suggestions;
  const OnResultSuggestionsEvent(this.suggestions);
}
class OnErrorSuggestionsEvent extends SearchEvent {
  final String message;
  const OnErrorSuggestionsEvent(this.message);
}
