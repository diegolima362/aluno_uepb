import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_content_controller.g.dart';

@Injectable()
class HomeContentController = _HomeContentBase with _$HomeContentController;

abstract class _HomeContentBase with Store {}
