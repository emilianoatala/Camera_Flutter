import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final photos = arguments['photos'];
    final initialPosition = arguments['initialPosition'].toDouble();
    final size = MediaQuery.of(context).size;
    ScrollController _controller = ScrollController(
        initialScrollOffset: size.width.toDouble() * initialPosition);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              var file = photos[i]["file"];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        width: size.width,
                        height: size.height * 0.5,
                        child: Hero(
                            tag: photos[i],
                            child: Image.file(
                            file,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(photos[i]["position"],
                          style: TextStyle(
                            color: Colors.white,
                          )))
                ],
              );
            }),
      ),
    );
  }
}
