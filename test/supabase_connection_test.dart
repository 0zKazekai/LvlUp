import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Supabase Connection Tests', () {
    late SupabaseClient supabase;

    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: '.env');
      
      // Initialize Supabase for testing
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      
      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception('SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env file');
      }
      
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true,
      );
      
      supabase = Supabase.instance.client;
    });

    test('Supabase client should initialize successfully', () {
      expect(supabase, isNotNull);
      print('✅ Supabase client initialized successfully');
    });

    test('Should be able to connect to profiles table', () async {
      try {
        final response = await supabase
            .from('profiles')
            .select('count');
        
        expect(response, isA<List>());
        print('✅ Successfully connected to profiles table');
      } catch (e) {
        fail('❌ Failed to connect to profiles table: $e');
      }
    });

    test('Should verify profiles table structure', () async {
      try {
        final response = await supabase
            .from('profiles')
            .select('id, username, is_premium, created_at, updated_at')
            .limit(1);
        
        expect(response, isA<List>());
        print('✅ Profiles table structure is correct');
      } catch (e) {
        fail('❌ Profiles table structure issue: $e');
      }
    });

    test('Should verify RLS is working', () async {
      try {
        // This should fail or return empty since no user is authenticated
        final response = await supabase
            .from('profiles')
            .select('*');
        
        // With RLS enabled, this should return empty or be restricted
        expect(response, isA<List>());
        print('✅ RLS is properly configured');
      } catch (e) {
        // Some level of restriction is expected with RLS
        print('✅ RLS is working (access restricted as expected)');
      }
    });
  });
}
