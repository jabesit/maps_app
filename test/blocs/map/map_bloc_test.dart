// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maps_app/models/models.dart';
import 'package:mockito/mockito.dart';

import '../../geolocator.dart';
import 'fake_google_maps_flutter_platform.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class MockGoogleMapState extends Mock implements GoogleMap {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockGoogleMapState';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeGoogleMapsFlutterPlatform platform;
  late LocationBloc locationBloc;
  late MapBloc mapBloc;

  setUpAll(() async {
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    locationBloc = LocationBloc();
    mapBloc = MapBloc(locationBloc: locationBloc);
    locationBloc.getCurrentPosition();
    // Use a mock platform so we never need to hit the MethodChannel code.
    platform = FakeGoogleMapsFlutterPlatform();
    GoogleMapsFlutterPlatform.instance = platform;
  });

  test('drawRoutePolyline', () async {
    expect(locationBloc.state.lastKnownLocation, isNotNull);
    expect(mapBloc.state.isFollowingUser, true);
    const position = LatLng(-37.23235, -57.937535);
    final data = RouteDestination(
        points: [position], duration: 10, distance: "10 kilometers");
    mapBloc.drawRoutePolyline(data);
    expect(mapBloc.state.polylines, isNotNull);
  });

  test('moveCamera', () async {
    const position = LatLng(-37.23235, -57.937535);
    mapBloc.moveCamera(position);
  });

  test('OnStartFollowingUserEvent', () async {
    mapBloc.add(OnStartFollowingUserEvent());
    expect(mapBloc.state.isFollowingUser, true);
  });

  tearDownAll(() async {
    mapBloc.close();
    locationBloc.close();
  });
}
