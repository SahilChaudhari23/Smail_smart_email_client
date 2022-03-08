import 'package:flutter/material.dart';
class User {
  final int id;
  final String name;
  final Color imageUrl;
  final String emailId;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.emailId,
  });
}
