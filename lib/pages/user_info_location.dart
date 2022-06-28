import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/address.dart';
import '../models/users.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  late GoogleMapController _controller;
  CameraPosition _getUserLocation(double latitude, double longitude) =>
      CameraPosition(target: LatLng(latitude, longitude), zoom: 5.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Geo location = widget.user.address.geo;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.name}'),
      ),
      body: Stack(
        children: [buildGoogleMap(location), buildInfo()],
      ),
    );
  }

  Container buildInfo() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const Divider(),
                  Text('Street:  ${widget.user.address.street}'),
                  Text('Suite: ${widget.user.address.suite}'),
                  Text('City: ${widget.user.address.city}'),
                  Text('Zipcode: ${widget.user.address.zipcode}'),
                ],
              ),
              const SizedBox(
                height: 20,
                child: const Divider(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const Divider(),
                  Text(
                    'Name: ${widget.user.company.name}',
                  ),
                  Text(
                    'Catch Phrase: ${widget.user.company.catchPhrase}',
                  ),
                  Text(
                    'Bs: ${widget.user.company.bs}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GoogleMap buildGoogleMap(Geo location) {
    return GoogleMap(
      mapToolbarEnabled: true,
      initialCameraPosition: _getUserLocation(
          double.parse(location.lat), double.parse(location.lat)),
      onMapCreated: (GoogleMapController controller) =>
          _controller = controller,
      markers: {
        Marker(
            markerId: MarkerId(widget.user.address.street),
            position: LatLng(
              double.parse(location.lat),
              double.parse(location.lat),
            ),
            infoWindow: InfoWindow(
                title: widget.user.company.name,
                snippet: widget.user.company.catchPhrase))
      },
    );
  }
}
