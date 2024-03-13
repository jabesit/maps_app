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

void main() {
  late GpsBloc gpsBloc;

  setUpAll(() {
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

  group('Testing GPS State', () {
    test('Gps Events get Props', () {
      expect(gpsBloc.state.toString(), isNotNull);
    });
    test('Check Permission Granted to show Map', () {
      gpsBloc.emit(const GpsState(isGpsEnabled: true, isGpsPermissionGranted: true));
      expect(gpsBloc.state.isAllGranted, true);
    });
    test('Use Copy with isGpsEnabled', () {
      gpsBloc.emit(gpsBloc.state.copyWith(isGpsEnabled: false));
      expect(gpsBloc.state.isGpsEnabled, false);
      expect(gpsBloc.state.isAllGranted, false);
    });
    test('Use Copy with isGpsPermissionGranted', () {
      gpsBloc.emit(gpsBloc.state.copyWith(isGpsPermissionGranted: false));
      expect(gpsBloc.state.isAllGranted, false);
    });
  });

  tearDownAll(() async {
    gpsBloc.close();
  });
}
