// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoOrderListHash() => r'31fc5b0c384bcbd336aca74db96d405d0b4486a6';

/// See also [DemoOrderList].
@ProviderFor(DemoOrderList)
final demoOrderListProvider =
    AutoDisposeNotifierProvider<DemoOrderList, DemoOrderListState>.internal(
  DemoOrderList.new,
  name: r'demoOrderListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$demoOrderListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DemoOrderList = AutoDisposeNotifier<DemoOrderListState>;
String _$demoOrderCreationHash() => r'a8bd9a77157c7842c0aaef3438a422ef53a25755';

/// See also [DemoOrderCreation].
@ProviderFor(DemoOrderCreation)
final demoOrderCreationProvider =
    AutoDisposeNotifierProvider<DemoOrderCreation, OrderCreationState>.internal(
  DemoOrderCreation.new,
  name: r'demoOrderCreationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$demoOrderCreationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DemoOrderCreation = AutoDisposeNotifier<OrderCreationState>;
String _$demoOrderDetailHash() => r'7dcab1fcdb0714dafdb1f9a15b6255483ac58f79';

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

abstract class _$DemoOrderDetail
    extends BuildlessAutoDisposeNotifier<DemoOrderDetailState> {
  late final String orderId;

  DemoOrderDetailState build(
    String orderId,
  );
}

/// See also [DemoOrderDetail].
@ProviderFor(DemoOrderDetail)
const demoOrderDetailProvider = DemoOrderDetailFamily();

/// See also [DemoOrderDetail].
class DemoOrderDetailFamily extends Family<DemoOrderDetailState> {
  /// See also [DemoOrderDetail].
  const DemoOrderDetailFamily();

  /// See also [DemoOrderDetail].
  DemoOrderDetailProvider call(
    String orderId,
  ) {
    return DemoOrderDetailProvider(
      orderId,
    );
  }

  @override
  DemoOrderDetailProvider getProviderOverride(
    covariant DemoOrderDetailProvider provider,
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
  String? get name => r'demoOrderDetailProvider';
}

/// See also [DemoOrderDetail].
class DemoOrderDetailProvider extends AutoDisposeNotifierProviderImpl<
    DemoOrderDetail, DemoOrderDetailState> {
  /// See also [DemoOrderDetail].
  DemoOrderDetailProvider(
    String orderId,
  ) : this._internal(
          () => DemoOrderDetail()..orderId = orderId,
          from: demoOrderDetailProvider,
          name: r'demoOrderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$demoOrderDetailHash,
          dependencies: DemoOrderDetailFamily._dependencies,
          allTransitiveDependencies:
              DemoOrderDetailFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  DemoOrderDetailProvider._internal(
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
  DemoOrderDetailState runNotifierBuild(
    covariant DemoOrderDetail notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(DemoOrderDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: DemoOrderDetailProvider._internal(
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
  AutoDisposeNotifierProviderElement<DemoOrderDetail, DemoOrderDetailState>
      createElement() {
    return _DemoOrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DemoOrderDetailProvider && other.orderId == orderId;
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
mixin DemoOrderDetailRef
    on AutoDisposeNotifierProviderRef<DemoOrderDetailState> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _DemoOrderDetailProviderElement
    extends AutoDisposeNotifierProviderElement<DemoOrderDetail,
        DemoOrderDetailState> with DemoOrderDetailRef {
  _DemoOrderDetailProviderElement(super.provider);

  @override
  String get orderId => (origin as DemoOrderDetailProvider).orderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
