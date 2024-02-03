import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:flutter/material.dart'; // for the utf8.encode method

String encrypt(String plaintext) {
  var bytes = utf8.encode(plaintext); // data being hashed

  var digest = sha256.convert(bytes);

  //debugPrint("Digest as bytes: ${digest.bytes}");
  //debugPrint("Digest as hex string: $digest");
  debugPrint("Digest as string: ${digest.toString()}");

  return digest.toString();
}

String getUUID() {
  // Generate a UUID using the v4 (random) version
  String randomUuid = Uuid().v4();
  print('Random UUID: $randomUuid');

  // Generate a UUID using the v1 (timestamp-based) version
  String timestampUuid = Uuid().v1();
  print('Timestamp-based UUID: $timestampUuid');

  return timestampUuid;
}