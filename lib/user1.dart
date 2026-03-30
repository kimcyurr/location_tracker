import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
  String status = "Press button to send location";

  Future<void> sendLocation() async {
    try {
      // Check permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          status = "Location permission denied";
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Send to FastAPI
      var url = Uri.parse(
        // "http://10.0.2.2:8000/update-location?user_id=user1&latitude=$latitude&longitude=$longitude",
        "http://localhost:8000/update-location?user_id=user1&latitude=$latitude&longitude=$longitude",
      );

      var response = await http.post(url);

      if (response.statusCode == 200) {
        setState(() {
          status = "Location sent successfully!";
        });
      } else {
        setState(() {
          status = "Failed to send location";
        });
      }
    } catch (e) {
      setState(() {
        status = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send GPS Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendLocation,
              child: Text("Send Location"),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
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
//   String status = "Press button to send location";

//   GoogleMapController? mapController;
//   LatLng user2Location = LatLng(8.4846, 123.8048); // default location

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

//       double latitude = position.latitude;
//       double longitude = position.longitude;

//       // var url = Uri.parse(
//       //   "http://10.0.2.2:8000/update-location?user_id=user1&latitude=$latitude&longitude=$longitude",
//       // );
//       var url = Uri.parse(
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

//   Future<void> fetchUser2Location() async {
//     try {
//       var url = Uri.parse("http://10.0.2.2:8000/get-location?user_id=user2");

//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         double latitude = data['latitude'];
//         double longitude = data['longitude'];

//         setState(() {
//           user2Location = LatLng(latitude, longitude);
//         });

//         mapController?.animateCamera(CameraUpdate.newLatLng(user2Location));
//       }
//     } catch (e) {
//       print("Error fetching user2 location: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchUser2Location();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("GPS Location Tracker")),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: user2Location,
//                 zoom: 15,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               markers: {
//                 Marker(
//                   markerId: MarkerId('user2'),
//                   position: user2Location,
//                   infoWindow: InfoWindow(title: 'User 2 Location'),
//                 ),
//               },
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(status),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: sendLocation,
//                     child: Text("Send My Location"),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: fetchUser2Location,
//                     child: Text("Refresh User 2 Location"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
