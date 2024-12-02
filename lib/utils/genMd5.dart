// ignore: file_names
import 'dart:convert';
import 'package:crypto/crypto.dart';

String genMd5(String input) {
  // Chuyển chuỗi thành byte
  var bytes = utf8.encode(input);

  // Tạo mã MD5
  var digest = md5.convert(bytes);

  //var digest2 = md5.
  // Trả về chuỗi mã hóa
  return digest.toString();
}