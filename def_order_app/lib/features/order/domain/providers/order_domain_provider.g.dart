// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_domain_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderServiceHash() => r'1f7289b625a710b5f100a6806b245c7ade4fae4e';

/// Service Provider
///
/// Copied from [orderService].
@ProviderFor(orderService)
final orderServiceProvider = AutoDisposeProvider<OrderService>.internal(
  orderService,
  name: r'orderServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderServiceRef = AutoDisposeProviderRef<OrderService>;
String _$orderRepositoryHash() => r'8d0e3577f88b20edd65677824b8de9fdec82342e';

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
String _$pendingOrderCountHash() => r'9dc31089efc98280a0a981a4dd6fe73559b7b92e';

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
String _$todayOrderCountHash() => r'a8584eea34afc97d081e2f3907c65dad394200e8';

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
    r'a13c7c9b0d8168cea995784c16d735a50909f507';

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
String _$pdfServiceHash() => r'785b5b69cd0954ccb95c4fe8aa8f89e09fd0674d';

/// PDF 및 이메일 관련 Providers
///
/// Copied from [pdfService].
@ProviderFor(pdfService)
final pdfServiceProvider = AutoDisposeProvider<PdfService>.internal(
  pdfService,
  name: r'pdfServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pdfServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PdfServiceRef = AutoDisposeProviderRef<PdfService>;
String _$storageServiceHash() => r'b9eb09cfea0c265efa80435bdffda55cb5e6d8ba';

/// See also [storageService].
@ProviderFor(storageService)
final storageServiceProvider = AutoDisposeProvider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = AutoDisposeProviderRef<StorageService>;
String _$emailServiceHash() => r'a65b8f50c12f5e084735a159dee55c6ac729cc1c';

/// See also [emailService].
@ProviderFor(emailService)
final emailServiceProvider = AutoDisposeProvider<EmailService>.internal(
  emailService,
  name: r'emailServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emailServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmailServiceRef = AutoDisposeProviderRef<EmailService>;
String _$generatePdfUseCaseHash() =>
    r'3437a301125fdcf805cb744ae55c44eea28d8596';

/// See also [generatePdfUseCase].
@ProviderFor(generatePdfUseCase)
final generatePdfUseCaseProvider =
    AutoDisposeProvider<GeneratePdfUseCase>.internal(
      generatePdfUseCase,
      name: r'generatePdfUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generatePdfUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeneratePdfUseCaseRef = AutoDisposeProviderRef<GeneratePdfUseCase>;
String _$sendEmailUseCaseHash() => r'0c242ee3860df98f5519147c6cf04f6561fd7e1b';

/// See also [sendEmailUseCase].
@ProviderFor(sendEmailUseCase)
final sendEmailUseCaseProvider = AutoDisposeProvider<SendEmailUseCase>.internal(
  sendEmailUseCase,
  name: r'sendEmailUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sendEmailUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SendEmailUseCaseRef = AutoDisposeProviderRef<SendEmailUseCase>;
String _$processTransactionStatementUseCaseHash() =>
    r'1132c68ebe2da59344743c448849861591a0565f';

/// See also [processTransactionStatementUseCase].
@ProviderFor(processTransactionStatementUseCase)
final processTransactionStatementUseCaseProvider =
    AutoDisposeProvider<ProcessTransactionStatementUseCase>.internal(
      processTransactionStatementUseCase,
      name: r'processTransactionStatementUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$processTransactionStatementUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessTransactionStatementUseCaseRef =
    AutoDisposeProviderRef<ProcessTransactionStatementUseCase>;
String _$orderDomainHash() => r'4efc14fb82b1c2a03178d431a5178f76542ccbab';

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
