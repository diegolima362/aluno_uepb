import 'package:auto_injector/auto_injector.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

import 'data/datasources/local/secure_storage/auth_secure_storage_local_datasource.dart';
import 'data/datasources/local/secure_storage/secure_storage.dart';
import 'data/datasources/local/sqflite/sqflite.dart';
import 'data/datasources/remote/suap_uepb/uepb_remote_datasource.dart';
import 'data/repositories/repositories_implementations.dart';
import 'data/services/services.dart';
import 'interactor/datasources/academic_datasource.dart';
import 'interactor/repositories/repositories.dart';
import 'interactor/services/worker_service.dart';

final injector = AutoInjector();

void initializeAutoInjector() {
  injector
    //
    ..addInstance<Database>(sqfliteDatabase)
    ..addInstance<FlutterSecureStorage>(secureStorage)
    ..addSingleton<AppLocalDataSource>(SqfliteLocalDataSource.new)
    ..addSingleton<AuthLocalDataSource>(AuthSecureStorageLocalDataSource.new)
    //
    ..addInstance<IOClient>(appIOClient)
    ..addSingleton(AppHttpClient.new)
    ..addSingleton<AppRemoteDataSource>(UepbRemoteDatasource.new)
    //
    ..addLazySingleton(Connectivity.new)
    ..addLazySingleton(ConnectivityPlusService.new)
    //
    ..addInstance(flutterLocalNotificationsPlugin)
    ..addLazySingleton(LocalNotificationService.new)
    //
    ..addLazySingleton<Workmanager>(Workmanager.new)
    ..addLazySingleton<WorkerService>(WorkManagerService.new)
    ..addSingleton<PreferencesRepository>(PreferencesRepositoryImpl.new)
    //
    ..addLazySingleton<AuthRepository>(AuthRepositoryImpl.new)
    ..addLazySingleton<CoursesRepository>(CoursesRepositoryImpl.new)
    ..addLazySingleton<HistoryRepository>(HistoryRepositoryImpl.new)
    ..addLazySingleton<ProfileRepository>(ProfileRepositoryImpl.new)
    ..commit();
}
