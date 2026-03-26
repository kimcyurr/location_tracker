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
//   String status = "Ready";

//   // ⚠️ CHANGE THIS IF USING REAL DEVICE
//   String baseUrl = "http://localhost:8000";
//   // Example:
//   // String baseUrl = "http://192.168.1.5:8000";

//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();

//     // 🔄 Auto fetch other user location every 5 seconds
//     timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       getOtherUserLocation();
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   // 📍 SEND YOUR LOCATION
//   Future<void> sendLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();

//       if (permission == LocationPermission.denied) {
//         setState(() {
//           status = "Location permission denied";
//         });
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       double lat = position.latitude;
//       double lng = position.longitude;

//       var url = Uri.parse(
//         "$baseUrl/update-location?user_id=user1&latitude=$lat&longitude=$lng",
//       );

//       var response = await http.post(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           status = "✅ Sent:\nLat: $lat\nLng: $lng";
//         });
//       } else {
//         setState(() {
//           status = "❌ Failed to send location";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         status = "Error: $e";
//       });
//     }
//   }

//   // 👀 GET OTHER USER LOCATION
//   Future<void> getOtherUserLocation() async {
//     try {
//       var url = Uri.parse("$baseUrl/get-location/user1");

//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         setState(() {
//           status =
//               "👤 User1 Location:\nLat: ${data['latitude']}\nLng: ${data['longitude']}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         status = "Error fetching: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("IoT Location Tracker")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 status,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 30),

//               // SEND BUTTON
//               ElevatedButton(
//                 onPressed: sendLocation,
//                 child: Text("Send My Location"),
//               ),

//               SizedBox(height: 15),

//               // GET BUTTON
//               ElevatedButton(
//                 onPressed: getOtherUserLocation,
//                 child: Text("Get User1 Location"),
//               ),
//             ],
//           ),
//         ),
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
