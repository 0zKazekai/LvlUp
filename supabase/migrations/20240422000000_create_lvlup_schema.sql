-- LvlUp RPG Habit Tracker Database Schema
-- Migration: Create initial tables for users, quests, achievements, and user stats

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create user profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    display_name TEXT,
    avatar_url TEXT,
    level INTEGER DEFAULT 1,
    xp INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user stats table
CREATE TABLE IF NOT EXISTS user_stats (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    stat_type TEXT NOT NULL CHECK (stat_type IN ('strength', 'vitality', 'intelligence', 'charisma')),
    value INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, stat_type)
);

-- Create quests table
CREATE TABLE IF NOT EXISTS quests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'legendary')),
    category TEXT NOT NULL,
    xp_reward INTEGER NOT NULL DEFAULT 0,
    stat_rewards JSONB DEFAULT '{}',
    is_daily BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user quests table (user's quest progress)
CREATE TABLE IF NOT EXISTS user_quests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    quest_id UUID REFERENCES quests(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'failed')),
    progress INTEGER DEFAULT 0,
    max_progress INTEGER DEFAULT 1,
    proof_url TEXT,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, quest_id)
);

-- Create achievements table
CREATE TABLE IF NOT EXISTS achievements (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    requirement_type TEXT NOT NULL,
    requirement_value INTEGER NOT NULL,
    reward_xp INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user achievements table
CREATE TABLE IF NOT EXISTS user_achievements (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    achievement_id UUID REFERENCES achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

-- Create feed table for social features
CREATE TABLE IF NOT EXISTS feed (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    feed_type TEXT NOT NULL CHECK (feed_type IN ('quest_completed', 'achievement_unlocked', 'level_up', 'stat_increase')),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles(username);
CREATE INDEX IF NOT EXISTS idx_user_stats_user_id ON user_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_user_stats_type ON user_stats(stat_type);
CREATE INDEX IF NOT EXISTS idx_quests_difficulty ON quests(difficulty);
CREATE INDEX IF NOT EXISTS idx_quests_category ON quests(category);
CREATE INDEX IF NOT EXISTS idx_user_quests_user_id ON user_quests(user_id);
CREATE INDEX IF NOT EXISTS idx_user_quests_status ON user_quests(status);
CREATE INDEX IF NOT EXISTS idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_feed_user_id ON feed(user_id);
CREATE INDEX IF NOT EXISTS idx_feed_created_at ON feed(created_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_stats_updated_at BEFORE UPDATE ON user_stats
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quests_updated_at BEFORE UPDATE ON quests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_quests_updated_at BEFORE UPDATE ON user_quests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own stats" ON user_stats
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own stats" ON user_stats
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view all quests" ON quests
    FOR SELECT USING (is_active = true);

CREATE POLICY "Users can manage own quests" ON user_quests
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view own achievements" ON user_achievements
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can view own feed" ON feed
    FOR SELECT USING (auth.uid() = user_id);

-- Insert sample data
INSERT INTO achievements (title, description, icon, requirement_type, requirement_value, reward_xp) VALUES
('First Steps', 'Complete your first quest', 'footprints', 'quests_completed', 1, 50),
('Rising Star', 'Reach level 5', 'star', 'level', 5, 100),
('Quest Master', 'Complete 10 quests', 'trophy', 'quests_completed', 10, 200),
('Daily Champion', 'Complete 5 daily quests', 'calendar', 'daily_quests_completed', 5, 150),
('Stat Enthusiast', 'Increase any stat to 10', 'chart', 'stat_max', 10, 75);

INSERT INTO quests (title, description, difficulty, category, xp_reward, stat_rewards, is_daily) VALUES
('Morning Meditation', 'Meditate for 10 minutes', 'easy', 'mindfulness', 25, '{"intelligence": 1}', true),
('Exercise Session', 'Complete a 30-minute workout', 'medium', 'fitness', 50, '{"strength": 1, "vitality": 1}', true),
('Read a Book', 'Read for at least 30 minutes', 'easy', 'learning', 30, '{"intelligence": 2}', true),
('Social Connection', 'Call or meet with a friend', 'medium', 'social', 40, '{"charisma": 2}', true),
('Healthy Meal', 'Prepare and eat a nutritious meal', 'easy', 'health', 20, '{"vitality": 1}', true),
('Learn Something New', 'Study a new skill for 1 hour', 'hard', 'learning', 75, '{"intelligence": 3}', false),
('Complete a Project', 'Finish a personal project', 'legendary', 'productivity', 200, '{"intelligence": 2, "charisma": 1}', false);

-- Create function to handle user level ups
CREATE OR REPLACE FUNCTION handle_level_up()
RETURNS TRIGGER AS $$
DECLARE
    current_level INTEGER;
    xp_for_next_level INTEGER;
BEGIN
    -- Get current level
    SELECT level INTO current_level FROM profiles WHERE id = NEW.user_id;
    
    -- Calculate XP needed for next level (simple formula: level * 100)
    xp_for_next_level := current_level * 100;
    
    -- Check if user leveled up
    IF NEW.xp >= xp_for_next_level THEN
        -- Update user level
        UPDATE profiles 
        SET level = current_level + 1 
        WHERE id = NEW.user_id;
        
        -- Add level up to feed
        INSERT INTO feed (user_id, content, feed_type, metadata)
        VALUES (NEW.user_id, 'Leveled up to ' || (current_level + 1) || '!', 'level_up', json_build_object('new_level', current_level + 1));
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for level ups
CREATE TRIGGER on_user_quest_complete_level_up
    AFTER UPDATE ON user_quests
    FOR EACH ROW
    WHEN (OLD.status != 'completed' AND NEW.status = 'completed')
    EXECUTE FUNCTION handle_level_up();
