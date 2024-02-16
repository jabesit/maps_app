import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/services/services.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../../geolocator_test.dart';

@GenerateMocks([TrafficService])
void main() {
  late GpsBloc gpsBloc;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    gpsBloc = GpsBloc();
  });

  tearDown(() async {
    gpsBloc.close();
  });
  test('Stream listen test', () {
    gpsBloc.askGpsAccess();
    var stream = gpsBloc.gpsServiceSubscription;
    stream?.onData(
      expectAsync1(
        (event) {
          expect(
              event,
              const GpsAndPermissionEvent(
                isGpsEnabled: true,
                isGpsPermissionGranted: true,
              ));
        },
      ),
    );
  });
}
