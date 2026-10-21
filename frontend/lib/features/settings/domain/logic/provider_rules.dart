import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

const kProviderCreatePermission = 'payment_provider.create';
const kProviderUpdatePermission = 'payment_provider.update';
const kProviderDeletePermission = 'payment_provider.delete';

enum ProviderStatus {
  /// Built in: always active, never deleted.
  system,
  active,
  inactive,
}

ProviderStatus providerStatusOf(AdminPaymentProvider provider) =>
    provider.isSystem
    ? .system
    : provider.isActive
    ? .active
    : .inactive;

String aliasSummary(AdminPaymentProvider provider) =>
    provider.aliases.join(', ');

bool providerMatches(AdminPaymentProvider provider, String query) {
  final needle = query.trim().toLowerCase();
  return needle.isEmpty ||
      provider.name.toLowerCase().contains(needle) ||
      provider.slug.toLowerCase().contains(needle) ||
      provider.aliases.any((a) => a.toLowerCase().contains(needle));
}

List<AdminPaymentProvider> filterProviders(
  List<AdminPaymentProvider> providers,
  String query,
) => providers.where((p) => providerMatches(p, query)).toList();

bool canCreateProviders(User? user) =>
    user?.hasPermission(kProviderCreatePermission) ?? false;

bool canEditProviders(User? user) =>
    user != null &&
    (user.hasPermission(kProviderUpdatePermission) ||
        user.hasPermission(kProviderDeletePermission));

bool canSaveProvider(User? user, {required bool isNew}) =>
    user?.hasPermission(
      isNew ? kProviderCreatePermission : kProviderUpdatePermission,
    ) ??
    false;

bool canDeleteProvider(User? user, AdminPaymentProvider? provider) =>
    provider != null &&
    !provider.isSystem &&
    (user?.hasPermission(kProviderDeletePermission) ?? false);

/// Its own slug once saved, else what the server will make from [name]; empty
/// while there is no name.
String providerSlugPreview(AdminPaymentProvider? original, String name) =>
    original?.slug ?? ProviderInputValidator.slugOf(name);

List<String> withTypedAliases(List<String> aliases, String text) {
  final added = text
      .split(',')
      .map(ProviderInputValidator.normalizedAlias)
      .where((a) => a.isNotEmpty);
  return {...aliases, ...added}.toList();
}

final kSortOrderInput = RegExp(r'^-?\d{0,9}$');
