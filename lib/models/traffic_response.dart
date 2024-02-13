import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficResponse {
  List<Features>? features;

  TrafficResponse({features});

  TrafficResponse.fromJson(Map<String, dynamic> json) {
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  Properties? properties;
  Geometry? geometry;

  Features({properties, geometry});

  Features.fromJson(Map<String, dynamic> json) {
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

class Properties {
  String? units;
  int? distance;
  String? distanceUnits;
  double? time;

  Properties({units, distance, distanceUnits, time});

  Properties.fromJson(Map<String, dynamic> json) {
    units = json['units'];
    distance = json['distance'];
    distanceUnits = json['distance_units'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['units'] = units;
    data['distance'] = distance;
    data['distance_units'] = distanceUnits;
    data['time'] = time;
    return data;
  }
}

class Geometry {
  List<LatLng>? coordinates;

  Geometry({coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'][0].forEach((v) {
        coordinates!.add(LatLng(v[0], v[1]));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
