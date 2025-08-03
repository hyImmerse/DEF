import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notice_entity.dart';

abstract class NoticeRepository {
  // 공지사항 목록 조회
  Future<Either<Failure, List<NoticeEntity>>> getNotices({
    int? limit,
    int? offset,
    String? category,
    bool? isImportant,
  });

  // 공지사항 상세 조회
  Future<Either<Failure, NoticeEntity>> getNoticeById(String id);

  // 조회수 증가
  Future<Either<Failure, void>> incrementViewCount(String id);

  // 읽음 상태 업데이트 (로컬 저장소)
  Future<Either<Failure, void>> markAsRead(String id);

  // 읽음 상태 목록 조회 (로컬 저장소)
  Future<Either<Failure, List<String>>> getReadNoticeIds();

  // 푸시 알림으로 받은 공지사항 처리
  Future<Either<Failure, NoticeEntity>> getNoticeFromPush(String noticeId);

  // 카테고리 목록 조회
  Future<Either<Failure, List<String>>> getCategories();

  // 검색
  Future<Either<Failure, List<NoticeEntity>>> searchNotices(String query);

  // 캐시 정리
  Future<Either<Failure, void>> clearCache();
}