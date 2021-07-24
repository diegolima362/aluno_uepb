import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'history_controller.g.dart';

@Injectable()
class HistoryController = _HistoryBase with _$HistoryController;

abstract class _HistoryBase with Store {
  final DataController storage;

  @observable
  var isLoading = true;

  @observable
  var hasError = false;

  @observable
  var history = ObservableList<HistoryEntryModel>();

  _HistoryBase(this.storage) {
    loadData();
  }

  @action
  Future<void> loadData() async {
    try {
      isLoading = true;
      setHistory(await storage.getHistory());
    } catch (e) {
      print('HistoryController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  void setHistory(List<HistoryEntryModel>? value) {
    if (value != null) {
      print('> HistoryController: set history');
      history.clear();
      history.addAll(value);
      history.sort((a, b) => a.semester.compareTo(b.semester));
    }
  }

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      history.clear();
      setHistory(await storage.updateHistory());
    } catch (e) {
      print('HistoryController > \n$e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }
}
