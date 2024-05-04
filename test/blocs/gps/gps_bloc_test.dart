import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import '../../geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_service.dart'
    as geolocator_enum;

import 'mock/permission_handler.dart';

void main() {
  late GpsBloc gpsBloc;
  final MockPermissionHandlerPlatform mockPermissionHandlerPlatform =
      MockPermissionHandlerPlatform();

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    PermissionHandlerPlatform.instance = mockPermissionHandlerPlatform;

    gpsBloc = GpsBloc();
  });

  group('GpsAndPermissionEvent', () {
    test(
        'validar que el permiso de ubicacion sea otorgado y tenga habilitado el GPS',
        () async {
      when(GeolocatorPlatform.instance.getServiceStatusStream())
          .thenAnswer((_) => Stream.value(geolocator_enum.ServiceStatus.enabled));

      final locationService = Geolocator.getServiceStatusStream();

      expect(locationService,
          emitsInOrder([emits(geolocator_enum.ServiceStatus.enabled), emitsDone]));
      await gpsBloc.verifyPermissionGranted();
      expect(gpsBloc.state.isAllGranted, false);
    });

    test('check if permission for access location is granted', () async {
      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.granted;
      await mockPermissionHandlerPlatform.checkPermissionStatus(Permission.location);
      final isGranted = await Permission.location.isGranted;
      expect(isGranted, true);
    });
    test('check if permission for access location is granted', () async {
      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.granted;
      await mockPermissionHandlerPlatform.checkPermissionStatus(Permission.location);
      final isGranted = await Permission.location.isGranted;
      expect(isGranted, true);
    });

    test(
        'if permission location is Reject or Not Granted, so ask for permission and show settings dialog',
        () async {
      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.denied;
      await mockPermissionHandlerPlatform.checkPermissionStatus(Permission.location);
      final isGranted = await Permission.location.isGranted;
      expect(isGranted, isNot(true));

      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.denied;
      final data = await mockPermissionHandlerPlatform
          .requestPermissions([Permission.location]);
      if (data.values.first != PermissionStatus.granted) {
        await gpsBloc.askGpsAccess();
        expect(gpsBloc.state.isGpsPermissionGranted, false);
        mockPermissionHandlerPlatform.isOpenAppSettings = true;
        final isOpenAppSettings =
            await mockPermissionHandlerPlatform.openAppSettings();
        expect(isOpenAppSettings, true);
      }
    });

    test(
        'if permission location is Granted, so ask for permission and show settings dialog',
        () async {
      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.granted;
      await mockPermissionHandlerPlatform.checkPermissionStatus(Permission.location);
      final isGranted = await Permission.location.isGranted;
      expect(isGranted, true);
      mockPermissionHandlerPlatform.permissionStatus = PermissionStatus.granted;

      final data = await mockPermissionHandlerPlatform
          .requestPermissions([Permission.location]);
      if (data.values.first == PermissionStatus.granted) {
        await gpsBloc.askGpsAccess();

        gpsBloc.gpsStream.listen(expectAsync1((bool isSuccess) async {
          expect(isSuccess, true);
          if (isSuccess) {
            mockPermissionHandlerPlatform.isOpenAppSettings = false;
            final isOpenAppSettings =
                await mockPermissionHandlerPlatform.openAppSettings();
            expect(isOpenAppSettings, false);
          }
        }));
      }
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
