// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_validation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$formatBusinessNumberHash() =>
    r'eab3e8d1f19d7c6f295914578cdc0965113529de';

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

/// See also [formatBusinessNumber].
@ProviderFor(formatBusinessNumber)
const formatBusinessNumberProvider = FormatBusinessNumberFamily();

/// See also [formatBusinessNumber].
class FormatBusinessNumberFamily extends Family<String> {
  /// See also [formatBusinessNumber].
  const FormatBusinessNumberFamily();

  /// See also [formatBusinessNumber].
  FormatBusinessNumberProvider call(String input) {
    return FormatBusinessNumberProvider(input);
  }

  @override
  FormatBusinessNumberProvider getProviderOverride(
    covariant FormatBusinessNumberProvider provider,
  ) {
    return call(provider.input);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'formatBusinessNumberProvider';
}

/// See also [formatBusinessNumber].
class FormatBusinessNumberProvider extends AutoDisposeProvider<String> {
  /// See also [formatBusinessNumber].
  FormatBusinessNumberProvider(String input)
    : this._internal(
        (ref) => formatBusinessNumber(ref as FormatBusinessNumberRef, input),
        from: formatBusinessNumberProvider,
        name: r'formatBusinessNumberProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$formatBusinessNumberHash,
        dependencies: FormatBusinessNumberFamily._dependencies,
        allTransitiveDependencies:
            FormatBusinessNumberFamily._allTransitiveDependencies,
        input: input,
      );

  FormatBusinessNumberProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.input,
  }) : super.internal();

  final String input;

  @override
  Override overrideWith(
    String Function(FormatBusinessNumberRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FormatBusinessNumberProvider._internal(
        (ref) => create(ref as FormatBusinessNumberRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        input: input,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _FormatBusinessNumberProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FormatBusinessNumberProvider && other.input == input;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, input.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FormatBusinessNumberRef on AutoDisposeProviderRef<String> {
  /// The parameter `input` of this provider.
  String get input;
}

class _FormatBusinessNumberProviderElement
    extends AutoDisposeProviderElement<String>
    with FormatBusinessNumberRef {
  _FormatBusinessNumberProviderElement(super.provider);

  @override
  String get input => (origin as FormatBusinessNumberProvider).input;
}

String _$businessValidationHash() =>
    r'35dcf86105a2f56e80f8b52067c53b80d81cb38e';

/// See also [BusinessValidation].
@ProviderFor(BusinessValidation)
final businessValidationProvider =
    AutoDisposeNotifierProvider<
      BusinessValidation,
      BusinessValidationState
    >.internal(
      BusinessValidation.new,
      name: r'businessValidationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$businessValidationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BusinessValidation = AutoDisposeNotifier<BusinessValidationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
