import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/services/connectivity_service.dart';

class ConnectivityPlusService implements ConnectivityService {
  final Connectivity connectivity;

  ConnectivityPlusService(this.connectivity);

  @override
  Stream<bool> get connectionStream {
    return connectivity.onConnectivityChanged.map(
      (e) {
        try {
          return e.first != ConnectivityResult.none;
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
      return result.first != ConnectivityResult.none && await _checkStatus();
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
