# Testing Guide - LvlUp Habit Tracker

This guide helps you verify that both GitHub and Supabase are working properly.

## 🐙 GitHub Testing

### ✅ What's Already Working
- Repository is connected: `https://github.com/0zKazekai/LvlUp.git`
- Latest commit pushed successfully
- Database schema committed to repository

### 🧪 Manual Tests
1. **Visit your repository**: https://github.com/0zKazekai/LvlUp
2. **Verify files are present**:
   - `database/create_profiles_table.sql`
   - `lib/core/supabase_client.dart`
   - `.gitignore` (protecting sensitive files)
3. **Check recent commits** should show "Add database schema for profiles table with RLS policies"

## 🔧 Supabase Testing

### 📋 Prerequisites
1. Add your Supabase credentials to `.env`:
   ```
   SUPABASE_URL=your_actual_supabase_url
   SUPABASE_ANON_KEY=your_actual_supabase_anon_key
   ```

### 🗄️ Database Setup
1. **Run the SQL script**:
   - Go to your Supabase dashboard → SQL Editor
   - Copy contents from `database/create_profiles_table.sql`
   - Execute the script

2. **Verify table creation**:
   - Go to Table Editor → `profiles` table should exist
   - Check columns: `id`, `username`, `is_premium`, `created_at`, `updated_at`
   - Verify RLS is enabled on the table

### 📱 Flutter App Testing

#### 1. Connection Test
```bash
flutter run
```

#### 2. Manual Verification in App
- Launch the app
- Check console for Supabase connection errors
- Should see no errors if environment variables are correct

#### 3. Authentication Test (Optional)
```dart
// Add this to a test widget to verify Supabase connection
import 'package:supabase_flutter/supabase_flutter.dart';

// Test connection
final supabase = Supabase.instance.client;
print('Supabase URL: ${supabase.supabaseUrl}');
print('Connected: ${supabase.auth.currentUser != null}');
```

## 🔍 Troubleshooting Checklist

### GitHub Issues
- [ ] Repository URL is correct
- [ ] Push/pull commands work
- [ ] `.env` file is NOT in repository
- [ ] Build files are ignored

### Supabase Issues
- [ ] Environment variables are set in `.env`
- [ ] Supabase URL and Anon Key are correct
- [ ] SQL script executed successfully
- [ ] RLS policies are enabled
- [ ] App connects without errors

### Flutter Issues
- [ ] `flutter pub get` completed successfully
- [ ] App launches without crashes
- [ ] No Supabase connection errors in console

## 🎯 Success Indicators

### ✅ GitHub Working
- Repository accessible at the URL
- All files present and correct
- Recent commits visible
- No sensitive files committed

### ✅ Supabase Working
- Profiles table exists with correct schema
- RLS policies enabled
- App connects successfully
- No authentication errors

### ✅ Integration Working
- App launches without errors
- Supabase client initializes properly
- Environment variables loaded correctly
- Ready for user authentication features

## 📞 Next Steps

Once everything is verified:
1. Start building authentication features
2. Create user registration/login flows
3. Implement profile management
4. Add habit tracking functionality

---

**Need Help?** Check the console output when running `flutter run` for detailed error messages.
