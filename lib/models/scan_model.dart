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
    } else if (_isCoordinate(this.value)) {
      this.type = 'geo';
    } else {
      this.type = 'other';
    }
    // TODO: check for phone numbers and other types
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
    final lat = double.parse(coordinates[0]);
    final lng = double.parse(coordinates[1]);
    final LatLng latlng = LatLng(lat, lng);

    return latlng;
  }

  bool _isCoordinate(String str) {
    List<String> parts = str.substring(4).split(',');
    if (parts.length != 2) {
      return false;
    }

    double? lat = double.tryParse(parts[0]);
    if (lat == null) return false;

    double? lng = double.tryParse(parts[1]);
    if (lng == null) return false;

    if (lat < -90 || lat > 90) {
      return false;
    }

    if (lng < -180 || lng > 180) {
      return false;
    }

    return true;
  }
}
