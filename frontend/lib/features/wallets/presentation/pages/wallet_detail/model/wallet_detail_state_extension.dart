import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/wallets/domain/logic/wallet_form_rules.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/bloc/wallet_detail_bloc.dart';

extension WalletDetailStateX on WalletDetailState {
  bool get isBusy => isArchiving || isSettingDefault;

  bool get canArchive => wallet != null && !wallet!.isDefault;

  List<int> get dailyOutflows => dailyOutflowSeries(
    outflows,
    month,
    month == monthOf(today)
        ? today.day
        : DateTime(month.year, month.month + 1, 0).day,
  );

  int get monthOutflow => outflows.values.fold<int>(0, (sum, v) => sum + v);
}
