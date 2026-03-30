// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: LocationPage());
//   }
// }

// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   String status = "Press button to send location";

//   Future<void> sendLocation() async {
//     try {
//       // Check permission
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           status = "Location permission denied";
//         });
//         return;
//       }

//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       double latitude = position.latitude;
//       double longitude = position.longitude;

//       // Send to FastAPI
//       var url = Uri.parse(
//         // "http://10.0.2.2:8000/update-location?user_id=user1&latitude=$latitude&longitude=$longitude",
//         "http://localhost:8000/update-location?user_id=user1&latitude=$latitude&longitude=$longitude",
//       );

//       var response = await http.post(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           status = "Location sent successfully!";
//         });
//       } else {
//         setState(() {
//           status = "Failed to send location";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         status = "Error: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Send GPS Location")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(status),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendLocation,
//               child: Text("Send Location"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// user 2
// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: LocationPage());
//   }
// }

// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   String baseUrl = "http://localhost:8000";

//   GoogleMapController? mapController;

//   LatLng user1Location = LatLng(0, 0);
//   LatLng user2Location = LatLng(0, 0);

//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();

//     // Auto update every 5 seconds
//     timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       getUser1Location();
//       getUser2Location();
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   // SEND LOCATION AS USER 1
//   Future<void> sendUser1Location() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     double lat = position.latitude;
//     double lng = position.longitude;

//     var url = Uri.parse(
//       "$baseUrl/update-location?user_id=user1&latitude=$lat&longitude=$lng",
//     );

//     await http.post(url);
//   }

//   // SEND LOCATION AS USER 2
//   Future<void> sendUser2Location() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     double lat = position.latitude;
//     double lng = position.longitude;

//     var url = Uri.parse(
//       "$baseUrl/update-location?user_id=user2&latitude=$lat&longitude=$lng",
//     );

//     await http.post(url);
//   }

//   // GET USER 1 LOCATION
//   Future<void> getUser1Location() async {
//     try {
//       var url = Uri.parse("$baseUrl/get-location/user1");
//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         setState(() {
//           user1Location = LatLng(data['latitude'], data['longitude']);
//         });
//       }
//     } catch (e) {
//       print("Error loading user1: $e");
//     }
//   }

//   // GET USER 2 LOCATION
//   Future<void> getUser2Location() async {
//     try {
//       var url = Uri.parse("$baseUrl/get-location/user2");
//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         setState(() {
//           user2Location = LatLng(data['latitude'], data['longitude']);
//         });
//       }
//     } catch (e) {
//       print("Error loading user2: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Live Map Tracker")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(target: user1Location, zoom: 15),
//         onMapCreated: (controller) {
//           mapController = controller;
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId("user1"),
//             position: user1Location,
//             infoWindow: InfoWindow(
//               title: "User ID: user1",
//               snippet: "Current Location",
//             ),
//           ),
//           Marker(
//             markerId: MarkerId("user2"),
//             position: user2Location,
//             infoWindow: InfoWindow(
//               title: "User ID: user2",
//               snippet: "Current Location",
//             ),
//           ),
//         },
//       ),

//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             heroTag: "user1",
//             onPressed: sendUser1Location,
//             child: Icon(Icons.person),
//           ),
//           SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: "user2",
//             onPressed: sendUser2Location,
//             child: Icon(Icons.people),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LocationPage());
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String baseUrl = "http://localhost:8000";

  GoogleMapController? mapController;

  LatLng user1Location = LatLng(0, 0);

  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Auto update every 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getOtherUserLocation();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 📍 SEND YOUR LOCATION
  Future<void> sendLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double lng = position.longitude;

    var url = Uri.parse(
      "$baseUrl/update-location?user_id=user1&latitude=$lat&longitude=$lng",
    );

    await http.post(url);
  }

  // 👀 GET USER1 LOCATION
  Future<void> getOtherUserLocation() async {
    try {
      var url = Uri.parse("$baseUrl/get-location/user1");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        LatLng newLocation = LatLng(data['latitude'], data['longitude']);

        setState(() {
          user1Location = newLocation;
        });

        // Move camera to new position
        mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Map Tracker")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: user1Location, zoom: 15),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId("user1"),
            position: user1Location,
            infoWindow: InfoWindow(title: "User 1"),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendLocation,
        child: Icon(Icons.send),
      ),
    );
  }
}
