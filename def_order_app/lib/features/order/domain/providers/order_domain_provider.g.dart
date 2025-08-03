// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_domain_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'419af326a9512fd663c963c39a61a7bfd7fb7afd';

/// Repository Provider
///
/// Copied from [orderRepository].
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
String _$getOrdersUseCaseHash() => r'4316e23ef21e010ace21ec42681b532877d5a329';

/// UseCase Providers
///
/// Copied from [getOrdersUseCase].
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
String _$createOrderUseCaseHash() =>
    r'aee8294c32f47125c03ce82f2042c0da2c91745d';

/// See also [createOrderUseCase].
@ProviderFor(createOrderUseCase)
final createOrderUseCaseProvider =
    AutoDisposeProvider<CreateOrderUseCase>.internal(
      createOrderUseCase,
      name: r'createOrderUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createOrderUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateOrderUseCaseRef = AutoDisposeProviderRef<CreateOrderUseCase>;
String _$updateOrderUseCaseHash() =>
    r'7f558792a3f1d0b53ae64645c4d936d745c0958b';

/// See also [updateOrderUseCase].
@ProviderFor(updateOrderUseCase)
final updateOrderUseCaseProvider =
    AutoDisposeProvider<UpdateOrderUseCase>.internal(
      updateOrderUseCase,
      name: r'updateOrderUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateOrderUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateOrderUseCaseRef = AutoDisposeProviderRef<UpdateOrderUseCase>;
String _$calculateOrderPriceUseCaseHash() =>
    r'45ab599e2fa2c772ad36be872889b4b8224a28fd';

/// See also [calculateOrderPriceUseCase].
@ProviderFor(calculateOrderPriceUseCase)
final calculateOrderPriceUseCaseProvider =
    AutoDisposeProvider<CalculateOrderPriceUseCase>.internal(
      calculateOrderPriceUseCase,
      name: r'calculateOrderPriceUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calculateOrderPriceUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculateOrderPriceUseCaseRef =
    AutoDisposeProviderRef<CalculateOrderPriceUseCase>;
String _$pendingOrderCountHash() => r'110bef283b12e146c8af70b5698244ca1a1b8baf';

/// Convenience Providers
///
/// Copied from [pendingOrderCount].
@ProviderFor(pendingOrderCount)
final pendingOrderCountProvider = AutoDisposeProvider<int>.internal(
  pendingOrderCount,
  name: r'pendingOrderCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingOrderCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingOrderCountRef = AutoDisposeProviderRef<int>;
String _$todayOrderCountHash() => r'65261b299a13286205b850bf816f06f2b78845e2';

/// See also [todayOrderCount].
@ProviderFor(todayOrderCount)
final todayOrderCountProvider = AutoDisposeProvider<int>.internal(
  todayOrderCount,
  name: r'todayOrderCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayOrderCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayOrderCountRef = AutoDisposeProviderRef<int>;
String _$orderCountByStatusHash() =>
    r'196425317ab3999b7b86be5a8ec45b70b1a86344';

/// See also [orderCountByStatus].
@ProviderFor(orderCountByStatus)
final orderCountByStatusProvider =
    AutoDisposeProvider<Map<OrderStatus, int>>.internal(
      orderCountByStatus,
      name: r'orderCountByStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderCountByStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderCountByStatusRef = AutoDisposeProviderRef<Map<OrderStatus, int>>;
String _$orderDomainHash() => r'92c738a59a5759315135b37f9e8f0c25b9d8ef41';

/// 주문 도메인 Provider
///
/// Copied from [OrderDomain].
@ProviderFor(OrderDomain)
final orderDomainProvider =
    AutoDisposeNotifierProvider<OrderDomain, OrderDomainState>.internal(
      OrderDomain.new,
      name: r'orderDomainProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderDomainHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrderDomain = AutoDisposeNotifier<OrderDomainState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
