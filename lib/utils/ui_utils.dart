import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  SemanticsService.announce(message, TextDirection.ltr);
}
