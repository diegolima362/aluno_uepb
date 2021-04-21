import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
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

    history.clear();

    final data = await storage.getHistory();

    if (data != null) {
      history.addAll(data);

      history.sort((a, b) => a.semester.compareTo(b.semester));
    }

    setIsLoading(false);
  }

  @action
  void setExtended(bool value) => extended = value;

  @action
  void setIsLoading(bool value) => isLoading = value;

  @action
  void setHistory(List<HistoryEntryModel>? value) {
    if (value != null) {
      print('> HistoryController: set history');

      history = ObservableList<HistoryEntryModel>();
      history.addAll(value);
      history.sort((a, b) => a.semester.compareTo(b.semester));
    }
  }

  @action
  Future<void> update() async {
    history.clear();
    setHistory(await storage.updateHistory());
    Modular.get<IEventLogger>().logEvent('logUpdateHistory');
  }
}
