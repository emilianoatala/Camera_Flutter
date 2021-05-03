import 'package:flutter/material.dart';
import 'package:flutter_test_v2/src/pages/gallery_page.dart';
import 'package:flutter_test_v2/src/pages/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => Home(),
          "gallery": (BuildContext context) => GalleryPage()
        });
  }
}
