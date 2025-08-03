import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../services/notice_service.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final noticeService = ref.watch(noticeServiceProvider);
  return NoticeRepositoryImpl(noticeService);
});

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeService _noticeService;

  NoticeRepositoryImpl(this._noticeService);

  @override
  Future<Either<Failure, List<NoticeEntity>>> getNotices({
    int? limit,
    int? offset,
    String? category,
    bool? isImportant,
  }) async {
    try {
      final models = await _noticeService.getNotices(
        limit: limit,
        offset: offset,
        category: category,
        isImportant: isImportant,
      );

      // 읽음 상태 가져오기
      final readIds = await _noticeService.getReadNoticeIds();
      
      final entities = models.map((model) => model.toEntity(
        isRead: readIds.contains(model.id),
      )).toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> getNoticeById(String id) async {
    try {
      final model = await _noticeService.getNoticeById(id);
      final readIds = await _noticeService.getReadNoticeIds();
      
      final entity = model.toEntity(
        isRead: readIds.contains(model.id),
      );

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '알 수 없는 오류가 발생했습니다'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementViewCount(String id) async {
    try {
      await _noticeService.incrementViewCount(id);
      return const Right(null);
    } catch (e) {
      // 조회수 증가 실패는 무시하고 성공으로 처리
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _noticeService.markAsRead(id);
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
      final ids = await _noticeService.getReadNoticeIds();
      return Right(ids);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '읽음 상태를 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, NoticeEntity>> getNoticeFromPush(String noticeId) async {
    try {
      final model = await _noticeService.getNoticeById(noticeId);
      final readIds = await _noticeService.getReadNoticeIds();
      
      final entity = model.toEntity(
        isRead: readIds.contains(model.id),
      );

      // 푸시로 온 공지사항은 자동으로 읽음 처리
      await markAsRead(noticeId);

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '공지사항을 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _noticeService.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '카테고리 목록을 불러올 수 없습니다'));
    }
  }

  @override
  Future<Either<Failure, List<NoticeEntity>>> searchNotices(String query) async {
    try {
      final models = await _noticeService.searchNotices(query);
      final readIds = await _noticeService.getReadNoticeIds();
      
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
      await _noticeService.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '캐시 정리에 실패했습니다'));
    }
  }
}