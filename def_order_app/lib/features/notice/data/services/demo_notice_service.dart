import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/notice_model.dart';

final demoNoticeServiceProvider = Provider<DemoNoticeService>((ref) {
  return DemoNoticeService();
});

class DemoNoticeService {
  static const String _readNoticesKey = 'read_notices';
  static const String _demoInitKey = 'demo_notices_initialized';

  // 데모 초기화 (이미 읽은 상태로 설정할 공지사항들)
  static final List<String> _preReadNoticeIds = [
    'notice_urgent_002',  // 시스템 점검 완료 알림
    'notice_general_002', // 고객센터 운영시간 변경 완료
    'notice_general_003', // 추석 연휴 배송 일정 안내
  ];

  // 데모용 공지사항 데이터 (긴급공지 1개, 일반공지 1개 + 읽은 상태의 공지들)
  static final List<NoticeModel> _demoNotices = [
    // 읽지 않은 긴급공지 1개
    NoticeModel(
      id: 'notice_urgent_001',
      title: '🚨 긴급! 배송 지연 안내',
      content: '''안녕하세요. DEF 요소수입니다.

금일(${DateTime.now().month}/${DateTime.now().day}) 전국적인 교통상황 악화로 인해 일부 지역의 배송이 지연되고 있습니다.

**영향 지역:**
- 서울/경기 일부 지역: 1-2시간 지연
- 부산/경남 일부 지역: 2-3시간 지연

고객님께서는 주문 시 여유 시간을 두고 주문해주시기 바랍니다.
불편을 드려 죄송합니다.

문의사항: 1588-0000''',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isImportant: true,
      isActive: true,
      category: '배송',
      viewCount: 156,
      tags: ['긴급', '배송지연', '교통'],
      isPushSent: true,
      pushSentAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    // 읽지 않은 일반공지 1개
    NoticeModel(
      id: 'notice_general_001',
      title: '신규 배송지역 확대 안내',
      content: '''배송지역 확대 안내

고객님들의 많은 요청으로 배송 가능 지역을 확대했습니다.

**신규 추가 지역:**
- 강원도 원주, 춘천 일대
- 충청북도 청주, 충주 일대
- 전라북도 전주, 군산 일대

배송비는 기존과 동일하게 무료배송(5박스 이상 주문 시) 적용됩니다.

많은 이용 바랍니다.''',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isImportant: false,
      isActive: true,
      category: '배송',
      viewCount: 67,
      tags: ['배송', '지역확대', '무료배송'],
    ),
    // 읽은 상태로 표시될 긴급공지들 (데모용)
    NoticeModel(
      id: 'notice_urgent_002', 
      title: '🔥 시스템 긴급 점검 완료 알림',
      content: '''시스템 긴급 점검 완료 안내

**점검 일시:** ${DateTime.now().subtract(const Duration(days: 1)).month}/${DateTime.now().subtract(const Duration(days: 1)).day} 새벽 2:00 - 4:00

**점검 내용:**
- 주문 시스템 안정성 개선 ✅
- 결제 시스템 보안 업데이트 ✅
- 재고 관리 시스템 최적화 ✅

모든 점검이 성공적으로 완료되었습니다.
정상적으로 서비스 이용이 가능합니다.

감사합니다.''',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isImportant: true,
      isActive: true,
      category: '시스템',
      viewCount: 189,
      tags: ['긴급', '시스템점검', '완료'],
      isPushSent: true,
      pushSentAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NoticeModel(
      id: 'notice_general_002',
      title: '고객센터 운영시간 변경 완료',
      content: '''고객센터 운영시간 변경 완료 안내

고객센터 운영시간이 성공적으로 변경되었습니다.

**현재 운영시간:**
- 평일: 8:00-19:00
- 토요일: 9:00-13:00
- 일요일 및 공휴일: 휴무

더욱 향상된 서비스로 찾아뵙겠습니다.

감사합니다.''',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isImportant: false,
      isActive: true,
      category: '고객센터',
      viewCount: 95,
      tags: ['고객센터', '운영시간', '변경완료'],
    ),
    NoticeModel(
      id: 'notice_general_003',
      title: '추석 연휴 배송 일정 안내',
      content: '''추석 연휴 배송 일정 안내

추석 연휴 기간 중 배송 일정을 안내드립니다.

**연휴 기간:** 9/28(목) ~ 10/1(일)
**정상 배송:** 9/27(수)까지 주문 시
**배송 재개:** 10/2(월)부터

연휴 전 미리 주문해주시기 바랍니다.

즐거운 추석 연휴 보내세요!''',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isImportant: false,
      isActive: true,
      category: '배송',
      viewCount: 78,
      tags: ['추석', '연휴', '배송일정'],
    ),
  ];

  // 데모 초기화 (한 번만 실행)
  Future<void> _initializeDemoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isInitialized = prefs.getBool(_demoInitKey) ?? false;
      
      if (!isInitialized) {
        // 미리 읽은 상태로 설정할 공지사항들을 읽음 처리
        final readNotices = prefs.getStringList(_readNoticesKey) ?? [];
        for (final noticeId in _preReadNoticeIds) {
          if (!readNotices.contains(noticeId)) {
            readNotices.add(noticeId);
          }
        }
        await prefs.setStringList(_readNoticesKey, readNotices);
        await prefs.setBool(_demoInitKey, true);
        print('데모 공지사항 읽음 상태 초기화 완료');
      }
    } catch (e) {
      print('데모 공지사항 초기화 실패: $e');
    }
  }

