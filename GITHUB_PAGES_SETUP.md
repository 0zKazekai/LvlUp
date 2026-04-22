# GitHub Pages Setup Instructions

## CRITICAL STEP - MUST DO THIS FIRST

### 1. Enable GitHub Pages in Repository Settings

1. Go to your repository: https://github.com/0zKazekai/LvlUp
2. Click **Settings** tab
3. Scroll down to **Pages** section in left sidebar
4. Under "Build and deployment", select **GitHub Actions** as the source
5. Click **Save**

### 2. Check Workflow Permissions

1. Go to **Settings** > **Actions** > **General**
2. Under "Workflow permissions", select **Read and write permissions**
3. Check **Allow GitHub Actions to create and approve pull requests**
4. Click **Save**

### 3. Run the Workflow

1. Go to **Actions** tab
2. Click **"Deploy MVP"** workflow
3. Click **"Run workflow"** button
4. Select **main** branch and click **"Run workflow"**

### 4. Expected Result

After successful deployment:
- Green checkmarks in workflow
- GitHub Pages URL: https://0zKazekai.github.io/LvlUp/
- Shows LvlUp MVP with "STATUS: MVP WORKING"

## TROUBLESHOOTING

### If workflow still fails:
1. Check the specific error message in Actions
2. Make sure GitHub Pages is enabled in Settings
3. Verify workflow permissions are correct

### If still no website:
1. Wait 5-10 minutes after deployment
2. Check GitHub Pages section in Settings for deployment status
3. Clear browser cache and try the URL again

## MOST COMMON ISSUES

1. **GitHub Pages not enabled** - Must enable in Settings first
2. **Workflow permissions** - Need Read and write permissions
3. **Deployment time** - Can take 5-10 minutes to appear

DO THESE STEPS IN ORDER!
