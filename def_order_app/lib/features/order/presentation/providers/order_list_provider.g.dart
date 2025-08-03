// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'216a73f8cae891489684a8873aeffd2ac9418c4a';

/// See also [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = AutoDisposeProvider<OrderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderRepositoryRef = AutoDisposeProviderRef<OrderRepository>;
String _$getOrdersUseCaseHash() => r'85ddbfcfa772deb04dd1a9decbd6b9d464ef129e';

/// See also [getOrdersUseCase].
@ProviderFor(getOrdersUseCase)
final getOrdersUseCaseProvider = AutoDisposeProvider<GetOrdersUseCase>.internal(
  getOrdersUseCase,
  name: r'getOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrdersUseCaseRef = AutoDisposeProviderRef<GetOrdersUseCase>;
String _$pendingOrdersHash() => r'4d8809a8062bbfeb2c22e0e75a755206e263a0f2';

/// See also [pendingOrders].
@ProviderFor(pendingOrders)
final pendingOrdersProvider =
    AutoDisposeFutureProvider<List<OrderEntity>>.internal(
      pendingOrders,
      name: r'pendingOrdersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingOrdersRef = AutoDisposeFutureProviderRef<List<OrderEntity>>;
String _$urgentOrdersHash() => r'4b45ad9c2a90b62914f08d73d0ae88fb5d07d8f0';

/// See also [urgentOrders].
@ProviderFor(urgentOrders)
final urgentOrdersProvider =
    AutoDisposeFutureProvider<List<OrderEntity>>.internal(
      urgentOrders,
      name: r'urgentOrdersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$urgentOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UrgentOrdersRef = AutoDisposeFutureProviderRef<List<OrderEntity>>;
String _$overdueOrdersHash() => r'9976d099a28ea203e1ae03b90abe78b1d7e6ba9b';

/// See also [overdueOrders].
@ProviderFor(overdueOrders)
final overdueOrdersProvider =
    AutoDisposeFutureProvider<List<OrderEntity>>.internal(
      overdueOrders,
      name: r'overdueOrdersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$overdueOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueOrdersRef = AutoDisposeFutureProviderRef<List<OrderEntity>>;
String _$orderListHash() => r'5dfba11b92b49e6598aac36fa6823f431296d418';

/// 주문 목록 노티파이어
///
/// 주문 목록의 상태를 관리하고 비즈니스 로직을 처리합니다.
/// Clean Architecture 패턴에 따라 UseCase를 통해 도메인 로직을 실행합니다.
///
/// Copied from [OrderList].
@ProviderFor(OrderList)
final orderListProvider =
    AutoDisposeNotifierProvider<OrderList, OrderListState>.internal(
      OrderList.new,
      name: r'orderListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrderList = AutoDisposeNotifier<OrderListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
