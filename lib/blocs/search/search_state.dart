part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarker;
  final List<String> suggestionsList;
  final String message;

  const SearchState(
      {this.displayManualMarker = false,
      this.suggestionsList = const [],
      this.message = ""});

  SearchState copyWith(
          {bool? displayManualMarker,
          List<String>? suggestionsList,
          String? message}) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        suggestionsList: suggestionsList ?? this.suggestionsList,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [displayManualMarker, suggestionsList, message];
}
