import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamController<ConnectivityResult> connectivityController = StreamController.broadcast();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityController.add(result);
    });
  }
}