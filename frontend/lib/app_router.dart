import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/features/auth/presentation/pages/change_password/change_password_page.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/onboarding_page.dart';
import 'package:monai/features/auth/presentation/pages/register/register_page.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:monai/features/budgets/presentation/pages/budget/budget_page.dart';
import 'package:monai/features/categories/presentation/pages/categories/categories_page.dart';
import 'package:monai/features/categories/presentation/pages/category_form/category_form_page.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:monai/features/home/presentation/pages/home/home_page.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/edit_profile_page.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/quick_add_page.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/quick_add_review_page.dart';
import 'package:monai/features/receipt/presentation/model/receipt_review_args.dart';
import 'package:monai/features/receipt/presentation/pages/receipt_review/receipt_review_page.dart';
import 'package:monai/features/receipt/presentation/pages/scan_receipt/scan_receipt_page.dart';
import 'package:monai/features/reports/presentation/pages/report/report_page.dart';
import 'package:monai/features/settings/presentation/pages/manage_providers/manage_providers_page.dart';
import 'package:monai/features/settings/presentation/pages/provider_form/provider_form_page.dart';
import 'package:monai/features/settings/presentation/pages/settings/settings_page.dart';
import 'package:monai/features/shared/domain/entity/quick_add_draft.dart';
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
import 'package:monai/route_path.dart';

/// Navigation follows [sessionManager]: a sign-in leaves the auth screens for
/// Home, a sign-out returns to Sign in. An expired session stays put under the
/// session-expired dialog until the user signs in again.
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
      GoRoute(
        path: AppRoutes.quickAdd,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const QuickAddPage(),
        ),
        routes: [
          GoRoute(
            path: 'review',
            // The drafts only live in memory: without them, start over.
            redirect: (_, state) =>
                state.extra is QuickAddReviewArgs ? null : AppRoutes.quickAdd,
            builder: (_, state) =>
                QuickAddReviewPage(args: state.extra! as QuickAddReviewArgs),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.receiptScan,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const ScanReceiptPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.receiptReview,
        // The draft only lives in memory: without it, scan again.
        redirect: (_, state) =>
            state.extra is ReceiptReviewArgs ? null : AppRoutes.receiptScan,
        builder: (_, state) =>
            ReceiptReviewPage(args: state.extra! as ReceiptReviewArgs),
      ),
      GoRoute(
        path: AppRoutes.budget,
        builder: (_, state) => BudgetPage(
          month:
              parseMonthParam(
                state.uri.queryParameters[AppRoutes.monthParam],
              ) ??
              monthOf(DateTime.now()),
        ),
      ),
      GoRoute(
        path: AppRoutes.report,
        builder: (_, state) => ReportPage(
          month:
              parseMonthParam(
                state.uri.queryParameters[AppRoutes.monthParam],
              ) ??
              monthOf(DateTime.now()),
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
                        mode: switch (state.extra) {
                          final QuickAddDraft draft =>
                            TransactionFormMode.prefill(draft),
                          _ => TransactionFormMode.add(
                            type:
                                TransactionType.values.asNameMap()[state
                                    .uri
                                    .queryParameters[AppRoutes.typeParam]] ??
                                TransactionType.expense,
                            walletId: state
                                .uri
                                .queryParameters[AppRoutes.walletParam],
                          ),
                        },
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
                routes: [
                  GoRoute(
                    path: 'profile',
                    parentNavigatorKey: rootKey,
                    builder: (_, state) => EditProfilePage(
                      focusDelete:
                          state.uri.queryParameters[AppRoutes.focusParam] ==
                          'delete',
                    ),
                  ),
                  GoRoute(
                    path: 'password',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const ChangePasswordPage(),
                  ),
                  GoRoute(
                    path: 'providers',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const ManageProvidersPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => ProviderFormPage(placement: placement),
                        ),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => ProviderFormPage(
                            providerId: state.pathParameters['id'],
                            placement: placement,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'categories',
                    parentNavigatorKey: rootKey,
                    builder: (_, _) => const CategoriesPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => CategoryFormPage(
                            placement: placement,
                            mode: CategoryFormMode.create(
                              CategoryType.values.asNameMap()[state
                                      .uri
                                      .queryParameters[AppRoutes.typeParam]] ??
                                  CategoryType.expense,
                            ),
                          ),
                        ),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        parentNavigatorKey: rootKey,
                        pageBuilder: (context, state) => _formPage(
                          context,
                          state,
                          (placement) => CategoryFormPage(
                            placement: placement,
                            mode: CategoryFormMode.edit(
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
        ],
      ),
    ],
  );
}

/// True once the draft was saved, false when the user closed the form.
Future<bool> pushQuickAddForm(
  BuildContext context,
  QuickAddDraft draft,
) async => await context.push<TransactionFormOutcome>(
  AppRoutes.transactionNew,
  extra: draft,
) is SavedFormOutcome;

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

DateTime? parseMonthParam(String? value) {
  final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(value ?? '');
  if (match == null) return null;
  final month = int.parse(match.group(2)!);
  if (month < 1 || month > 12) return null;
  return DateTime(int.parse(match.group(1)!), month);
}

/// [AppRoutes.launch] is left alone: go_router runs this before the route's
/// own [launchRedirect], which picks the first screen.
String? sessionRedirect(SessionStatus status, String location) {
  if (location == AppRoutes.launch) return null;
  final onSignedOutRoute = AppRoutes.signedOutRoutes.contains(location);
  return switch (status) {
    .signedIn when onSignedOutRoute => AppRoutes.home,
    .signedOut when !onSignedOutRoute => AppRoutes.signIn,
    .signedIn || .signedOut || .expired || .passwordChanged => null,
  };
}

Future<String> launchRedirect(
  SessionStatus status,
  Future<bool> Function() isOnboardingCompleted,
) async => switch (status) {
  .signedIn => AppRoutes.home,
  .signedOut ||
  .expired ||
  .passwordChanged when await isOnboardingCompleted() => AppRoutes.signIn,
  .signedOut || .expired || .passwordChanged => AppRoutes.onboarding,
};
