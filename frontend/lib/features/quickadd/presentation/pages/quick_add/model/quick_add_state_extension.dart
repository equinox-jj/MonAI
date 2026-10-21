import 'package:monai/features/quickadd/domain/entity/quick_add_reading.dart';
import 'package:monai/features/quickadd/domain/parser/quick_add_parser.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';

extension QuickAddStateX on QuickAddState {
  bool get willAskAi => engine == DraftEngine.local && needsAi(drafts);

  bool get hasMissingAmount => drafts.any((d) => d.amount == null);

  bool get canContinue => drafts.isNotEmpty && !isAsking;
}
