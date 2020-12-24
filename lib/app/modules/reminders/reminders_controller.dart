import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'reminders_controller.g.dart';

@Injectable()
class RemindersController = _RemindersControllerBase with _$RemindersController;

abstract class _RemindersControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
