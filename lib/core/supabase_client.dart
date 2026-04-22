import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client initialization and configuration
class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;

  // Private constructor for singleton pattern
  SupabaseService._internal() {
    _client = Supabase.instance.client;
  }

  /// Get the singleton instance
  factory SupabaseService() {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  /// Initialize Supabase with compile-time dart-define constants
  static Future<void> initialize() async {
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'Supabase credentials not provided.\n'
        'Run with: flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }

  /// Get the Supabase client instance
  SupabaseClient get client => _client;

  /// Get the auth service
  GoTrueClient get auth => _client.auth;

  /// Get database service
  SupabaseQueryBuilder Function(String table) get from => _client.from;

  /// Get the storage service
  SupabaseStorageClient get storage => _client.storage;

  /// Get the realtime service
  RealtimeClient get realtime => _client.realtime;

  /// Get the functions service
  FunctionsClient get functions => _client.functions;
}
