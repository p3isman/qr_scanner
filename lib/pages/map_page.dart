import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scanner/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Creates a future from scratch. Used to return a future when the callback is called (map is ready to use).
  Completer<GoogleMapController> _controller = Completer();

  /// Type of map
  MapType _mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _initialPosition = CameraPosition(
      target: scan.getCoordinates(),
      zoom: 17,
    );

    // Markers
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
      markerId: const MarkerId('geo-location'),
      position: scan.getCoordinates(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinates'),
        actions: [
          IconButton(
              icon: const Icon(Icons.location_on),
              // Animates camera to the original position
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_initialPosition));
              })
        ],
      ),
      body: GoogleMap(
        mapType: _mapType,
        markers: markers,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          child: const Icon(Icons.layers),
          onPressed: () {
            _mapType =
                _mapType == MapType.normal ? MapType.satellite : MapType.normal;
            setState(() {});
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
