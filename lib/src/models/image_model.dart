import 'dart:convert';

import 'dart:io';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    ImageModel({
        this.id,
        this.file,
        this.position,
    });

    int id;
    String file;
    String position;

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        file: json["file"],
        position: json["position"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "position": position,
    };
}