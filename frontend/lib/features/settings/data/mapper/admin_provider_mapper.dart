import 'package:monai/features/settings/data/model/admin_provider_response.dart';
import 'package:monai/features/settings/data/model/create_provider_request.dart';
import 'package:monai/features/settings/data/model/update_provider_request.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';

extension AdminProviderDataMapper on AdminProviderData {
  /// Throws the malformed-response error when a required field is missing.
  AdminPaymentProvider toEntity() => AdminPaymentProvider(
    id: requireField(id),
    slug: requireField(slug),
    name: requireField(name),
    type: parseWalletType(type),
    logoUrl: logoUrl,
    aliases: aliases ?? const [],
    sortOrder: sortOrder ?? 0,
    isActive: isActive ?? false,
    isSystem: isSystem ?? false,
    updatedAt: requireField(updatedAt),
  );
}

extension AdminProviderResponseMapper on AdminProviderResponse {
  /// The provider in `data`; throws the malformed-response error when it is
  /// missing.
  AdminPaymentProvider toEntity() => requireField(data).toEntity();
}

extension ProviderInputMapper on ProviderInput {
  CreateProviderRequest toCreateRequest() => CreateProviderRequest(
    name: name,
    type: type.apiValue,
    aliases: aliases,
    sortOrder: sortOrder,
  );
}

extension ProviderChangesMapper on ProviderChanges {
  UpdateProviderRequest toUpdateRequest() => UpdateProviderRequest(
    name: name,
    type: type?.apiValue,
    aliases: aliases,
    sortOrder: sortOrder,
  );
}
