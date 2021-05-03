import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:share/share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> photos = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const spinkit = SpinKitRipple(
      color: Colors.white,
      size: 40.0,
    );

    return Scaffold(
        appBar: AppBar(title: Text("Image Picker"), centerTitle: true),
        body: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CameraContainer(photos: photos, size: size),
                FloatingActionButton(
                    onPressed: () async {
                      setState(() => {
                        loading:true
                      });
                      Position position = await _initGeoLocator();
                      openCamera(context, photos, setState, position, loading);
                    },
                    child: !loading ? Icon(Icons.camera) : spinkit
                  )
              ]
            )));
  }
}

class _CameraContainer extends StatelessWidget {
  const _CameraContainer({
    Key key,
    @required this.photos,
    @required this.size,
  }) : super(key: key);

  final List photos;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flexible(
          child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: photos.length,
              itemBuilder: (_, index) {
                var file = photos[index]["file"];
                return Container(
                  width: size.width,
                  child: GestureDetector(
                    onLongPress: () => Share.shareFiles([file.path]),
                    onTap: () => {
                      Navigator.of(context).pushNamed("gallery", arguments: {
                        'photos': photos,
                        "initialPosition": index
                      })
                    },
                    child: Hero(
                      tag: photos[index],
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}

void openCamera(
    BuildContext context, List photos, Function setState, Position position, bool loading) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CameraCamera(
                onFile: (item) async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      position.latitude, position.longitude);
                  dynamic finalPosition = placemarks[1];
                  String place = finalPosition.street +
                      ", " +
                      finalPosition.locality +
                      ", " +
                      finalPosition.country;
                  final insertion = {"file": item, "position": place};
                  photos.add(insertion);
                  Navigator.pop(context);
                  setState(() => {
                    loading:false
                  });
                },
              )));
}

Future _initGeoLocator() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) Future.error('Location services are disabled.');

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied)
      Future.error('Location permissions are denied');
  }

  if (permission == LocationPermission.deniedForever)
    Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
