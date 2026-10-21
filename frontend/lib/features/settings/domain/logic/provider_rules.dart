import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/validation/provider_input_validator.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// Lets a user add payment providers.
const kProviderCreatePermission = 'payment_provider.create';

/// Lets a user edit payment providers and switch them on or off.
const kProviderUpdatePermission = 'payment_provider.update';

/// Lets a user delete payment providers.
const kProviderDeletePermission = 'payment_provider.delete';

/// How a provider shows in the admin list.
enum ProviderStatus {
  /// Built in: always active, never deleted.
  system,
  active,
  inactive,
}

/// [provider]'s badge in the admin list.
ProviderStatus providerStatusOf(AdminPaymentProvider provider) =>
    provider.isSystem
    ? .system
    : provider.isActive
    ? .active
    : .inactive;

/// [provider]'s aliases as one line, as typed into quick add:
/// `gopay, gpay, go-pay`.
String aliasSummary(AdminPaymentProvider provider) =>
    provider.aliases.join(', ');

/// Whether [provider] matches the search [query]: its name, slug or any
/// alias contains it, ignoring case. A blank query matches everything.
bool providerMatches(AdminPaymentProvider provider, String query) {
  final needle = query.trim().toLowerCase();
  return needle.isEmpty ||
      provider.name.toLowerCase().contains(needle) ||
      provider.slug.toLowerCase().contains(needle) ||
      provider.aliases.any((a) => a.toLowerCase().contains(needle));
}

/// The providers of [providers] that match [query], in their order.
List<AdminPaymentProvider> filterProviders(
  List<AdminPaymentProvider> providers,
  String query,
) => providers.where((p) => providerMatches(p, query)).toList();

/// [user] may add providers.
bool canCreateProviders(User? user) =>
    user?.hasPermission(kProviderCreatePermission) ?? false;

/// [user] may open a provider to change or delete it.
bool canEditProviders(User? user) =>
    user != null &&
    (user.hasPermission(kProviderUpdatePermission) ||
        user.hasPermission(kProviderDeletePermission));

/// [user] may save the provider form: a new provider needs the create
/// permission, an existing one the update permission.
bool canSaveProvider(User? user, {required bool isNew}) =>
    user?.hasPermission(
      isNew ? kProviderCreatePermission : kProviderUpdatePermission,
    ) ??
    false;

/// [user] may delete [provider]; system providers can't be deleted.
bool canDeleteProvider(User? user, AdminPaymentProvider? provider) =>
    provider != null &&
    !provider.isSystem &&
    (user?.hasPermission(kProviderDeletePermission) ?? false);

/// The provider's ID as shown on the form: its own slug once saved, else
/// what the server will make from [name]; empty while there is no name.
String providerSlugPreview(AdminPaymentProvider? original, String name) =>
    original?.slug ?? ProviderInputValidator.slugOf(name);

/// Splits typed alias [text] on commas and adds the normalized words to
/// [aliases], keeping their order and dropping repeats.
List<String> withTypedAliases(List<String> aliases, String text) {
  final added = text
      .split(',')
      .map(ProviderInputValidator.normalizedAlias)
      .where((a) => a.isNotEmpty);
  return {...aliases, ...added}.toList();
}

/// A sort order as typed: digits with an optional leading minus, at most
/// nine digits.
final kSortOrderInput = RegExp(r'^-?\d{0,9}$');
