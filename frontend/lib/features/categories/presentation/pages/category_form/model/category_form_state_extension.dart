import 'package:monai/features/categories/domain/logic/category_rules.dart';
import 'package:monai/features/categories/presentation/pages/category_form/bloc/category_form_bloc.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';

extension CategoryFormStateX on CategoryFormState {
  bool get isEdit => mode is EditCategoryMode;

  bool get canDelete => original?.canDelete ?? false;
}
