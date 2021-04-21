import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'history_controller.g.dart';

@Injectable()
class HistoryController = _HistoryBase with _$HistoryController;

abstract class _HistoryBase with Store {
  late final DataController storage;

  @observable
  bool extended = true;

  @observable
  bool isLoading = true;

  @observable
  ObservableList<HistoryEntryModel> history =
      ObservableList<HistoryEntryModel>();

  _HistoryBase() {
    storage = Modular.get();
    loadData();
  }

  @action
  Future<void> loadData() async {
    setIsLoading(true);
    final data = await storage.getHistory();
    if (data != null) {
      setHistory(data);
    }

    setIsLoading(false);
  }

  @action
  void setExtended(bool value) => extended = value;

  @action
  void setIsLoading(bool value) => isLoading = value;

  @action
  void setHistory(List<HistoryEntryModel>? value) {
    print(value);
    if (value != null) {
      print('> HistoryController: set history');
      history.clear();
      history.addAll(value);
      history.sort((a, b) => a.semester.compareTo(b.semester));
    }
  }

  @action
  Future<void> update() async {
    setIsLoading(true);
    history.clear();
    setHistory(await storage.updateHistory());
    setIsLoading(false);
  }
}
