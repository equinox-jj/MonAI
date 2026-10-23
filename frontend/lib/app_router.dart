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
  String initialLocation = RoutePath.launch,
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
        path: RoutePath.launch,
        redirect: (_, _) =>
            launchRedirect(sessionManager.status.value, isOnboardingCompleted),
      ),
      GoRoute(
        path: RoutePath.onboarding,
        pageBuilder: _page((_, _) => const OnboardingPage()),
      ),
      GoRoute(
        path: RoutePath.signIn,
        pageBuilder: _page(
          (_, state) => SignInPage(
            initialEmail: state.uri.queryParameters[RoutePath.emailParam] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RoutePath.register,
        pageBuilder: _page(
          (_, state) => RegisterPage(
            initialEmail: state.uri.queryParameters[RoutePath.emailParam] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RoutePath.quickAdd,
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
                state.extra is QuickAddReviewArgs ? null : RoutePath.quickAdd,
            pageBuilder: _page(
              (_, state) =>
                  QuickAddReviewPage(args: state.extra! as QuickAddReviewArgs),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePath.receiptScan,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const ScanReceiptPage(),
        ),
      ),
      GoRoute(
        path: RoutePath.receiptReview,
        // The draft only lives in memory: without it, scan again.
        redirect: (_, state) =>
            state.extra is ReceiptReviewArgs ? null : RoutePath.receiptScan,
        pageBuilder: _page(
          (_, state) =>
              ReceiptReviewPage(args: state.extra! as ReceiptReviewArgs),
        ),
      ),
      GoRoute(
        path: RoutePath.budget,
        pageBuilder: _page(
          (_, state) => BudgetPage(
            month:
                parseMonthParam(
                  state.uri.queryParameters[RoutePath.monthParam],
                ) ??
                monthOf(DateTime.now()),
          ),
        ),
      ),
      GoRoute(
        path: RoutePath.report,
        pageBuilder: _page(
          (_, state) => ReportPage(
            month:
                parseMonthParam(
                  state.uri.queryParameters[RoutePath.monthParam],
                ) ??
                monthOf(DateTime.now()),
          ),
        ),
      ),
      StatefulShellRoute(
        pageBuilder: (_, state, navigationShell) => _materialPage(
          state,
          UndoDeleteHost(
            child: DashboardPage(navigationShell: navigationShell),
          ),
        ),
        navigatorContainerBuilder: (_, navigationShell, children) =>
            MonAIFadeThroughStack(
              index: navigationShell.currentIndex,
              children: children,
            ),
        // In bar order: MonAINavItem.main.
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.home,
                pageBuilder: _page((_, _) => const HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.transactions,
                pageBuilder: _page((_, _) => const TransactionsPage()),
                routes: [
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page(
                      (_, state) => SearchPage(
                        initialMonth: parseMonthParam(
                          state.uri.queryParameters[RoutePath.monthParam],
                        ),
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
                                    .queryParameters[RoutePath.typeParam]] ??
                                TransactionType.expense,
                            walletId: state
                                .uri
                                .queryParameters[RoutePath.walletParam],
                          ),
                        },
                      ),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page(
                      (_, state) => TransactionDetailPage(
                        id: state.pathParameters['id']!,
                      ),
                    ),
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
                path: RoutePath.wallets,
                pageBuilder: _page((_, _) => const WalletsPage()),
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
                    pageBuilder: _page((_, _) => const ArchivedWalletsPage()),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page(
                      (_, state) =>
                          WalletDetailPage(id: state.pathParameters['id']!),
                    ),
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
                path: RoutePath.settings,
                pageBuilder: _page((_, _) => const SettingsPage()),
                routes: [
                  GoRoute(
                    path: 'profile',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page(
                      (_, state) => EditProfilePage(
                        focusDelete:
                            state.uri.queryParameters[RoutePath.focusParam] ==
                            'delete',
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'password',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page((_, _) => const ChangePasswordPage()),
                  ),
                  GoRoute(
                    path: 'providers',
                    parentNavigatorKey: rootKey,
                    pageBuilder: _page((_, _) => const ManageProvidersPage()),
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
                    pageBuilder: _page((_, _) => const CategoriesPage()),
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
                                      .queryParameters[RoutePath.typeParam]] ??
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
  RoutePath.transactionNew,
  extra: draft,
) is SavedFormOutcome;

/// Use instead of `builder:`. go_router only recognizes material_ui's
/// MaterialApp, so for this app's MaterialApp it wraps `builder:` routes in a
/// NoTransitionPage and navigation has no animation.
GoRouterPageBuilder _page(GoRouterWidgetBuilder builder) =>
    (context, state) => _materialPage(state, builder(context, state));

Page<void> _materialPage(GoRouterState state, Widget child) => MaterialPage(
  key: state.pageKey,
  name: state.name ?? state.path,
  restorationId: state.pageKey.value,
  child: child,
);

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

/// [RoutePath.launch] is left alone: go_router runs this before the route's
/// own [launchRedirect], which picks the first screen.
String? sessionRedirect(SessionStatus status, String location) {
  if (location == RoutePath.launch) return null;
  final onSignedOutRoute = RoutePath.signedOutRoutes.contains(location);
  return switch (status) {
    .signedIn when onSignedOutRoute => RoutePath.home,
    .signedOut when !onSignedOutRoute => RoutePath.signIn,
    .signedIn || .signedOut || .expired || .passwordChanged => null,
  };
}

Future<String> launchRedirect(
  SessionStatus status,
  Future<bool> Function() isOnboardingCompleted,
) async => switch (status) {
  .signedIn => RoutePath.home,
  .signedOut ||
  .expired ||
  .passwordChanged when await isOnboardingCompleted() => RoutePath.signIn,
  .signedOut || .expired || .passwordChanged => RoutePath.onboarding,
};
