import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../services/demo_notice_service.dart';

final demoNoticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final demoNoticeService = ref.watch(demoNoticeServiceProvider);
  return DemoNoticeRepositoryImpl(demoNoticeService);
});

class DemoNoticeRepositoryImpl implements NoticeRepository {
  final DemoNoticeService _demoNoticeService;

  DemoNoticeRepositoryImpl(this._demoNoticeService);

  @override
  Future<Either<Failure, List<NoticeEntity>>> getNotices({
    int? limit,
    int? offset,
    String? category,
    bool? isImportant,
  }) async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      final models = await _demoNoticeService.getNotices(
        limit: limit,
        offset: offset,
        category: category,
        isImportant: isImportant,
      );

      // 읽음 상태 가져오기
      final readIds = await _demoNoticeService.getReadNoticeIds();
      
      final entities = models.map((model) => model.toEntity(
        isRead: readIds.contains(model.id),
      )).toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '데모 데이터 로드 중 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> getNoticeById(String id) async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      final model = await _demoNoticeService.getNoticeById(id);
      final readIds = await _demoNoticeService.getReadNoticeIds();
      
      final entity = model.toEntity(
        isRead: readIds.contains(model.id),
      );

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '데모 공지사항을 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementViewCount(String id) async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      await _demoNoticeService.incrementViewCount(id);
      return const Right(null);
    } catch (e) {
      // 조회수 증가 실패는 무시하고 성공으로 처리
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _demoNoticeService.markAsRead(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '읽음 상태 저장에 실패했습니다'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getReadNoticeIds() async {
    try {
      final ids = await _demoNoticeService.getReadNoticeIds();
      return Right(ids);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '읽음 상태를 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> getNoticeFromPush(String noticeId) async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      final model = await _demoNoticeService.getNoticeById(noticeId);
      final readIds = await _demoNoticeService.getReadNoticeIds();
      
      final entity = model.toEntity(
        isRead: readIds.contains(model.id),
      );

      // 푸시로 온 공지사항은 자동으로 읽음 처리
      await markAsRead(noticeId);

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '푸시 공지사항을 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      final categories = await _demoNoticeService.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '카테고리 목록을 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, List<NoticeEntity>>> searchNotices(String query) async {
    if (!SupabaseConfig.isDemoMode) {
      return Left(ServerFailure(message: '데모 모드에서만 사용 가능합니다'));
    }
    
    try {
      final models = await _demoNoticeService.searchNotices(query);
      final readIds = await _demoNoticeService.getReadNoticeIds();
      
      final entities = models.map((model) => model.toEntity(
        isRead: readIds.contains(model.id),
      )).toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '검색에 실패했습니다'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _demoNoticeService.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '캐시 정리에 실패했습니다'));
    }
  }
}