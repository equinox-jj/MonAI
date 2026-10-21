import 'package:monai/features/export/presentation/pages/export_csv/bloc/export_csv_bloc.dart';

extension ExportCsvStateX on ExportCsvState {
  bool get canMoveFromForward => range.from.isBefore(currentMonth);

  bool get canMoveToForward => range.to.isBefore(currentMonth);
}
