import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../pages/login_page.dart';
import '../../pages/dashboard_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      print('Auth state changed: $event');
      print('Session is null: ${session == null}');
      
      setState(() {
        _isAuthenticated = session != null;
        _isLoading = false;
      });
    });
  }

  Future<void> _checkAuthState() async {
    try {
      // Check current session
      final session = Supabase.instance.client.auth.currentSession;
      
      print('Initial auth check - Session is null: ${session == null}');
      
      setState(() {
        _isAuthenticated = session != null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking auth state: $e');
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading animation
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Icon(
                    Icons.flash_on,
                    color: AppColors.bg,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Loading text
              Text(
                'System Loading...',
                style: AppTextStyles.terminal.copyWith(
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Verifying authentication state',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Loading indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.cardBg2,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      return const DashboardPage();
    } else {
      return const LoginPage();
    }
  }
}
