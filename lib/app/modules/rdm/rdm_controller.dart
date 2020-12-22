import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'rdm_controller.g.dart';

@Injectable()
class RdmController = _RdmControllerBase with _$RdmController;

abstract class _RdmControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
