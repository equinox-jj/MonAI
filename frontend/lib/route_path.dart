import 'package:monai/core/model/category_type.dart';

abstract final class RoutePath {
  static const launch = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const register = '/register';
  static const home = '/home';
  static const transactions = '/transactions';
  static const wallets = '/wallets';
  static const settings = '/settings';
  static const categories = '/settings/categories';
  static const profile = '/settings/profile';
  static const changePassword = '/settings/password';
  static const providers = '/settings/providers';
  static const providerNew = '$providers/new';

  static String providerEdit(String id) => '$providers/$id/edit';

  static const focusParam = 'focus';

  static final profileDeleteAccount = Uri(
    path: profile,
    queryParameters: {focusParam: 'delete'},
  ).toString();

  /// Pops with the new category's id, or null when closed without saving.
  static String categoryNew(CategoryType type) => Uri(
    path: '$categories/new',
    queryParameters: {typeParam: type.name},
  ).toString();

  static String categoryEdit(String id) => '$categories/$id/edit';

  static const walletNew = '/wallets/new';
  static const walletsArchived = '/wallets/archived';

  static String walletDetail(String id) => '$wallets/$id';

  static String walletEdit(String id) => '$wallets/$id/edit';

  static const transactionSearch = '/transactions/search';

  /// Pass a `QuickAddDraft` as `extra` to start from it; see
  /// `pushQuickAddForm` in `app_router.dart`.
  static const transactionNew = '/transactions/new';

  /// Search's starting month, as `yyyy-MM`.
  static const monthParam = 'month';
  static const typeParam = 'type';
  static const walletParam = 'wallet';

  static String transactionSearchIn([DateTime? month]) =>
      _inMonth(transactionSearch, month);

  static String newTransaction({String? type, String? walletId}) => Uri(
    path: transactionNew,
    queryParameters: {typeParam: ?type, walletParam: ?walletId},
  ).toString().replaceFirst(RegExp(r'\?$'), '');

  static String transactionDetail(String id) => '$transactions/$id';

  static String transactionEdit(String id) => '$transactions/$id/edit';

  static const quickAdd = '/quick-add';

  /// Takes `QuickAddReviewArgs` as `extra`; pops with a `QuickAddReviewExit`.
  static const quickAddReview = '/quick-add/review';
  static const receiptScan = '/receipt/scan';

  /// Takes `ReceiptReviewArgs` as `extra`.
  static const receiptReview = '/receipt/review';
  static const budget = '/budget';

  static String budgetFor([DateTime? month]) => _inMonth(budget, month);

  static const report = '/report';

  static String reportFor([DateTime? month]) => _inMonth(report, month);

  static const emailParam = 'email';
  static const signedOutRoutes = {onboarding, signIn, register};

  static String signInWith({String email = ''}) => _withEmail(signIn, email);

  static String registerWith({String email = ''}) =>
      _withEmail(register, email);

  static String _inMonth(String path, DateTime? month) => Uri(
    path: path,
    queryParameters: month == null
        ? null
        : {
            monthParam:
                '${month.year}-${month.month.toString().padLeft(2, '0')}',
          },
  ).toString();

  static String _withEmail(String path, String email) => Uri(
    path: path,
    queryParameters: email.isEmpty ? null : {emailParam: email},
  ).toString();
}
