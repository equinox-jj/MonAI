import 'package:monai/features/receipt/presentation/pages/scan_receipt/bloc/scan_receipt_bloc.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/model/scan_phase.dart';

extension ScanReceiptStateX on ScanReceiptState {
  bool get canCapture =>
      camera == CameraStatus.ready && phase is CameraScanPhase && !isCapturing;
}
