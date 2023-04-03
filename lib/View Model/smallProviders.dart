import 'package:flutter/material.dart';

class SmallProviders extends ChangeNotifier {
  bool _showemoji = false;

  bool get showemoji => _showemoji;
  setemoji() {
    _showemoji = !showemoji;
  }
}
