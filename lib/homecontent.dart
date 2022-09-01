import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:geopoint/geopoint.dart';


class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  MapShapeSource? dataSource;
  final MapShapeLayerController layerController = MapShapeLayerController();

  final _currentPositions = GeoPoint(latitude: 78.539940220065063, longitude: 31.226518053565304);
  final _targetPositions = GeoPoint(latitude: 78.518856236126325, longitude: 31.221557115268627);

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  double? totalDistance;

  @override
  void dispose() {
    layerController.dispose();
    super.dispose();
  }

  // final _currentPositionLatitude = 78.539940220065063;    // 38.8951;
  // final _currentPositionLongtitude = 31.226518053565304;  //-77.0364;

  // final _finalPositionLatitude = 78.518856236126325;   //40.8951;
  // final _finalPositionLongitude = 31.221557115268627;  //-80.0364;

  // List<Model>? data;
  // MapShapeLayerController? _controller;

  @override
  void initState() {

    // data = <Model> [
    //   Model('Tripura', 92.30416466686583, 24.222087713976798),
    //   Model('Kerala', 75.028733352362266, 12.688760688454973),
    // ];
    // _controller = MapShapeLayerController();


    dataSource = MapShapeSource.asset(
      'assets/json/india.json',
      shapeDataField: 'name',
      // dataCount: data.length,
      // primaryValueMapper: (int index) => data[index].name,
      // dataLabelMapper: (int index) => data[index].dataLabel,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [

            // Container(
            //   child: TextField(
            //     controller: currentController,
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     decoration: InputDecoration(
            //       contentPadding:
            //       EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(color: Colors.black),
            //       ),
            //       focusedBorder: const OutlineInputBorder(
            //         borderSide: const BorderSide(color: Colors.black),
            //       ),
            //       hintText: 'Target location',
            //       hintStyle: TextStyle(color: Colors.black),
            //     ),
            //   ),
            // ),
            //
            // Container(
            //   child: TextField(
            //     controller: currentController,
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     decoration: InputDecoration(
            //       contentPadding:
            //       EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(color: Colors.black),
            //       ),
            //       focusedBorder: const OutlineInputBorder(
            //         borderSide: const BorderSide(color: Colors.black),
            //       ),
            //       hintText: 'Current location',
            //       hintStyle: TextStyle(color: Colors.black),
            //     ),
            //   ),
            // ),

            SfMaps(
              layers: [
                MapShapeLayer(
                  source: dataSource!,
                  controller: layerController,
                  initialMarkersCount: 2,
                  markerBuilder: (BuildContext context, int index) {
                    // return MapMarker(
                    //     latitude: data![index].latitude,
                    //     longitude: data![index].longitude,
                    //     child: Icon(Icons.location_on_outlined),
                    // );

                    if(index == 0) {
                      return MapMarker(
                        latitude: _currentPositions.latitude,
                        longitude: _currentPositions.longitude,
                        child: Icon(Icons.location_on_outlined),
                        iconColor: Colors.blue,
                      );
                    } else if(index == 1) {
                      return MapMarker(
                        latitude: _targetPositions.latitude,
                        longitude: _targetPositions.longitude,
                        child: Icon(Icons.location_on_outlined),
                        iconColor: Colors.blue,
                      );
                    }
                    return null!;
                  },

                  loadingBuilder: (BuildContext context) {
                    return Container(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    );
                  },
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                layerController.insertMarker(0);
                layerController.insertMarker(1);
              },
              child: Text('Add Maker'),
            ),

            Text(totalDistance.toString()),

            ElevatedButton(
                onPressed: (){
                  setState(() {
                    totalDistance = calculateDistance(_currentPositions.latitude, _currentPositions.longitude, _targetPositions.latitude, _targetPositions.longitude);

                    // _distance = Geolocator.distanceBetween(_currentPositionLatitude, _currentPositionLongtitude, _finalPositionLatitude, _finalPositionLongtitude * 0.000621371);
                    // print(_distance.toString());
                  });
                },
                child: Text('Get Distance')
            ),




            // Card(
            //   child: Container(
            //     padding: EdgeInsets.all(20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         RichText(
            //             text: TextSpan(
            //               children: [
            //                 TextSpan(
            //                     text: '${'_distanceInMiles?.toStringAsFixed(2)' ?? '-'} miles',
            //                     style: TextStyle(
            //                         fontSize: 20,
            //                         fontStyle: FontStyle.italic,
            //                         color: Colors.black
            //                     )
            //                 ),
            //
            //                 TextSpan(
            //                     text: '${'-'} miles',
            //                     style: TextStyle(
            //                         fontSize: 20,
            //                         fontStyle: FontStyle.italic,
            //                         color: Colors.black
            //                     )
            //                 ),
            //               ]
            //             )
            //
            //         ),
            //         Row(
            //           children: [
            //             OutlinedButton(
            //               child: Text('Navigate'),
            //               onPressed: () async {},
            //             ),
            //             SizedBox(
            //               width: 15,
            //             ),
            //             OutlinedButton(
            //               child: Text('Remove Tracker'),
            //               onPressed: () async {},
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),




          ],
        ),
      ),
    );
  }
}

class Model {
  Model(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}


