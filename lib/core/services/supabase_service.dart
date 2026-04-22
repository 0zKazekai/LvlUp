import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../security/app_security.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();

  late final SupabaseClient _client;

  Future<void> initialize() async {
    try {
      _client = Supabase.instance.client;
      
      // Test connection
      await _client.from('profiles').select('count').count();
      print(' Supabase initialized and connected successfully');
      
    } catch (e) {
      print(' Supabase initialization failed: $e');
      rethrow;
    }
  }

  SupabaseClient get client => _client;

  // User authentication
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final sanitizedEmail = AppSecurity.sanitizeInput(email);
      
      if (!AppSecurity.isValidEmail(sanitizedEmail)) {
        throw Exception('Invalid email format');
      }

      // Rate limiting check
      if (AppSecurity.isRateLimited('signup_${sanitizedEmail}')) {
        throw Exception('Too many signup attempts. Please try again later.');
      }

      return await _client.auth.signUp(
        email: sanitizedEmail,
        password: password,
      );
    } catch (e) {
      print('Signup failed: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final sanitizedEmail = AppSecurity.sanitizeInput(email);
      
      if (!AppSecurity.isValidEmail(sanitizedEmail)) {
        throw Exception('Invalid email format');
      }

      // Rate limiting check
      if (AppSecurity.isRateLimited('signin_${sanitizedEmail}')) {
        throw Exception('Too many signin attempts. Please try again later.');
      }

      return await _client.auth.signInWithPassword(
        email: sanitizedEmail,
        password: password,
      );
    } catch (e) {
      print('Signin failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print('Signout failed: $e');
      rethrow;
    }
  }

  // Profile management
  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Sanitize and validate input
      final sanitizedData = profileData.map((key, value) {
        if (value is String) {
          return MapEntry(key, AppSecurity.sanitizeInput(value));
        }
        return MapEntry(key, value);
      });

      final response = await _client
          .from('profiles')
          .insert({
            ...sanitizedData,
            'id': userId,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (e) {
      print('Profile creation failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return null;
      }

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Profile fetch failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Sanitize input
      final sanitizedUpdates = updates.map((key, value) {
        if (value is String) {
          return MapEntry(key, AppSecurity.sanitizeInput(value));
        }
        return MapEntry(key, value);
      });

      final response = await _client
          .from('profiles')
          .update({
            ...sanitizedUpdates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Profile update failed: $e');
      rethrow;
    }
  }

  // Quest management
  Future<List<Map<String, dynamic>>> getQuests({String? status}) async {
    try {
      var query = _client.from('quests').select();
      
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Quests fetch failed: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createQuest(Map<String, dynamic> questData) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final sanitizedData = questData.map((key, value) {
        if (value is String) {
          return MapEntry(key, AppSecurity.sanitizeInput(value));
        }
        return MapEntry(key, value);
      });

      final response = await _client
          .from('quests')
          .insert({
            ...sanitizedData,
            'user_id': userId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response;
    } catch (e) {
      print('Quest creation failed: $e');
      rethrow;
    }
  }

  // File upload for quest proofs
  Future<String> uploadFile(String filePath, String fileName) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final sanitizedFileName = AppSecurity.sanitizeInput(fileName);
      final path = 'proofs/$userId/$sanitizedFileName';

      final response = await _client.storage
          .from('quest_proofs')
          .upload(path, File(filePath));

      if (response.isEmpty) {
        throw Exception('File upload failed');
      }

      final publicUrl = _client.storage
          .from('quest_proofs')
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      print('File upload failed: $e');
      rethrow;
    }
  }

  // Error handling wrapper
  Future<T> withErrorHandling<T>(Future<T> Function() operation, String operationName) async {
    try {
      return await operation();
    } catch (e) {
      print('$operationName failed: $e');
      
      // Log error to monitoring service (Sentry, etc.)
      // await logError(e, operationName);
      
      rethrow;
    }
  }
}
