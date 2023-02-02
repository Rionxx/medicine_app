import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class Base64Helper {
  base64String(Uint8List image) {
    return base64Encode(image);
  }

  imageFromBase64String(String image) {
    return Image.memory(base64Decode(image));
  }
}