  // 공지사항 목록 조회
  Future<List<NoticeModel>> getNotices({
    int? limit,
    int? offset,
    String? category,
    bool? isImportant,
  }) async {
    if (SupabaseConfig.isDemoMode) {
      // 데모 초기화 실행
      await _initializeDemoData();
      
      var notices = List<NoticeModel>.from(_demoNotices);
      
      // 카테고리 필터
      if (category != null) {
        notices = notices.where((notice) => notice.category == category).toList();
      }
      
      // 중요도 필터
      if (isImportant != null) {
        notices = notices.where((notice) => notice.isImportant == isImportant).toList();
      }
      
      // 중요도 우선, 최신순 정렬
      notices.sort((a, b) {
        if (a.isImportant != b.isImportant) {
          return b.isImportant ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      
      // 페이징 적용
      if (offset != null) {
        if (offset >= notices.length) return [];
        notices = notices.skip(offset).toList();
      }
      
      if (limit != null) {
        notices = notices.take(limit).toList();
      }
      
      return notices;
    }
    
    throw Exception('데모 모드에서만 사용 가능합니다');
  }

  // 공지사항 상세 조회
  Future<NoticeModel> getNoticeById(String id) async {
    if (SupabaseConfig.isDemoMode) {
      final notice = _demoNotices.firstWhere(
        (notice) => notice.id == id,
        orElse: () => throw ServerException(message: '공지사항을 찾을 수 없습니다'),
      );
      return notice;
    }
    
    throw Exception('데모 모드에서만 사용 가능합니다');
  }

  // 조회수 증가 (데모에서는 실제로 증가시키지 않음)
  Future<void> incrementViewCount(String id) async {
    if (SupabaseConfig.isDemoMode) {
      // 데모에서는 조회수 증가를 시뮬레이션만
      print('데모 모드: 조회수 증가 시뮬레이션 - $id');
      return;
    }
    
    throw Exception('데모 모드에서만 사용 가능합니다');
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
    if (SupabaseConfig.isDemoMode) {
      final categories = _demoNotices
          .where((notice) => notice.category != null)
          .map((notice) => notice.category!)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    }
    
    throw Exception('데모 모드에서만 사용 가능합니다');
  }

  // 검색
  Future<List<NoticeModel>> searchNotices(String query) async {
    if (SupabaseConfig.isDemoMode) {
      final lowerQuery = query.toLowerCase();
      final results = _demoNotices.where((notice) {
        return notice.title.toLowerCase().contains(lowerQuery) ||
               notice.content.toLowerCase().contains(lowerQuery);
      }).toList();
      
      // 중요도 우선, 최신순 정렬
      results.sort((a, b) {
        if (a.isImportant != b.isImportant) {
          return b.isImportant ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return results;
    }
    
    throw Exception('데모 모드에서만 사용 가능합니다');
  }

  // 캐시 정리
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_readNoticesKey);
      await prefs.remove(_demoInitKey); // 데모 초기화 상태도 리셋
    } catch (e) {
      throw CacheException(
        message: '캐시 정리에 실패했습니다',
      );
    }
  }

  // 데모 리셋 (읽지 않은 공지만 남기고 초기화)
  Future<void> resetDemoData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_readNoticesKey);
      await prefs.remove(_demoInitKey);
      // 다시 초기화
      await _initializeDemoData();
    } catch (e) {
      throw CacheException(
        message: '데모 데이터 리셋에 실패했습니다',
      );
    }
  }
}