// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthenticatedHash() => r'ca9b0f3fafdf6ac70093d5f3b7b08df75f75912c';

/// See also [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentProfileHash() => r'c58fe9ae42fe7a3837d73d2e48647d3754aea85f';

/// See also [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeProvider<ProfileModel?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentProfileRef = AutoDisposeProviderRef<ProfileModel?>;
String _$isDealerHash() => r'8a9c327e3c3ec53bb7c04b911a32d92bad7d6af3';

/// See also [isDealer].
@ProviderFor(isDealer)
final isDealerProvider = AutoDisposeProvider<bool>.internal(
  isDealer,
  name: r'isDealerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDealerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDealerRef = AutoDisposeProviderRef<bool>;
String _$isApprovedUserHash() => r'86c876114dcabad69a07f809476e0ba8f6a8f1ca';

/// See also [isApprovedUser].
@ProviderFor(isApprovedUser)
final isApprovedUserProvider = AutoDisposeProvider<bool>.internal(
  isApprovedUser,
  name: r'isApprovedUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isApprovedUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsApprovedUserRef = AutoDisposeProviderRef<bool>;
String _$authHash() => r'81a506d6ddab586632fc2750f34e405b08d90252';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = NotifierProvider<Auth, AuthState>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = Notifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
