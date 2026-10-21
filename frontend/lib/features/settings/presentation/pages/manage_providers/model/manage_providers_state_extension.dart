import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/bloc/manage_providers_bloc.dart';

extension ManageProvidersStateX on ManageProvidersState {
  List<AdminPaymentProvider> get shown => filterProviders(providers, query);
}
