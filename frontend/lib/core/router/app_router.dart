import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/onboarding_page.dart';
import 'package:monai/features/auth/presentation/pages/register/register_page.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:monai/features/dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:monai/features/home/presentation/pages/home/home_page.dart';
import 'package:monai/features/settings/presentation/pages/settings/settings_page.dart';
import 'package:monai/features/transactions/presentation/pages/search/search_page.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/model/transaction_form_mode.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/transaction_form_page.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/transactions_page.dart';
import 'package:monai/features/transactions/presentation/pages/undo_delete/undo_delete_host.dart';
import 'package:monai/features/wallets/presentation/pages/archived_wallets/archived_wallets_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_detail/wallet_detail_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/model/wallet_form_mode.dart';
import 'package:monai/features/wallets/presentation/pages/wallet_form/wallet_form_page.dart';
import 'package:monai/features/wallets/presentation/pages/wallets/wallets_page.dart';

/// The app's route paths.
abstract final class AppRoutes {
  /// Where the app starts; it only redirects to the first screen.
  static const launch = '/';

  /// First-launch introduction.
  static const onboarding = '/onboarding';

  /// Sign in.
  static const signIn = '/sign-in';

  /// Create an account.
  static const register = '/register';

  /// The signed-in start screen, the first tab.
  static const home = '/home';

  /// The transactions tab.
  static const transactions = '/transactions';

  /// The wallets tab.
  static const wallets = '/wallets';

  /// The settings tab.
  static const settings = '/settings';

  /// The add-wallet form.
  static const walletNew = '/wallets/new';

  /// The archived wallets.
  static const walletsArchived = '/wallets/archived';

  /// The detail of wallet [id].
  static String walletDetail(String id) => '$wallets/$id';

  /// The edit form of wallet [id].
  static String walletEdit(String id) => '$wallets/$id/edit';

  /// Search over notes and merchants; see [transactionSearchIn].
  static const transactionSearch = '/transactions/search';

  /// The add-transaction form; see [newTransaction].
  static const transactionNew = '/transactions/new';

  /// The query parameter Search starts in, as `yyyy-MM`.
  static const monthParam = 'month';

  /// The query parameters the add form starts with.
  static const typeParam = 'type';
  static const walletParam = 'wallet';

  /// Search, starting in [month] when given.
  static String transactionSearchIn([DateTime? month]) => Uri(
    path: transactionSearch,
    queryParameters: month == null
        ? null
        : {
            monthParam:
                '${month.year}-${month.month.toString().padLeft(2, '0')}',
          },
  ).toString();

  /// The add form, starting as a [type] (`expense`, `income`, `transfer`)
  /// out of [walletId] when given.
  static String newTransaction({String? type, String? walletId}) => Uri(
    path: transactionNew,
    queryParameters: {typeParam: ?type, walletParam: ?walletId},
  ).toString().replaceFirst(RegExp(r'\?$'), '');

  /// The detail of transaction [id].
  static String transactionDetail(String id) => '$transactions/$id';

  /// The edit form of transaction [id].
  static String transactionEdit(String id) => '$transactions/$id/edit';

  /// The query parameter Sign in and Register hand the typed email over in.
  static const emailParam = 'email';

  /// The screens a signed-out user may see.
  static const signedOutRoutes = {onboarding, signIn, register};

  /// Sign in, starting with [email] when given.
  static String signInWith({String email = ''}) => _withEmail(signIn, email);

  /// Register, starting with [email] when given.
  static String registerWith({String email = ''}) =>
      _withEmail(register, email);

  static String _withEmail(String path, String email) => Uri(
    path: path,
    queryParameters: email.isEmpty ? null : {emailParam: email},
  ).toString();
}

