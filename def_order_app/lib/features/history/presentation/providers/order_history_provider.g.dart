// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderHistoryHash() => r'0fd19972e37ab1199e20bd37e1284f677912c705';

/// 주문 내역 Provider
///
/// Copied from [OrderHistory].
@ProviderFor(OrderHistory)
final orderHistoryProvider =
    AutoDisposeNotifierProvider<OrderHistory, OrderHistoryState>.internal(
  OrderHistory.new,
  name: r'orderHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$orderHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderHistory = AutoDisposeNotifier<OrderHistoryState>;
String _$transactionStatementHash() =>
    r'730fe27831cb9a63c4aa303199c3298572f65bed';

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

abstract class _$TransactionStatement
    extends BuildlessAutoDisposeNotifier<AsyncValue<String?>> {
  late final String orderId;

  AsyncValue<String?> build(
    String orderId,
  );
}

/// 거래명세서 Provider
///
/// Copied from [TransactionStatement].
@ProviderFor(TransactionStatement)
const transactionStatementProvider = TransactionStatementFamily();

/// 거래명세서 Provider
///
/// Copied from [TransactionStatement].
class TransactionStatementFamily extends Family<AsyncValue<String?>> {
  /// 거래명세서 Provider
  ///
  /// Copied from [TransactionStatement].
  const TransactionStatementFamily();

  /// 거래명세서 Provider
  ///
  /// Copied from [TransactionStatement].
  TransactionStatementProvider call(
    String orderId,
  ) {
    return TransactionStatementProvider(
      orderId,
    );
  }

  @override
  TransactionStatementProvider getProviderOverride(
    covariant TransactionStatementProvider provider,
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
  String? get name => r'transactionStatementProvider';
}

/// 거래명세서 Provider
///
/// Copied from [TransactionStatement].
class TransactionStatementProvider extends AutoDisposeNotifierProviderImpl<
    TransactionStatement, AsyncValue<String?>> {
  /// 거래명세서 Provider
  ///
  /// Copied from [TransactionStatement].
  TransactionStatementProvider(
    String orderId,
  ) : this._internal(
          () => TransactionStatement()..orderId = orderId,
          from: transactionStatementProvider,
          name: r'transactionStatementProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionStatementHash,
          dependencies: TransactionStatementFamily._dependencies,
          allTransitiveDependencies:
              TransactionStatementFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  TransactionStatementProvider._internal(
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
  AsyncValue<String?> runNotifierBuild(
    covariant TransactionStatement notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(TransactionStatement Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionStatementProvider._internal(
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
  AutoDisposeNotifierProviderElement<TransactionStatement, AsyncValue<String?>>
      createElement() {
    return _TransactionStatementProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionStatementProvider && other.orderId == orderId;
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
mixin TransactionStatementRef
    on AutoDisposeNotifierProviderRef<AsyncValue<String?>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _TransactionStatementProviderElement
    extends AutoDisposeNotifierProviderElement<TransactionStatement,
        AsyncValue<String?>> with TransactionStatementRef {
  _TransactionStatementProviderElement(super.provider);

  @override
  String get orderId => (origin as TransactionStatementProvider).orderId;
}

String _$excelDownloadHash() => r'3ee3a3022b286d33fdec8212d51a439a26868b45';

/// Excel 다운로드 Provider
///
/// Copied from [ExcelDownload].
@ProviderFor(ExcelDownload)
final excelDownloadProvider =
    AutoDisposeNotifierProvider<ExcelDownload, AsyncValue<String?>>.internal(
  ExcelDownload.new,
  name: r'excelDownloadProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$excelDownloadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExcelDownload = AutoDisposeNotifier<AsyncValue<String?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
