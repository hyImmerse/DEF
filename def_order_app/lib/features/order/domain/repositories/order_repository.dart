import '../entities/order_entity.dart';
import '../../data/models/order_model.dart';

/// 주문 저장소 인터페이스
/// 
/// 주문 도메인의 데이터 액세스를 정의하는 추상 인터페이스입니다.
/// Clean Architecture 원칙에 따라 도메인 레이어에서 데이터 레이어의 구현을 의존하지 않습니다.
abstract class OrderRepository {
  /// 주문 목록 조회
  /// 
  /// 필터링 및 페이징을 지원하여 사용자의 주문 목록을 조회합니다.
  /// 
  /// [limit] 조회할 최대 주문 수 (기본값: 20)
  /// [offset] 건너뛸 주문 수 (페이징용, 기본값: 0)
  /// [status] 주문 상태 필터
  /// [productType] 제품 타입 필터 (박스/벌크)
  /// [deliveryMethod] 배송 방법 필터
  /// [startDate] 조회 시작 날짜
  /// [endDate] 조회 종료 날짜
  /// [searchQuery] 검색어 (주문번호, 메모 등)
  /// 
  /// Returns: [OrderEntity] 리스트
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<List<OrderEntity>> getOrders({
    int? limit,
    int? offset,
    OrderStatus? status,
    ProductType? productType,
    DeliveryMethod? deliveryMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  });

  /// 주문 상세 조회
  /// 
  /// 주문 ID로 특정 주문의 상세 정보를 조회합니다.
  /// 사용자 프로필과 배송 주소 정보도 함께 조회됩니다.
  /// 
  /// [orderId] 조회할 주문 ID
  /// 
  /// Returns: [OrderEntity] 또는 null (주문이 존재하지 않는 경우)
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<OrderEntity?> getOrderById(String orderId);

  /// 새 주문 생성
  /// 
  /// 새로운 주문을 생성합니다. 
  /// 주문번호는 자동으로 생성되며, 상태는 draft로 설정됩니다.
  /// 
  /// [productType] 제품 타입 (박스/벌크)
  /// [quantity] 주문 수량
  /// [javaraQuantity] 자바라 수량 (선택사항)
  /// [returnTankQuantity] 반납통 수량 (선택사항)
  /// [deliveryDate] 배송 희망일
  /// [deliveryMethod] 배송 방법
  /// [deliveryAddressId] 배송 주소 ID (배송인 경우 필수)
  /// [deliveryMemo] 배송 메모
  /// [unitPrice] 단가
  /// 
  /// Returns: 생성된 [OrderEntity]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  /// Throws: [ValidationException] 유효성 검사 실패 시
  Future<OrderEntity> createOrder({
    required ProductType productType,
    required int quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    required DateTime deliveryDate,
    required DeliveryMethod deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    required double unitPrice,
  });

  /// 주문 수정
  /// 
  /// 기존 주문의 정보를 수정합니다.
  /// 수정 가능한 상태(draft, pending)인 주문만 수정할 수 있습니다.
  /// 
  /// [orderId] 수정할 주문 ID
  /// [productType] 제품 타입
  /// [quantity] 주문 수량
  /// [javaraQuantity] 자바라 수량
  /// [returnTankQuantity] 반납통 수량
  /// [deliveryDate] 배송 희망일
  /// [deliveryMethod] 배송 방법
  /// [deliveryAddressId] 배송 주소 ID
  /// [deliveryMemo] 배송 메모
  /// [unitPrice] 단가
  /// 
  /// Returns: 수정된 [OrderEntity]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  /// Throws: [ValidationException] 유효성 검사 실패 시
  /// Throws: [BusinessRuleException] 비즈니스 규칙 위반 시
  Future<OrderEntity> updateOrder({
    required String orderId,
    ProductType? productType,
    int? quantity,
    int? javaraQuantity,
    int? returnTankQuantity,
    DateTime? deliveryDate,
    DeliveryMethod? deliveryMethod,
    String? deliveryAddressId,
    String? deliveryMemo,
    double? unitPrice,
  });

  /// 주문 상태 변경
  /// 
  /// 주문의 상태를 변경합니다.
  /// 비즈니스 규칙에 따라 유효한 상태 전환만 허용됩니다.
  /// 
  /// [orderId] 대상 주문 ID
  /// [status] 변경할 상태
  /// [cancelledReason] 취소 사유 (상태가 cancelled인 경우 필수)
  /// 
  /// Returns: 상태가 변경된 [OrderEntity]
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  /// Throws: [BusinessRuleException] 비즈니스 규칙 위반 시
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
    String? cancelledReason,
  });

  /// 주문 삭제
  /// 
  /// 주문을 삭제합니다.
  /// 일반적으로 draft 상태의 주문만 삭제 가능합니다.
  /// 
  /// [orderId] 삭제할 주문 ID
  /// 
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  /// Throws: [BusinessRuleException] 비즈니스 규칙 위반 시
  Future<void> deleteOrder(String orderId);

  /// 주문 통계 조회
  /// 
  /// 지정된 기간의 주문 통계를 조회합니다.
  /// 총 주문 수, 총 금액, 총 수량, 상태별 개수 등을 반환합니다.
  /// 
  /// [startDate] 통계 시작 날짜
  /// [endDate] 통계 종료 날짜
  /// 
  /// Returns: 통계 정보가 담긴 Map
  /// - total_orders: 총 주문 수
  /// - total_amount: 총 주문 금액
  /// - total_quantity: 총 주문 수량
  /// - status_count: 상태별 주문 개수
  /// 
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<Map<String, dynamic>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// 재고 확인
  /// 
  /// 주문하려는 제품의 재고 상황을 확인합니다.
  /// 박스/벌크별로 재고를 체크하여 주문 가능 여부를 판단합니다.
  /// 
  /// [productType] 제품 타입 (박스/벌크)
  /// [quantity] 주문 수량
  /// 
  /// Returns: 재고 정보가 담긴 Map
  /// - available: 재고 가능 여부
  /// - currentStock: 현재 재고 수량
  /// - reservedStock: 예약된 재고 수량
  /// - availableStock: 주문 가능한 재고 수량
  /// 
  /// Throws: [ServerException] 서버 오류 시
  Future<Map<String, dynamic>> checkInventory({
    required ProductType productType,
    required int quantity,
  });

  /// 사용자별 단가 조회
  /// 
  /// 현재 로그인한 사용자의 등급에 따른 단가를 조회합니다.
  /// 대리점, 일반 거래처 등 등급별로 차등 적용된 단가를 반환합니다.
  /// 
  /// [productType] 제품 타입 (박스/벌크)
  /// 
  /// Returns: 단가 정보가 담긴 Map
  /// - unitPrice: 사용자 등급별 단가
  /// - grade: 사용자 등급
  /// - discountRate: 할인율 (기본 단가 대비)
  /// 
  /// Throws: [ServerException] 서버 오류 시
  /// Throws: [AuthException] 인증 오류 시
  Future<Map<String, dynamic>> getUserUnitPrice({
    required ProductType productType,
  });
}