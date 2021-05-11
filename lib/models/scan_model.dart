// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

// With a string (not JSON)
ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

// Create JSON from model
String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  int? id;
  String? type;
  String value;

  /// Creates a new ScanModel from a value
  ScanModel({this.id, this.type, required this.value}) {
    if (this.value.contains('http')) {
      this.type = 'http';
    } else {
      this.type = 'geo';
    }
  }

  /// Creates a new ScanModel from a JSON
  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  /// Creates a JSON from properties
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  /// Extracts coordinates from the scan's value
  LatLng getCoordinates() {
    final coordinates = this.value.substring(4).split(',');
    final latitude = double.parse(coordinates[0]);
    final longitude = double.parse(coordinates[1]);
    final LatLng latlng = LatLng(latitude, longitude);

    return latlng;
  }
}
