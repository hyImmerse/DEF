// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderListHash() => r'3177c07b77bc03275060327ecb0d3076010bdae6';

/// See also [OrderList].
@ProviderFor(OrderList)
final orderListProvider =
    AutoDisposeNotifierProvider<OrderList, OrderListState>.internal(
  OrderList.new,
  name: r'orderListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderList = AutoDisposeNotifier<OrderListState>;
String _$orderDetailHash() => r'200c56e141d742bb699e547d4611a1bc05f34e05';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$OrderDetail
    extends BuildlessAutoDisposeNotifier<OrderDetailState> {
  late final String orderId;

  OrderDetailState build(
    String orderId,
  );
}

/// See also [OrderDetail].
@ProviderFor(OrderDetail)
const orderDetailProvider = OrderDetailFamily();

/// See also [OrderDetail].
class OrderDetailFamily extends Family<OrderDetailState> {
  /// See also [OrderDetail].
  const OrderDetailFamily();

  /// See also [OrderDetail].
  OrderDetailProvider call(
    String orderId,
  ) {
    return OrderDetailProvider(
      orderId,
    );
  }

  @override
  OrderDetailProvider getProviderOverride(
    covariant OrderDetailProvider provider,
  ) {
    return call(
      provider.orderId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailProvider';
}

/// See also [OrderDetail].
class OrderDetailProvider
    extends AutoDisposeNotifierProviderImpl<OrderDetail, OrderDetailState> {
  /// See also [OrderDetail].
  OrderDetailProvider(
    String orderId,
  ) : this._internal(
          () => OrderDetail()..orderId = orderId,
          from: orderDetailProvider,
          name: r'orderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderDetailHash,
          dependencies: OrderDetailFamily._dependencies,
          allTransitiveDependencies:
              OrderDetailFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  OrderDetailState runNotifierBuild(
    covariant OrderDetail notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(OrderDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<OrderDetail, OrderDetailState>
      createElement() {
    return _OrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailRef on AutoDisposeNotifierProviderRef<OrderDetailState> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailProviderElement
    extends AutoDisposeNotifierProviderElement<OrderDetail, OrderDetailState>
    with OrderDetailRef {
  _OrderDetailProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailProvider).orderId;
}

String _$orderCreationHash() => r'e3b08204a9bc7e1e7fd706a7d5f88436efda1bc7';

/// See also [OrderCreation].
@ProviderFor(OrderCreation)
final orderCreationProvider =
    AutoDisposeNotifierProvider<OrderCreation, OrderCreationState>.internal(
  OrderCreation.new,
  name: r'orderCreationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderCreationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderCreation = AutoDisposeNotifier<OrderCreationState>;
String _$orderStatsHash() => r'3ae1f0025080aca89e25a8d54e397f0f648e5b5e';

abstract class _$OrderStats
    extends BuildlessAutoDisposeNotifier<OrderStatsState> {
  late final DateTime? startDate;
  late final DateTime? endDate;

  OrderStatsState build({
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// See also [OrderStats].
@ProviderFor(OrderStats)
const orderStatsProvider = OrderStatsFamily();

/// See also [OrderStats].
class OrderStatsFamily extends Family<OrderStatsState> {
  /// See also [OrderStats].
  const OrderStatsFamily();

  /// See also [OrderStats].
  OrderStatsProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return OrderStatsProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  OrderStatsProvider getProviderOverride(
    covariant OrderStatsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderStatsProvider';
}

/// See also [OrderStats].
class OrderStatsProvider
    extends AutoDisposeNotifierProviderImpl<OrderStats, OrderStatsState> {
  /// See also [OrderStats].
  OrderStatsProvider({
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          () => OrderStats()
            ..startDate = startDate
            ..endDate = endDate,
          from: orderStatsProvider,
          name: r'orderStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderStatsHash,
          dependencies: OrderStatsFamily._dependencies,
          allTransitiveDependencies:
              OrderStatsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  OrderStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  OrderStatsState runNotifierBuild(
    covariant OrderStats notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(OrderStats Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderStatsProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<OrderStats, OrderStatsState>
      createElement() {
    return _OrderStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderStatsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderStatsRef on AutoDisposeNotifierProviderRef<OrderStatsState> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _OrderStatsProviderElement
    extends AutoDisposeNotifierProviderElement<OrderStats, OrderStatsState>
    with OrderStatsRef {
  _OrderStatsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as OrderStatsProvider).startDate;
  @override
  DateTime? get endDate => (origin as OrderStatsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
