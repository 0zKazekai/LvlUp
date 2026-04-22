# Supabase Database Setup Guide

## Quick Setup Instructions

### 1. Install Supabase CLI
```bash
# Install via npm (recommended)
npm install -g supabase

# Or download from https://supabase.com/docs/reference/cli
```

### 2. Link Your Project
```bash
supabase link --project-ref xarvugngdpriyaokqouu
```

### 3. Run Migration
```bash
supabase db push
```

## What the Migration Creates

### Database Tables:
- **profiles** - User profiles with level, XP, username
- **user_stats** - Strength, Vitality, Intelligence, Charisma stats
- **quests** - Available quests with difficulty and rewards
- **user_quests** - User's quest progress and completion
- **achievements** - Achievement definitions
- **user_achievements** - User's unlocked achievements
- **feed** - Social feed for quest completions and level ups

### Features:
- **Row Level Security (RLS)** - Users can only access their own data
- **Automatic Level Ups** - Trigger that levels users when they gain enough XP
- **Sample Data** - Pre-populated quests and achievements
- **Indexes** - Optimized for performance

### Sample Quests Included:
- Morning Meditation (Easy, 25 XP)
- Exercise Session (Medium, 50 XP)
- Read a Book (Easy, 30 XP)
- Social Connection (Medium, 40 XP)
- Healthy Meal (Easy, 20 XP)
- Learn Something New (Hard, 75 XP)
- Complete a Project (Legendary, 200 XP)

### Sample Achievements:
- First Steps - Complete your first quest
- Rising Star - Reach level 5
- Quest Master - Complete 10 quests
- Daily Champion - Complete 5 daily quests
- Stat Enthusiast - Increase any stat to 10

## After Setup

Once you run the migration, your LvlUp app will have:
- Full database schema
- User authentication integration
- Quest tracking system
- Achievement system
- Social feed functionality
- Automatic level progression

## Testing the App

After migration setup:
1. Add your Supabase credentials to GitHub Secrets
2. Run the deployment workflow
3. Test the complete app with database functionality

The app will automatically create user profiles when users sign up and handle all database operations through the Supabase client.
