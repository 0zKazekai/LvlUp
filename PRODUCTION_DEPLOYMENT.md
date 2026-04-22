# LvlUp App - Production Deployment Guide

## Immediate Actions Required

### 1. Fix GitHub Authentication
```bash
# Option 1: Use GitHub CLI (Recommended)
gh auth login

# Option 2: Use Personal Access Token
# 1. Go to https://github.com/settings/tokens
# 2. Generate new token with 'repo' scope
# 3. Set remote URL with token
git remote set-url origin https://YOUR_TOKEN@github.com/0zKazekai/LvlUp.git

# Push changes
git push origin master
```

### 2. Environment Setup
```bash
# Copy environment template
cp .env.example .env

# Fill in your actual values
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_ANON_KEY=your_anon_key
# etc.
```

## Production Security Checklist

### Supabase Security
- [ ] Enable Row Level Security (RLS) on all tables
- [ ] Set up authentication providers (Google, Apple, etc.)
- [ ] Configure database backups (daily + weekly)
- [ ] Set up monitoring and alerts
- [ ] Enable edge functions for server-side logic
- [ ] Set up rate limiting in Supabase dashboard

### App Security
- [ ] Add `flutter_secure_storage` to pubspec.yaml
- [ ] Implement secure token storage
- [ ] Add input validation and sanitization
- [ ] Set up API rate limiting
- [ ] Enable certificate pinning
- [ ] Add biometric authentication

### Database Schema Updates
```sql
-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE proof_posts ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Add indexes for performance
CREATE INDEX idx_profiles_user_id ON profiles(id);
CREATE INDEX idx_quests_user_id ON quests(user_id);
CREATE INDEX idx_quests_status ON quests(status);
```

## App Store Deployment

### iOS App Store
1. **App Store Connect Setup**
   - Create app listing
   - Set up bundle identifier: `com.yourcompany.lvlup`
   - Configure app icons (1024x1024)
   - Add screenshots (iPhone 6.7", 6.5", 5.5")

2. **Build Configuration**
   ```bash
   # Create production build
   flutter build ios --release
   ```

3. **Required Info**
   - Privacy Policy URL
   - Support URL
   - Marketing URL
   - App category: Health & Fitness

### Android Google Play
1. **Play Console Setup**
   - Create app listing
   - Set up package name: `com.yourcompany.lvlup`
   - Upload app bundle
   - Add screenshots (phone, tablet)

2. **Build Configuration**
   ```bash
   # Create production build
   flutter build appbundle --release
   ```

## Monitoring & Analytics

### Firebase Setup
1. Create Firebase project
2. Add Firebase SDK
3. Enable Analytics
4. Set up Crashlytics
5. Configure Performance Monitoring

### Sentry (Optional)
1. Create Sentry project
2. Add Sentry SDK
3. Configure error reporting
4. Set up performance monitoring

## CI/CD Pipeline

### GitHub Actions
Create `.github/workflows/deploy.yml`:
```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test
      
  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release
      
  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
```

## Scalability Considerations

### Database Optimization
- [ ] Implement connection pooling
- [ ] Add database indexes
- [ ] Set up read replicas
- [ ] Configure caching strategy

### Performance
- [ ] Implement lazy loading
- [ ] Add image optimization
- [ ] Set up CDN for static assets
- [ ] Optimize app bundle size

### Infrastructure
- [ ] Set up auto-scaling
- [ ] Configure load balancing
- [ ] Implement health checks
- [ ] Set up monitoring dashboards

## Legal & Compliance

### Required Documents
- [ ] Privacy Policy
- [ ] Terms of Service
- [ ] Cookie Policy (if applicable)
- [ ] GDPR compliance (EU users)

### App Store Requirements
- [ ] Age ratings
- [ ] Content guidelines compliance
- [ ] Metadata optimization
- [ ] Localization (if targeting multiple regions)

## Launch Checklist

### Pre-Launch
- [ ] Complete beta testing
- [ ] Fix all critical bugs
- [ ] Optimize performance
- [ ] Test on all target devices
- [ ] Set up customer support

### Launch Day
- [ ] Submit to app stores
- [ ] Monitor deployment
- [ ] Set up analytics tracking
- [ ] Prepare marketing materials

### Post-Launch
- [ ] Monitor crash reports
- [ ] Track user metrics
- [ ] Gather user feedback
- [ ] Plan next features

## Emergency Procedures

### Rollback Plan
1. Keep previous version available
2. Quick rollback mechanism
3. User communication plan

### Incident Response
1. Monitoring alerts setup
2. Response team contacts
3. Communication templates
4. Post-mortem process