/// Builds the app's router, starting at [initialLocation].
///
/// The [AppRoutes.launch] route picks the first screen with
/// [launchRedirect], asking [isOnboardingCompleted] only for a signed-out
/// user. After that, navigation follows [sessionManager]: a sign-in leaves the
/// auth screens for Home, and a sign-out returns to Sign in. An expired
/// session stays put under the session-expired dialog until the user signs in
/// again.
GoRouter createAppRouter({
  required SessionManager sessionManager,
  required Future<bool> Function() isOnboardingCompleted,
  String initialLocation = AppRoutes.launch,
}) {
  // Screens above the tabs, covering the navigation bar.
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    refreshListenable: sessionManager.status,
    redirect: (_, state) =>
        sessionRedirect(sessionManager.status.value, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.launch,
        redirect: (_, _) =>
            launchRedirect(sessionManager.status.value, isOnboardingCompleted),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (_, state) => SignInPage(
          initialEmail: state.uri.queryParameters[AppRoutes.emailParam] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, state) => RegisterPage(
          initialEmail: state.uri.queryParameters[AppRoutes.emailParam] ?? '',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => UndoDeleteHost(
          child: DashboardPage(navigationShell: navigationShell),
        ),
        // In bar order: MonAINavItem.main.
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (_, _) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) => SearchPage(
                      initialMonth: parseMonthParam(
                        state.uri.queryParameters[AppRoutes.monthParam],
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootKey,
                    pageBuilder: (context, state) => _formPage(
                      context,
                      state,
                      (placement) => TransactionFormPage(
                        placement: placement,
                        mode: TransactionFormMode.add(
                          type:
                              TransactionType.values.asNameMap()[state
                                  .uri
                                  .queryParameters[AppRoutes.typeParam]] ??
                              TransactionType.expense,
                          walletId:
                              state.uri.queryParameters[AppRoutes.walletParam],
                        ),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) =>
                        TransactionDetailPage(id: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => TransactionFormPage(
                            placement: placement,
                            mode: TransactionFormMode.edit(
                              state.pathParameters['id']!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.wallets,
                builder: (_, _) => const WalletsPage(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootKey,
                    pageBuilder: (context, state) => _formPage(
                      context,
                      state,
                      (placement) => WalletFormPage(
                        mode: const WalletFormMode.add(),
                        placement: placement,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'archived',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const ArchivedWalletsPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) =>
                        WalletDetailPage(id: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => WalletFormPage(
                            mode: WalletFormMode.edit(
                              state.pathParameters['id']!,
                            ),
                            placement: placement,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// An add or edit form, built for where it shows: a side sheet over the
/// screen on tablet landscape, otherwise a full-screen dialog.
Page<void> _formPage(
  BuildContext context,
  GoRouterState state,
  Widget Function(ScreenPlacement placement) form,
) {
  if (context.widthClass != .expanded) {
    return MaterialPage(
      key: state.pageKey,
      fullscreenDialog: true,
      child: form(.fullScreen),
    );
  }
  return CustomTransitionPage(
    key: state.pageKey,
    opaque: false,
    barrierDismissible: false,
    barrierColor: context.colors.scrim,
    child: Align(
      alignment: .centerRight,
      child: SizedBox(
        width: _sideSheetWidth,
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(MonAIRadius.xl),
          ),
          child: form(.sideSheet),
        ),
      ),
    ),
    transitionsBuilder: (_, animation, _, child) => SlideTransition(
      position: Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

const _sideSheetWidth = 480.0;

/// The first of the month in a `yyyy-MM` query value; null when missing or
/// malformed.
DateTime? parseMonthParam(String? value) {
  final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(value ?? '');
  if (match == null) return null;
  final month = int.parse(match.group(2)!);
  if (month < 1 || month > 12) return null;
  return DateTime(int.parse(match.group(1)!), month);
}

/// Where the session sends a user at [location], or null to stay.
///
/// [AppRoutes.launch] is left alone: go_router runs this before the route's
/// own [launchRedirect], which picks the first screen.
String? sessionRedirect(SessionStatus status, String location) {
  if (location == AppRoutes.launch) return null;
  final onSignedOutRoute = AppRoutes.signedOutRoutes.contains(location);
  return switch (status) {
    .signedIn when onSignedOutRoute => AppRoutes.home,
    .signedOut when !onSignedOutRoute => AppRoutes.signIn,
    .signedIn || .signedOut || .expired => null,
  };
}

/// The first screen for a user whose session is [status] at launch.
///
/// A signed-in user starts on Home; anyone else starts on Sign in once
/// [isOnboardingCompleted], and on Onboarding before that.
Future<String> launchRedirect(
  SessionStatus status,
  Future<bool> Function() isOnboardingCompleted,
) async => switch (status) {
  .signedIn => AppRoutes.home,
  .signedOut || .expired when await isOnboardingCompleted() => AppRoutes.signIn,
  .signedOut || .expired => AppRoutes.onboarding,
};
