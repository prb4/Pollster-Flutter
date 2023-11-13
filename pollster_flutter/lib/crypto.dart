import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:flutter/material.dart'; // for the utf8.encode method

String encrypt(String plaintext) {
  var bytes = utf8.encode(plaintext); // data being hashed

  var digest = sha1.convert(bytes);

  //debugPrint("Digest as bytes: ${digest.bytes}");
  //debugPrint("Digest as hex string: $digest");
  debugPrint("Digest as string: ${digest.toString()}");

  return digest.toString();
}