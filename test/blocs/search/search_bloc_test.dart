import 'package:either_dart/either.dart' as ec;
import 'package:either_dart/either.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maps_app/models/route_destination.dart';
import 'package:maps_app/models/traffic_response.dart';
import 'package:maps_app/services/traffic_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../geolocator.dart';
import 'fake_response.dart';
import 'search_bloc_test.mocks.dart';

//@GenerateNiceMocks( [MockSpec<TrafficService>(onMissingStub: OnMissingStub.returnDefault)])
@GenerateNiceMocks([MockSpec<TrafficService>()])
void main() {
  late SearchBloc searchBloc;
  late TrafficService ctrafficService;

  setUpAll(() {

    ctrafficService = MockTrafficService();

    // provideDummy(Right<NumberTriviaEntity, Failure>.fold(MockFailure()));
    //provideDummy(Either<Exception, String>());
    provideDummy<Result<String, Exception>>(Success(value: "value"));

    provideDummy(Result<Success, Exception>());
    provideDummy(Either<String, List<String>>);
    WidgetsFlutterBinding.ensureInitialized();
    GeolocatorPlatform.instance = MockGeolocatorPlatform();

    final features = Features(
        geometry:
            Geometry(coordinates: [const LatLng(11, 22), const LatLng(33, 44)]),
        properties:
            Properties(units: 1, distance: 1.0, distanceUnits: "aaa", time: 1.0));
    final objTrafficResponse = TrafficResponse();
    objTrafficResponse.features = [features];
    // First arrange the mock to return the expected value.
    when(ctrafficService.getCoorsStartToEnd(LatLng(11, 22), LatLng(33, 55)))
        .thenAnswer((_) async => objTrafficResponse);
    searchBloc = SearchBloc(trafficService: ctrafficService);
  });

  /*
  test('getCurrentPosition', () async {
    // Arrange
    when(
      searchBloc.searchByCriteria("concepcion"),
    ).thenAnswer((_) => Future.value(Exception("aa")));
  });*/

  test('getCoorsStartToEnd', () async {
/*
        
    final currentPosition = await Geolocator.getCurrentPosition();
    final destinationPosition = LatLng(10000, 22222);

    searchBloc.getCoorsStartToEnd(
        LatLng(currentPosition.latitude, currentPosition.longitude),
        destinationPosition);*/

/*
    when(searchBloc.getCoorsStartToEnd(
            LatLng(currentPosition.latitude, currentPosition.longitude),
            destinationPosition))
        .thenAnswer((_) async => RouteDestination(
            points: [const LatLng(11, 22)], duration: 120, distance: "2 Meters"));
*/
    ;
  });

  tearDownAll(() async {
    searchBloc.close();
  });
}
