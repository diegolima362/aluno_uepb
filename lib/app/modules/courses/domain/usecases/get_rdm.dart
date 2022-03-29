import 'package:aluno_uepb/app/core/domain/services/connectivity_service.dart';

import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetRDM {
  Future<EitherString> call({bool cached = true});
}

class GetRDM implements IGetRDM {
  final ICoursesRepository repository;
  final IConnectivityService service;

  GetRDM(this.repository, this.service);

  @override
  Future<EitherString> call({bool cached = true}) async {
    final status = await service.isOnline;

    final online = status.fold((l) => false, (r) => r);

    return await repository.getRDM(cached: !online);
  }
}
