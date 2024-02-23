import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/services/services.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import '../../geolocator.dart';
import '../../permission_handle.dart';
import 'package:geolocator_platform_interface/src/enums/location_service.dart'
    as geolocator_enum;

@GenerateMocks([TrafficService])
void main() {
  late GpsBloc gpsBloc;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    PermissionHandlerPlatform.instance = MockPermissionHandlerPlatform();
  });

  group('GpsAndPermissionEvent', () {
    test('getServiceStatusStream', () {
      when(GeolocatorPlatform.instance.getServiceStatusStream())
          .thenAnswer((_) => Stream.value(geolocator_enum.ServiceStatus.enabled));

      final locationService = Geolocator.getServiceStatusStream();

      expect(locationService,
          emitsInOrder([emits(geolocator_enum.ServiceStatus.enabled), emitsDone]));
      gpsBloc = GpsBloc();
    });

    test('askPermissionGPS', () {
      gpsBloc.askGpsAccess();
    });
  });

  tearDownAll(() async {
    gpsBloc.close();
  });
}
