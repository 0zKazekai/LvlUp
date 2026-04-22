# GitHub Secrets Configuration for LvlUp Web Demo

This guide explains how to configure GitHub Secrets for automated web deployment with Supabase integration.

## Required GitHub Secrets

Navigate to your GitHub repository: **Settings** > **Secrets and variables** > **Actions**

### 1. Supabase Configuration (Required)

#### `SUPABASE_URL`
- **Description**: Your Supabase project URL
- **How to get**: Go to Supabase Dashboard > Settings > API > Project URL
- **Example**: `https://your-project.supabase.co`

#### `SUPABASE_ANON_KEY`
- **Description**: Your Supabase anonymous/public key
- **How to get**: Go to Supabase Dashboard > Settings > API > anon public
- **Example**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

#### `SUPABASE_SERVICE_KEY`
- **Description**: Your Supabase service role key (for server operations)
- **How to get**: Go to Supabase Dashboard > Settings > API > service_role
- **Example**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### 2. Optional Analytics & Monitoring

#### `FIREBASE_ANALYTICS_API_KEY`
- **Description**: Firebase Analytics API key (optional)
- **How to get**: Firebase Console > Project Settings > General > Your apps > Web API Key

#### `SENTRY_DSN`
- **Description**: Sentry error tracking DSN (optional)
- **How to get**: Sentry Project Settings > Client Keys (DSN)

### 3. Deployment Services (Optional)

#### `GITHUB_TOKEN`
- **Description**: GitHub token for GitHub Pages deployment
- **How to get**: Automatically provided by GitHub Actions (no setup needed)

#### `NETLIFY_AUTH_TOKEN`
- **Description**: Netlify authentication token (for Netlify deployment)
- **How to get**: Netlify Dashboard > Settings > Site settings > Build & deploy > API access

#### `NETLIFY_SITE_ID`
- **Description**: Netlify site ID (for Netlify deployment)
- **How to get**: Netlify Dashboard > Site settings > Site details > Site ID

## Step-by-Step Setup

### 1. Get Supabase Credentials

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project or create a new one
3. Go to **Settings** > **API**
4. Copy the following values:
   - **Project URL** (for `SUPABASE_URL`)
   - **anon public** key (for `SUPABASE_ANON_KEY`)
   - **service_role** key (for `SUPABASE_SERVICE_KEY`)

### 2. Configure GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** tab
3. Click **Secrets and variables** in the left sidebar
4. Click **Actions**
5. Click **New repository secret**
6. Add each secret with the exact name and value

### 3. Enable GitHub Pages (if using GitHub Pages)

1. Go to repository **Settings**
2. Click **Pages** in the left sidebar
3. Under "Build and deployment", select **GitHub Actions** as the source
4. Save the settings

### 4. Configure Supabase for Web Access

1. In Supabase Dashboard, go to **Authentication** > **Settings**
2. Add your GitHub Pages URL to **Site URL**:
   - `https://yourusername.github.io/LvlUp/`
3. In **Authentication** > **Providers**, enable **Email** provider
4. In **Database** > **Replication**, enable **Realtime** for live updates
5. In **Database** > **RLS Policies**, ensure policies allow web access

## Security Considerations

### Environment Variables
The GitHub Action creates a `.env` file during build with your secrets:
```bash
SUPABASE_URL=${{ secrets.SUPABASE_URL }}
SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
SUPABASE_SERVICE_KEY=${{ secrets.SUPABASE_SERVICE_KEY }}
```

### Best Practices
1. **Never commit secrets to your repository**
2. **Use different keys for development and production**
3. **Rotate keys regularly** (especially if compromised)
4. **Monitor usage** in Supabase Dashboard
5. **Enable Row Level Security (RLS)** on all tables

### Row Level Security Example
```sql
-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE habits ENABLE ROW LEVEL SECURITY;

-- Allow users to access their own data
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own habits" ON habits
  FOR SELECT USING (auth.uid() = user_id);
```

## Deployment Process

### Automatic Triggers
The workflow automatically triggers on:
- Push to `main` or `master` branch
- Pull requests to `main` or `master`
- Manual workflow dispatch

### Build Process
1. **Environment Setup**: Creates `.env` file with secrets
2. **Dependencies**: Runs `flutter pub get`
3. **Tests**: Executes `flutter test`
4. **Build**: Creates optimized web build with CanvasKit
5. **Optimization**: Compresses assets and generates service worker
6. **Deployment**: Publishes to GitHub Pages and/or Netlify

### Build Optimizations
- **CanvasKit Renderer**: Better performance for complex UI
- **Asset Compression**: Reduces bundle size
- **Service Worker**: Enables offline functionality
- **Resource Preloading**: Faster initial load

## Troubleshooting

### Common Issues

#### 1. "Supabase credentials missing" Error
**Cause**: GitHub Secrets not properly configured
**Solution**: Verify all required secrets are set with exact names

#### 2. CORS Errors
**Cause**: Supabase not configured for web access
**Solution**: Add your GitHub Pages URL to Supabase Site URL settings

#### 3. Authentication Issues
**Cause**: RLS policies blocking access
**Solution**: Check and update Row Level Security policies

#### 4. Build Failures
**Cause**: Dependencies or configuration issues
**Solution**: Check Actions logs for specific error messages

### Debugging Steps

1. **Check GitHub Actions logs** for detailed error messages
2. **Verify environment variables** in the build output
3. **Test locally** with the same `.env` configuration
4. **Check Supabase logs** for connection attempts

## Environment-Specific Configurations

### Development
```bash
# For local development
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your_local_key
APP_ENV=development
```

### Production
```bash
# For web deployment
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_production_key
APP_ENV=production
```

## Monitoring and Maintenance

### What to Monitor
- **GitHub Actions build status**
- **Supabase API usage and errors**
- **Web app performance and errors**
- **User authentication success rates**

### Regular Maintenance
- **Rotate API keys** every 3-6 months
- **Update dependencies** regularly
- **Monitor build times** and optimize if needed
- **Review security policies** quarterly

## Support

If you encounter issues:

1. **Check the GitHub Actions logs** in the Actions tab
2. **Verify Supabase configuration** in the dashboard
3. **Review this documentation** for setup instructions
4. **Check the build logs** for specific error messages

For additional help, create an issue in the repository with:
- Build logs (if applicable)
- Error messages
- Steps to reproduce
- Environment details (browser, OS, etc.)
