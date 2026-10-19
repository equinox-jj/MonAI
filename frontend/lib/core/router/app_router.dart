import 'package:go_router/go_router.dart';

import 'package:monai/features/auth/presentation/pages/onboarding/onboarding_page.dart';
import 'package:monai/features/auth/presentation/pages/register/register_page.dart';
import 'package:monai/features/auth/presentation/pages/sign_in/sign_in_page.dart';

/// The app's route paths.
abstract final class AppRoutes {
  /// First-launch introduction.
  static const onboarding = '/onboarding';

  /// Sign in.
  static const signIn = '/sign-in';

  /// Create an account.
  static const register = '/register';
}

/// Builds the app's router, starting at [initialLocation].
GoRouter createAppRouter({required String initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) => const OnboardingPage(),
    ),
    GoRoute(path: AppRoutes.signIn, builder: (_, _) => const SignInPage()),
    GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterPage()),
  ],
);
