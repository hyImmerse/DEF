import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/error/exceptions.dart';
import '../models/notice_model.dart';

final noticeServiceProvider = Provider<NoticeService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return NoticeService(supabaseService);
});

class NoticeService {
  final SupabaseService _supabaseService;
  static const String _readNoticesKey = 'read_notices';

  NoticeService(this._supabaseService);

  // 공지사항 목록 조회
  Future<List<NoticeModel>> getNotices({
    int? limit,
    int? offset,
    String? category,
    bool? isImportant,
  }) async {
    try {
      var query = _supabaseService.client
          .from('notices')
          .select()
          .eq('is_active', true);

      if (category != null) {
        query = query.eq('category', category);
      }

      if (isImportant != null) {
        query = query.eq('is_important', isImportant);
      }

      // 정렬 및 페이징 (마지막에 적용)
      var finalQuery = query
          .order('is_important', ascending: false)
          .order('created_at', ascending: false);
          
      if (offset != null && limit != null) {
        finalQuery = finalQuery.range(offset, offset + limit - 1);
      } else if (limit != null) {
        finalQuery = finalQuery.limit(limit);
      }

      final response = await finalQuery;
      
      return (response as List)
          .map((json) => NoticeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(
        message: '공지사항 목록을 불러올 수 없습니다',
      );
    }
  }

  // 공지사항 상세 조회
  Future<NoticeModel> getNoticeById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('notices')
          .select()
          .eq('id', id)
          .single();

      return NoticeModel.fromJson(response);
    } catch (e) {
      throw ServerException(
        message: '공지사항을 불러올 수 없습니다',
      );
    }
  }

  // 조회수 증가
  Future<void> incrementViewCount(String id) async {
    try {
      await _supabaseService.client.rpc(
        'increment_notice_view_count',
        params: {'notice_id': id},
      );
    } catch (e) {
      // 조회수 증가 실패는 무시
      print('Failed to increment view count: $e');
    }
  }

  // 읽음 상태 저장 (로컬)
  Future<void> markAsRead(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readNotices = prefs.getStringList(_readNoticesKey) ?? [];
      
      if (!readNotices.contains(id)) {
        readNotices.add(id);
        await prefs.setStringList(_readNoticesKey, readNotices);
      }
    } catch (e) {
      throw CacheException(
        message: '읽음 상태 저장에 실패했습니다',
      );
    }
  }

  // 읽음 상태 목록 조회 (로컬)
  Future<List<String>> getReadNoticeIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_readNoticesKey) ?? [];
    } catch (e) {
      throw CacheException(
        message: '읽음 상태를 불러올 수 없습니다',
      );
    }
  }

  // 카테고리 목록 조회
  Future<List<String>> getCategories() async {
    try {
      final response = await _supabaseService.client
          .from('notices')
          .select('category')
          .not('category', 'is', null)
          .order('category');

      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();

      return categories;
    } catch (e) {
      throw ServerException(
        message: '카테고리 목록을 불러올 수 없습니다',
      );
    }
  }

  // 검색
  Future<List<NoticeModel>> searchNotices(String query) async {
    try {
      final response = await _supabaseService.client
          .from('notices')
          .select()
          .eq('is_active', true)
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('is_important', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NoticeModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(
        message: '공지사항 검색에 실패했습니다',
      );
    }
  }

  // 캐시 정리
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_readNoticesKey);
    } catch (e) {
      throw CacheException(
        message: '캐시 정리에 실패했습니다',
      );
    }
  }
}