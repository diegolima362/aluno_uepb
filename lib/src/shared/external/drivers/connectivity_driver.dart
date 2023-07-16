import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/types/types.dart';

import '../interfaces/connectivity_driver.dart';

class ConnectivityDriver implements IConnectivityDriver {
  final Connectivity connectivity;

  ConnectivityDriver(this.connectivity);

  @override
  Stream<bool> get connectionStream {
    return connectivity.onConnectivityChanged.map(
      (e) {
        try {
          return e != ConnectivityResult.none;
        } catch (e) {
          return false;
        }
      },
    );
  }

  @override
  Future<bool> get isOnline async {
    try {
      var result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none && await _checkStatus();
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<bool> _checkStatus() async {
    bool isOnline = false;

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      }
    } catch (e) {
      isOnline = false;
      rethrow;
    }

    return isOnline;
  }
}
