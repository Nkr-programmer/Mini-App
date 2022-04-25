import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

class Utilities {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }
}
