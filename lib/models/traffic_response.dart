import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficResponse {
  List<Features>? features;

  TrafficResponse({this.features});

  TrafficResponse.fromJson(Map<String, dynamic> json) {
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  Properties? properties;
  Geometry? geometry;

  Features({this.properties, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    geometry =
        json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    return data;
  }
}

class Properties {
  String? units;
  int? distance;
  String? distanceUnits;
  double? time;

  Properties({this.units, this.distance, this.distanceUnits, this.time});

  Properties.fromJson(Map<String, dynamic> json) {
    units = json['units'];
    distance = json['distance'];
    distanceUnits = json['distance_units'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['units'] = this.units;
    data['distance'] = this.distance;
    data['distance_units'] = this.distanceUnits;
    data['time'] = this.time;
    return data;
  }
}

class Geometry {
  List<LatLng>? coordinates;

  Geometry({this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'][0].forEach((v) {
        coordinates!.add(LatLng(v[0], v[1]));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
