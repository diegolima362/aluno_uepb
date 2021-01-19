import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class CheckConnection {
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on TimeoutException catch (e) {
      throw PlatformException(
        message: 'Sem conexão com a internet',
        code: 'timeout_error',
        details: e.toString(),
      );
    } on SocketException catch (e) {
      throw PlatformException(
        message: 'Sem conexão com a internet',
        code: 'error_connection',
        details: e.toString(),
      );
    } catch (e) {
      throw PlatformException(
        message: 'Sem conexão com a internet',
        code: 'error_connection',
        details: e.toString(),
      );
    }
    return false;
  }
}
