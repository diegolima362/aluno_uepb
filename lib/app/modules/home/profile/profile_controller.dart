import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:workmanager/workmanager.dart';

part 'profile_controller.g.dart';

@Injectable()
class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  final AuthController authController;
  final DataController storage;
  final INotificationsManager notificationManager;

  @observable
  ProfileModel? profile;

  @observable
  var isLoading = true;

  @observable
  var hasError = false;

  @observable
  var isDarkMode = false;

  @observable
  var isBackgroundTaskActivated = false;

  @observable
  var accentCode = 0xffe43f5a;

  @observable
  var tempAccentCode = 0xffe43f5a;

  @observable
  var activeNotifications = 0;

  _ProfileControllerBase({
    required this.authController,
    required this.storage,
    required this.notificationManager,
  }) {
    loadData();
  }

  @action
  Future<void> loadData() async {
    try {
      isLoading = true;

      setProfile(await storage.getProfile());

      setActiveNotifications(
          (await notificationManager.pendingNotificationRequests()).length);

      setActiveBackgrounTask(storage.backgroundTaskActivated);

      setTheme(storage.themeMode);

      setAccent(
        isDarkMode ? storage.darkAccentColorCode : storage.lightAccentColorCode,
      );
    } catch (e) {
      print('ProfileController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> setAccent(int value) async {
    accentCode = value;

    isDarkMode
        ? await storage.setDarkAccentColor(value)
        : await storage.setLightAccentColor(value);
  }

  @action
  void setActiveNotifications(int value) => activeNotifications = value;

  @action
  void setActiveBackgrounTask(bool value) => isBackgroundTaskActivated = value;

  @action
  void setProfile(ProfileModel? value) => profile = value;

  @action
  void setTempAccent(int value) => tempAccentCode = value;

  @action
  Future<void> setTheme(bool? value) async {
    if (value != null) {
      isDarkMode = value;
      value
          ? accentCode = storage.darkAccentColorCode
          : accentCode = storage.lightAccentColorCode;

      storage.setThemeMode(value);
    }
  }

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      setProfile(await storage.updateProfile());
    } catch (e) {
      print('ProfileController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> activateBackgroundTask(bool value) async {
    if (value) {
      await Workmanager().registerPeriodicTask(
        'verifyRDM',
        'simplePeriodicTask',
        existingWorkPolicy: ExistingWorkPolicy.replace,
        frequency: Duration(hours: 1),
        initialDelay: Duration(seconds: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      await Workmanager().cancelAll();
    }

    setActiveBackgrounTask(value);
    storage.setBackgroundTaskActivated(value);
  }

  Future<void> cancelAllNotifications() async {
    await notificationManager.cancelAllNotifications();
    final length =
        (await notificationManager.pendingNotificationRequests()).length;
    setActiveNotifications(length);
  }

  Future<void> signOut() async {
    await Future.wait([
      storage.clearDatabase(),
      notificationManager.cancelAllNotifications(),
      Workmanager().cancelAll(),
    ]);

    await authController.signOut();
  }
}
