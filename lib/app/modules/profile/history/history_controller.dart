import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'history_controller.g.dart';

@Injectable()
class HistoryController = _HistoryBase with _$HistoryController;

abstract class _HistoryBase with Store {
  DataController storage;

  @observable
  bool extended;

  @observable
  ObservableList<HistoryEntryModel> history;

  _HistoryBase() {
    storage = Modular.get();
    extended = true;
    loadData();
  }

  @action
  Future<void> loadData() async {
    history = ObservableList<HistoryEntryModel>();

    final data = await storage.getHistory();

    if (data != null) {
      history.addAll(data);

      history.sort((a, b) => a.semester.compareTo(b.semester));
    }
  }

  @action
  void setExtended(bool value) {
    extended = value;
  }

  @action
  void setHistory(List<HistoryEntryModel> value) {
    if (value != null) {
      print('> HistoryController: set history');

      history = ObservableList<HistoryEntryModel>();
      history.addAll(value);
      history.sort((a, b) => a.semester.compareTo(b.semester));
    }
  }

  @action
  Future<void> update() async {
    history = null;
    setHistory(await storage.updateHistory());
    Modular.get<IEventLogger>().logEvent('logUpdateHistory');
  }
}
