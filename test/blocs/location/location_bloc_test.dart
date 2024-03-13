import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../geolocator.dart';

void main() {
  late LocationBloc locationBloc;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    locationBloc = LocationBloc();
  });

  test('getCurrentPosition', () async {
    await locationBloc.getCurrentPosition();
  });

  tearDownAll(() async {
    locationBloc.close();
  });
}
