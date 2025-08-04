// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$realtimeInventoryHash() => r'fe95a6ecd83a4021e4c2b6119617d681d26555df';

/// 실시간 재고 현황 Provider
///
/// Copied from [RealtimeInventory].
@ProviderFor(RealtimeInventory)
final realtimeInventoryProvider =
    AutoDisposeNotifierProvider<
      RealtimeInventory,
      RealtimeInventoryState
    >.internal(
      RealtimeInventory.new,
      name: r'realtimeInventoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$realtimeInventoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RealtimeInventory = AutoDisposeNotifier<RealtimeInventoryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
