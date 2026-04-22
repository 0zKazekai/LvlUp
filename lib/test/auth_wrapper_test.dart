import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/auth_wrapper.dart';

class AuthWrapperTest extends StatelessWidget {
  const AuthWrapperTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Auth Wrapper Test'),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAuthInfo(context),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: const AuthWrapper(),
    );
  }

  void _showAuthInfo(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Authentication Status',
          style: TextStyle(color: Color(0xFF00E5FF)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session: ${session != null ? "Active" : "None"}',
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
            if (user != null) ...[
              const SizedBox(height: 8),
              Text(
                'User ID: ${user.id}',
                style: const TextStyle(color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 4),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 4),
              Text(
                'Created: ${user.createdAt}',
                style: const TextStyle(color: Color(0xFF94A3B8)),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Session Persistence: Enabled',
              style: const TextStyle(color: Color(0xFF8B5CF6)),
            ),
            const SizedBox(height: 4),
            Text(
              'Auto-refresh: Enabled',
              style: const TextStyle(color: Color(0xFF8B5CF6)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF00E5FF)),
            ),
          ),
        ],
      ),
    );
  }
}
