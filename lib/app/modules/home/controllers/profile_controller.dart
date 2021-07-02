import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/notifications/interfaces/notifications_manager_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'profile_controller.g.dart';

@Injectable()
class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  late final AuthController _authController;

  late final DataController _storage;

  late final INotificationsManager _manager;

  @observable
  UserModel? user;

  @observable
  ProfileModel? profile;

  @observable
  bool darkMode = false;

  @observable
  int accentCode = 0xffe43f5a;

  @observable
  int tempAccentCode = 0xffe43f5a;

  @observable
  int activeNotifications = 0;

  _ProfileControllerBase() {
    _authController = Modular.get();
    _storage = Modular.get();
    _manager = Modular.get();

    user = _authController.user;
    _authController.onAuthStateChanged.listen(setUser);

    loadData();
  }

  @action
  Future<void> cancelAllNotifications() async {
    await _manager.cancelAllNotifications();

    await loadData();
  }

  @action
  Future<void> loadData() async {
    if (!_storage.loadingData) {
      setProfile(await _storage.getProfile());

      final length = (await _manager.pendingNotificationRequests()).length;
      setActiveNotifications(length);

      setTheme(_storage.themeMode);

      setAccent(
        darkMode ? _storage.darkAccentColorCode : _storage.lightAccentColorCode,
      );
    }
  }

  @action
  Future<void> logout() async {
    await _storage.clearDatabase();
    await Modular.get<INotificationsManager>().cancelAllNotifications();
    await Modular.get<AuthController>().signOut();
  }

  @action
  Future<void> setAccent(int value) async {
    accentCode = value;

    darkMode
        ? await _storage.setDarkAccentColor(value)
        : await _storage.setLightAccentColor(value);
  }

  @action
  void setActiveNotifications(int value) => activeNotifications = value;

  @action
  void setProfile(ProfileModel? value) {
    profile = value;
  }

  @action
  void setTempAccent(int value) {
    tempAccentCode = value;
  }

  @action
  Future<void> setTheme(bool? value) async {
    if (value != null) {
      darkMode = value;
      value
          ? accentCode = _storage.darkAccentColorCode
          : accentCode = _storage.lightAccentColorCode;

      _storage.setThemeMode(value);
    }
  }

  @action
  void setUser(UserModel? value) {
    user = value;
  }

  @action
  Future<void> showDetails() async {
    await Modular.to.pushNamed('profile/details');
  }

  @action
  Future<void> showHistory() async {
    await Modular.to.pushNamed('profile/history');
  }

  @action
  Future<void> signOut() async {
    await Future.wait([
      _storage.clearDatabase(),
      cancelAllNotifications(),
      _authController.signOut(),
    ]);
  }

  @action
  Future<void> update() async {
    setProfile(null);
    print('> ProfileController : update profile');
    setProfile(await _storage.updateProfile());
  }
}