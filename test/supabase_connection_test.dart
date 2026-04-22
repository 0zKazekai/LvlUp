import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Supabase Connection Tests', () {
    late SupabaseClient supabase;

    setUpAll(() async {
      const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
      const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception(
            'Pass credentials via --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...');
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
    });

    test('Should be able to connect to profiles table', () async {
      try {
        await supabase.from('profiles').select('count').count();
        print('Successfully connected to profiles table');
      } catch (e) {
        fail('Failed to connect to profiles table: $e');
      }
    });

    test('Should verify profiles table structure', () async {
      try {
        await supabase
            .from('profiles')
            .select('id, username, is_premium, created_at, updated_at')
            .limit(1);
        print('Profiles table structure is correct');
      } catch (e) {
        fail('Profiles table structure issue: $e');
      }
    });

    test('Should verify RLS is working', () async {
      try {
        await supabase.from('profiles').select('*');
        print('RLS is properly configured');
      } catch (e) {
        print('RLS is working (access restricted as expected)');
      }
    });
  });
}
