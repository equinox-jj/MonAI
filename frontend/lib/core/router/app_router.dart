import 'package:go_router/go_router.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/features/auth/presentation/pages/onboarding/onboarding_page.dart';
import 'package:monai/features/auth/presentation/pages/register/register_page.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/sign_in_page.dart';
import 'package:monai/features/dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:monai/features/home/presentation/pages/home/home_page.dart';
import 'package:monai/features/settings/presentation/pages/settings/settings_page.dart';
import 'package:monai/features/transactions/presentation/pages/transactions/transactions_page.dart';
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
}) => GoRouter(
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
      builder: (_, _, navigationShell) =>
          DashboardPage(navigationShell: navigationShell),
      // In bar order: MonAINavItem.main.
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.transactions,
              builder: (_, _) => const TransactionsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.wallets,
              builder: (_, _) => const WalletsPage(),
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

/// Where the session sends a user at [location], or null to stay.
String? sessionRedirect(SessionStatus status, String location) {
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
