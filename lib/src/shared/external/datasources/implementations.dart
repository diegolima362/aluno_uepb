import 'package:flutter_modular/flutter_modular.dart';

import '../../data/datasources/remote_datasource.dart';
import '../../data/types/open_protocol.dart';
import '../../data/types/types.dart';
import 'ca_uepb/datasource.dart';
import 'ca_ufcg/datasource.dart';
import 'open_protocol/datasource.dart';
import 'suap_uepb/datasource.dart';

enum DataSourceImplementation {
  suapUepb,
  caUepb,
  caUfcg,
  openProtocol,
  none,
}

extension Format on DataSourceImplementation {
  String get title {
    switch (this) {
      case DataSourceImplementation.suapUepb:
        return 'UEPB - SUAP';
      case DataSourceImplementation.caUepb:
        return 'UEPB - Controle Acadêmico';
      case DataSourceImplementation.caUfcg:
        return 'UFCG - Controle Acadêmico';
      case DataSourceImplementation.openProtocol:
        return 'Protocolo Aberto';
      default:
        return 'none';
    }
  }
}

AcademicRemoteDataSource getRemoteDataSourceImplementation(
  DataSourceImplementation impl, [
  OpenProtocolSpec? spec,
]) {
  switch (impl) {
    case DataSourceImplementation.suapUepb:
      return SuapUpebRemoteDataSource(Modular.get());
    case DataSourceImplementation.caUepb:
      return CaUepbRemoteDataSource(Modular.get());
    case DataSourceImplementation.caUfcg:
      return CaUfcgRemoteDataSource(Modular.get());
    case DataSourceImplementation.openProtocol:
      return OpenProtocolRemoteDataSource(Modular.get(), spec!);
    default:
      throw AppException('Invalid implementation');
  }
}
