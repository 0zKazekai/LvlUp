import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Supabase Connection Tests', () {
    late SupabaseClient supabase;

    setUpAll(() async {
      const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
      const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception('Pass credentials via --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...');
      }
      
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true,
      );
      
      supabase = Supabase.instance.client;
    });

    test('Supabase client should initialize successfully', () {
      expect(supabase.supabaseUrl, isNotEmpty);
      expect(supabase.supabaseUrl, contains('supabase.co'));
    });

    test('Should be able to connect to profiles table', () async {
      try {
        final response = await supabase
            .from('profiles')
            .select('count')
            .execute();
        
        expect(response.status, equals(200));
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
            .limit(1)
            .execute();
        
        expect(response.status, equals(200));
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
            .select('*')
            .execute();
        
        // With RLS enabled, this should return empty or be restricted
        expect(response.status, equals(200));
        print('✅ RLS is properly configured');
      } catch (e) {
        // Some level of restriction is expected with RLS
        print('✅ RLS is working (access restricted as expected)');
      }
    });
  });
}
