import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:workmanager/workmanager.dart';

import '../../main.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/datasources/social_remote_datasource.dart';
import 'data/repositories/social_repository.dart';
import 'data/services/connectivity_service.dart';
import 'data/services/notifications_service.dart';
import 'data/services/worker_service.dart';
import 'external/datasources/social/pb_social_remote_datasource.dart';
import 'external/drivers/connectivity_driver.dart';
import 'external/drivers/flutter_local_notification_driver.dart';
import 'external/drivers/http_client.dart';
import 'external/drivers/workmanager_driver.dart';
import 'external/interfaces/connectivity_driver.dart';
import 'external/interfaces/worker_driver.dart';

class SharedModule extends Module {
  @override
  void exportedBinds(i) {
    i
          ..addInstance<Isar>(isarInstance)
          ..addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new)
          ..addSingleton<IOClient>(() {
            final httpClient = HttpClient()
              ..badCertificateCallback = (_, __, ___) => true;

            return IOClient(httpClient);
          })
          ..addLazySingleton(AppHttpClient.new)
          //
          ..addSingleton(Connectivity.new)
          ..addSingleton<IConnectivityDriver>(ConnectivityDriver.new)
          ..addSingleton(ConnectivityService.new)
          //
          ..addInstance(flutterLocalNotificationsPlugin)
          ..addLazySingleton(FlutterLocaltNotificationDriver.new)
          ..addLazySingleton(NotificationsService.new)
          //
          ..addSingleton(Workmanager.new)
          ..addLazySingleton<WorkerDriver>(WorkManagerDriver.new)
          ..addLazySingleton(WorkerService.new)
        //
        ;

    final generic = GenericAcadamicRemoteDataSource();
    i
      ..addInstance<GenericAcadamicRemoteDataSource>(generic)
      ..addInstance<AcademicRemoteDataSource>(generic);

    final pb = PocketBase('http://10.0.2.2:8090');

    i
      ..addInstance<PocketBase>(pb)
      ..addSingleton<SocialRemoteDatasource>(
        PocketBaseSocialRemoteDatasource.new,
      )
      ..addSingleton<SocialRepository>(SocialRepository.new);
  }
}
