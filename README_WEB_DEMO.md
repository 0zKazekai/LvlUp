# LvlUp Web Demo Setup Guide

## ✅ Fixed Issues
- **Flutter SDK**: Updated to ^3.19.0 for compatibility
- **Dependencies**: All packages now compatible with latest Flutter
- **GitHub Actions**: Simplified workflow with better error handling

## 🚀 Next Steps

### 1. Add GitHub Secrets
Go to your repository: https://github.com/0zKazekai/LvlUp/settings/secrets/actions

Add these two secrets:

**SUPABASE_URL**
```
https://xarvugngdpriyaokqouu.supabase.co
```

**SUPABASE_ANON_KEY**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhcnZ1Z25nZHByaXlhb2txb3V1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1ODgyMjMsImV4cCI6MjA5MjE2NDIyM30.gVXYO1Myu9mPr9bb5a0j3m-7SHhCZWG-IaEB52xdBFU
```

### 2. Test the Build
1. Go to **Actions** tab in your GitHub repo
2. Click **"Build Web Demo (Simple)"** workflow
3. Click **"Run workflow"** button
4. Select **main** branch and click **"Run workflow"**

### 3. Expected Result
- ✅ Green checkmark in Actions
- 🌐 Web demo at: https://0zKazekai.github.io/LvlUp/
- 🔗 Connected to your Supabase database

## 🔧 Local Testing

To test locally:

```bash
# Install dependencies
flutter pub get

# Run with environment variables
flutter run --dart-define=FLUTTER_ENV=development
```

## 📱 What the Web Demo Includes

- **Full LvlUp app** with Supabase integration
- **Authentication** - Login/signup with persistent sessions
- **Dashboard** - Quest tracking, XP system, stats
- **All pages** - Feed, My Arc, Network, Profile
- **Dark RPG theme** with custom styling
- **Mobile responsive** design

## 🐛 Troubleshooting

**Build fails?**
- Check Actions tab for error messages
- Verify secrets are correctly named
- Ensure Flutter SDK is compatible

**Can't connect to Supabase?**
- Check if secrets are correctly copied
- Verify CORS settings in Supabase dashboard
- Check network tab in browser for errors

Your web demo should now build and deploy successfully! 🎉
