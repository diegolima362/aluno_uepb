import 'dart:async';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class FpdartEitherAdapter<L, R> implements EitherAdapter<L, R> {
  final Either<L, R> usecase;
  FpdartEitherAdapter(this.usecase);

  @override
  T fold<T>(T Function(L l) leftF, T Function(R l) rightF) {
    return usecase.fold(leftF, rightF);
  }

  // Adapter Future Either(FpDart) to Future EitherAdapter(Triple)
  static Future<EitherAdapter<L, R>> adapter<L, R>(
      Future<Either<L, R>> usecase) {
    return usecase.then((value) => FpdartEitherAdapter(value));
  }

  // Adapter TaskEither to Triple
  static Future<EitherAdapter<L, R>> adapterTask<L, R>(
      TaskEither<L, R> usecase) {
    return usecase.run().then((value) => FpdartEitherAdapter(value));
  }
}
