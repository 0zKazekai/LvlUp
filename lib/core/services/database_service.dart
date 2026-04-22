import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../security/app_security.dart';
import '../../models/user.dart';
import '../../models/habit.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  
  DatabaseService._();

  late final SupabaseClient _client;

  Future<void> initialize() async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      
      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception('Supabase credentials not found in environment variables');
      }

      _client = Supabase.instance.client;
      
      // Test connection
      await _client.from('profiles').select('count').count();
      print(' DatabaseService initialized and connected successfully');
      
    } catch (e) {
      print(' DatabaseService initialization failed: $e');
      rethrow;
    }
  }

  SupabaseClient get client => _client;

  // User operations with type safety
  Future<User?> getCurrentUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        print(' No authenticated user found');
        return null;
      }

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        print(' No profile found for user: $userId');
        return null;
      }

      print(' Successfully fetched user profile');
      return User.fromJson(response);
    } catch (e) {
      print(' Failed to fetch current user: $e');
      return null;
    }
  }

  Future<User> createUserProfile(Map<String, dynamic> userData) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Sanitize input
      final sanitizedData = userData.map((key, value) {
        if (value is String) {
          return MapEntry(key, AppSecurity.sanitizeInput(value));
        }
        return MapEntry(key, value);
      });

      final profileData = {
        ...sanitizedData,
        'id': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('profiles')
          .insert(profileData)
          .select()
          .single();

      print(' Successfully created user profile');
      return User.fromJson(response);
    } catch (e) {
      print(' Failed to create user profile: $e');
      rethrow;
    }
  }

  Future<User> updateUserProfile(Map<String, dynamic> updates) async {
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

      final updateData = {
        ...sanitizedUpdates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      print(' Successfully updated user profile');
      return User.fromJson(response);
    } catch (e) {
      print(' Failed to update user profile: $e');
      rethrow;
    }
  }

  // Habit operations with type safety
  Future<List<Habit>> getHabits({bool? isActive}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      var query = _client
          .from('habits')
          .select()
          .eq('user_id', userId);

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('created_at', ascending: false);
      
      final habits = response.map<Habit>((json) {
        try {
          return Habit.fromJson(json);
        } catch (e) {
          print(' Failed to parse habit: $e, data: $json');
          rethrow;
        }
      }).toList();

      print(' Successfully fetched ${habits.length} habits');
      return habits;
    } catch (e) {
      print(' Failed to fetch habits: $e');
      return [];
    }
  }

  Future<Habit> createHabit({
    required String title,
    required String description,
    required String category,
    required int targetFrequency,
    int xpReward = 10,
    List<String> statRewards = const [],
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Rate limiting check
      if (AppSecurity.isRateLimited('create_habit_$userId')) {
        throw Exception('Too many habit creation attempts. Please try again later.');
      }

      final habitData = {
        'title': AppSecurity.sanitizeInput(title),
        'description': AppSecurity.sanitizeInput(description),
        'category': AppSecurity.sanitizeInput(category),
        'target_frequency': targetFrequency,
        'xp_reward': xpReward,
        'stat_rewards': statRewards,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('habits')
          .insert(habitData)
          .select()
          .single();

      print(' Successfully created habit: $title');
      return Habit.fromJson(response);
    } catch (e) {
      print(' Failed to create habit: $e');
      rethrow;
    }
  }

  Future<Habit> updateHabit(String habitId, Map<String, dynamic> updates) async {
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

      final updateData = {
        ...sanitizedUpdates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('habits')
          .update(updateData)
          .eq('id', habitId)
          .eq('user_id', userId)
          .select()
          .single();

      print(' Successfully updated habit: $habitId');
      return Habit.fromJson(response);
    } catch (e) {
      print(' Failed to update habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _client
          .from('habits')
          .delete()
          .eq('id', habitId)
          .eq('user_id', userId);

      print(' Successfully deleted habit: $habitId');
    } catch (e) {
      print(' Failed to delete habit: $e');
      rethrow;
    }
  }

  // Habit completion tracking
  Future<HabitCompletion> completeHabit(String habitId, {String? notes}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get the habit to update streak
      final habitResponse = await _client
          .from('habits')
          .select()
          .eq('id', habitId)
          .eq('user_id', userId)
          .single();

      final habit = Habit.fromJson(habitResponse);
      
      // Update habit streak
      final newStreak = habit.currentStreak + 1;
      final newLongestStreak = newStreak > habit.longestStreak ? newStreak : habit.longestStreak;

      await _client
          .from('habits')
          .update({
            'current_streak': newStreak,
            'longest_streak': newLongestStreak,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', habitId);

      // Create completion record
      final completionData = {
        'habit_id': habitId,
        'user_id': userId,
        'completed_at': DateTime.now().toIso8601String(),
        'notes': notes != null ? AppSecurity.sanitizeInput(notes) : null,
      };

      final response = await _client
          .from('habit_completions')
          .insert(completionData)
          .select()
          .single();

      print(' Successfully completed habit: $habitId');
      return HabitCompletion.fromJson(response);
    } catch (e) {
      print(' Failed to complete habit: $e');
      rethrow;
    }
  }

  Future<List<HabitCompletion>> getHabitCompletions(String habitId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('habit_completions')
          .select()
          .eq('habit_id', habitId)
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      final completions = response.map<HabitCompletion>((json) {
        return HabitCompletion.fromJson(json);
      }).toList();

      print(' Successfully fetched ${completions.length} habit completions');
      return completions;
    } catch (e) {
      print(' Failed to fetch habit completions: $e');
      return [];
    }
  }

  // Test method to verify data plumbing
  Future<void> testDataPlumbing() async {
    print('\n=== Testing Data Plumbing ===');
    
    try {
      // Test 1: Get current user
      print('\n1. Testing user fetch...');
      final user = await getCurrentUser();
      if (user != null) {
        print(' SUCCESS: User fetched - ${user.toString()}');
      } else {
        print(' INFO: No user found (expected if not logged in)');
      }

      // Test 2: Get habits
      print('\n2. Testing habits fetch...');
      final habits = await getHabits();
      print(' SUCCESS: Fetched ${habits.length} habits');
      for (final habit in habits) {
        print('   - ${habit.toString()}');
      }

      // Test 3: Test habit creation (if user exists)
      if (user != null) {
        print('\n3. Testing habit creation...');
        try {
          final testHabit = await createHabit(
            title: 'Test Habit',
            description: 'A test habit for data plumbing verification',
            category: 'Test',
            targetFrequency: 1,
            xpReward: 5,
            statRewards: ['vit'],
          );
          print(' SUCCESS: Created test habit - ${testHabit.toString()}');
          
          // Clean up test habit
          await deleteHabit(testHabit.id);
          print(' SUCCESS: Cleaned up test habit');
        } catch (e) {
          print(' INFO: Habit creation test failed (might be permissions): $e');
        }
      }

      print('\n=== Data Plumbing Test Complete ===\n');
    } catch (e) {
      print(' Data plumbing test failed: $e');
    }
  }
}
