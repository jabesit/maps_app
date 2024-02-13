import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));

    on<OnResultSuggestionsEvent>(
        (event, emit) => emit(state.copyWith(suggestionsList: event.suggestions)));
    on<OnErrorSuggestionsEvent>(
        (event, emit) => emit(state.copyWith(message: event.message)));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    final latLngList = trafficResponse.features![0].geometry!.coordinates;
    final distance = trafficResponse.features![0].properties!.distance;
    final duration = trafficResponse.features![0].properties!.time;

    return RouteDestination(
        points: latLngList!, duration: duration!, distance: distance.toString());
  }

  Future<void> searchByCriteria(String criteria) async {
    final response = await trafficService.searchByCriteria(criteria);
    response.fold((left) => add(OnErrorSuggestionsEvent(left)),
        (right) => add(OnResultSuggestionsEvent(right)));
  }
}
