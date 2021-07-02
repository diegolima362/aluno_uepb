import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final DataController storage;

  @observable
  int currentIndex = 0;

  @observable
  bool isLoading = true;

  @observable
  bool hasError = false;

  _HomeControllerBase(this.storage) {
    loadData();
  }

  @action
  Future<void> loadData() async {
    try {
      print('HomeController > get all data ...');
      isLoading = true;
      if (!(await storage.getAllData())) await storage.getAllData();
      print('HomeController > get all data OK');
      isLoading = false;
    } catch (e) {
      print('HomeController > \n$e');
      isLoading = false;
      hasError = true;
    }
  }

  @action
  void updateIndex(int value) => currentIndex = value;
}
