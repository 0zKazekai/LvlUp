import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/onboarding/onboarding_page.dart';
import '../../widgets/shell/main_shell.dart';
import '../../providers/user_provider.dart';
import '../../test/data_plumbing_test.dart';

class AppRouter {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String dataTest = '/data-test';

  static GoRouter router() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) {
            final userProvider = context.read<UserProvider>();
            
            // Check if user has completed onboarding
            if (userProvider.userStats.username == 'Player' && 
                userProvider.userStats.questsCompleted == 0) {
              return AppRouter.onboarding;
            }
            
            return AppRouter.home;
          },
        ),
        GoRoute(
          path: AppRouter.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRouter.home,
          builder: (context, state) => const MainShell(),
        ),
        GoRoute(
          path: AppRouter.dataTest,
          builder: (context, state) => const DataPlumbingTest(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRouter.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: const Color(0xFF0A0E1A),
                ),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
