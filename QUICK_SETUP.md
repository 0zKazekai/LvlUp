# Quick Setup Guide for LvlUp Web Demo

## Don't Worry! This is Normal

If you're seeing build failures, that's completely normal when setting up GitHub Actions for the first time. Let's fix this step by step.

## What's Happening

1. **Supabase GitHub Integration** you did is different from **GitHub Secrets**
2. **GitHub Actions** needs your Supabase credentials to build the web demo
3. **Free tier works perfectly** - you don't need the pro version

## Step 1: Get Your Supabase Credentials

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click on your project
3. Go to **Settings** (gear icon) on the left
4. Click on **API** in the submenu
5. You'll see three important values:

```
Project URL: https://your-project-id.supabase.co
anon public: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Step 2: Add GitHub Secrets (The Important Part)

1. Go to your GitHub repository: https://github.com/0zKazekai/LvlUp
2. Click **Settings** tab
3. Click **Secrets and variables** in the left sidebar
4. Click **Actions**
5. Click **New repository secret**

Add these secrets exactly:

### Secret 1: SUPABASE_URL
- **Name**: `SUPABASE_URL` (exactly this)
- **Secret**: `https://your-project-id.supabase.co` (your actual URL)

### Secret 2: SUPABASE_ANON_KEY
- **Name**: `SUPABASE_ANON_KEY` (exactly this)
- **Secret**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (your actual anon key)

## Step 3: Test the Build

1. Go to your repository's **Actions** tab
2. Click **Build Web Demo (Simple)** workflow
3. Click **Run workflow** button
4. Select **main** branch and click **Run workflow**

## Step 4: Check the Results

The build should:
1. Create environment file with your secrets
2. Build the web app
3. Deploy to GitHub Pages
4. Give you a URL like: https://0zKazekai.github.io/LvlUp/

## Common Issues & Fixes

### Issue: "SUPABASE_URL secret is missing!"
**Fix**: Make sure you added the secret with exactly the name `SUPABASE_URL`

### Issue: "SUPABASE_ANON_KEY secret is missing!"
**Fix**: Make sure you added the secret with exactly the name `SUPABASE_ANON_KEY`

### Issue: Build fails with Flutter errors
**Fix**: This is normal for first builds, try running the workflow again

## What About the Supabase GitHub Integration?

The Supabase GitHub integration you set up is for:
- Database backups
- Automatic schema migrations
- CI/CD integration (pro feature)

For our web demo, we just need the **GitHub Secrets** method above.

## Need Help?

If you're still stuck:

1. **Check the Actions tab** in your GitHub repo for specific error messages
2. **Take a screenshot** of the error and I can help you fix it
3. **Remember**: This is normal - first-time setup always has hiccups!

## Success Indicators

When it works, you'll see:
- Green checkmarks in the Actions workflow
- "Web demo deployed at: https://0zKazekai.github.io/LvlUp/"
- Your web demo live at that URL

## Next Steps

Once the build works:
1. Your web demo will be automatically updated when you push code
2. You can share the URL with others
3. The demo will connect to your Supabase database

You're doing great! This setup is tricky the first time but works perfectly once configured.
