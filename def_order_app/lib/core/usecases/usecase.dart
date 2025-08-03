import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// UseCase 인터페이스
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 파라미터가 없는 UseCase를 위한 클래스
class NoParams {
  const NoParams();
}