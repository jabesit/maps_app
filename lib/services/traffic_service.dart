import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;

  TrafficService() : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final url =
        "https://api.geoapify.com/v1/routing?waypoints=${start.latitude},${start.longitude}|${end.latitude},${end.longitude}&mode=drive&apiKey=b8568cb9afc64fad861a69edbddb2658";

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromJson(resp.data);

    return data;
  }

  Future<Either<String, List<String>>> searchByCriteria(String criteria) async {
    final url =
        "https://nominatim.openstreetmap.org/search.php?q=$criteria&polygon_geojson=1&format=jsonv2";

    final resp = await _dioTraffic.get(url);
    if (resp.statusCode == 200) {
      final List<String> list = [];
      final data = (resp.data as List);
      if (data.isEmpty) {
        return const Left("No Results...");
      }
      for (var element in data) {
        list.add(element['display_name']);
      }
      return Right(list);
    } else {
      return const Left("ServerError loss connection ");
    }
  }
}
