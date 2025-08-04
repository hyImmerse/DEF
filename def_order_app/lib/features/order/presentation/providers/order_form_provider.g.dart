// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createOrderUseCaseHash() =>
    r'a1c7acef69597a6882cd522de1f6837807b710c8';

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
    r'4f9da1f247d160fda24691b056c3cf1e96bef1f5';

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
String _$calculatePriceUseCaseHash() =>
    r'55cf937d1e3344fef1b9a0fd70ef229f62475f26';

/// See also [calculatePriceUseCase].
@ProviderFor(calculatePriceUseCase)
final calculatePriceUseCaseProvider =
    AutoDisposeProvider<CalculatePriceUseCase>.internal(
  calculatePriceUseCase,
  name: r'calculatePriceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calculatePriceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculatePriceUseCaseRef
    = AutoDisposeProviderRef<CalculatePriceUseCase>;
String _$checkInventoryUseCaseHash() =>
    r'69a8f7fc14dc7f4c11e9c9e13ea293cabad451f6';

/// See also [checkInventoryUseCase].
@ProviderFor(checkInventoryUseCase)
final checkInventoryUseCaseProvider =
    AutoDisposeProvider<CheckInventoryUseCase>.internal(
  checkInventoryUseCase,
  name: r'checkInventoryUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkInventoryUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckInventoryUseCaseRef
    = AutoDisposeProviderRef<CheckInventoryUseCase>;
String _$orderFormHash() => r'7c9818cecf2f8595d55209d98c5a4f59cb44eeca';

/// 주문 폼 노티파이어
///
/// 주문 생성/수정 폼의 상태를 관리하고 비즈니스 로직을 처리합니다.
/// UseCase를 통해 도메인 로직을 실행하고 실시간 유효성 검사를 제공합니다.
///
/// Copied from [OrderForm].
@ProviderFor(OrderForm)
final orderFormProvider =
    AutoDisposeNotifierProvider<OrderForm, OrderFormState>.internal(
  OrderForm.new,
  name: r'orderFormProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderFormHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderForm = AutoDisposeNotifier<OrderFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
