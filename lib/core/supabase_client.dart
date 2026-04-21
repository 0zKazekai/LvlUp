import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client initialization and configuration
class SupabaseClient {
  static SupabaseClient? _instance;
  late final SupabaseClient _client;

  // Private constructor for singleton pattern
  SupabaseClient._internal() {
    _client = Supabase.instance.client;
  }

  /// Get the singleton instance
  factory SupabaseClient() {
    _instance ??= SupabaseClient._internal();
    return _instance!;
  }

  /// Initialize Supabase with environment variables
  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'Supabase URL and Anon Key must be set in .env file\n'
        'Please add your Supabase credentials to the .env file:\n'
        'SUPABASE_URL=your_supabase_url_here\n'
        'SUPABASE_ANON_KEY=your_supabase_anon_key_here',
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Set to false in production
    );
  }

  /// Get the Supabase client instance
  SupabaseClient get client => _client;

  /// Get the auth service
  SupabaseAuth get auth => _client.auth;

  /// Get the database service
  SupabaseQueryBuilder get from => _client.from;

  /// Get the storage service
  SupabaseStorageClient get storage => _client.storage;

  /// Get the realtime service
  SupabaseRealtimeClient get realtime => _client.realtime;

  /// Get the functions service
  SupabaseFunctions get functions => _client.functions;
}
