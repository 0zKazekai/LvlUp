-- Fix duplicate trigger issue for profiles table
-- This migration ensures the handle_profiles_updated_at trigger is created idempotently

-- First, create the handle_updated_at function if it doesn't exist
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop the trigger if it exists, then create it (Option A - most common)
DROP TRIGGER IF EXISTS handle_profiles_updated_at ON profiles;

CREATE TRIGGER handle_profiles_updated_at
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();

-- Also ensure the trigger exists for other tables that have updated_at columns
DROP TRIGGER IF EXISTS handle_user_stats_updated_at ON user_stats;
CREATE TRIGGER handle_user_stats_updated_at
BEFORE UPDATE ON user_stats
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();

DROP TRIGGER IF EXISTS handle_user_quests_updated_at ON user_quests;
CREATE TRIGGER handle_user_quests_updated_at
BEFORE UPDATE ON user_quests
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();

DROP TRIGGER IF EXISTS handle_quests_updated_at ON quests;
CREATE TRIGGER handle_quests_updated_at
BEFORE UPDATE ON quests
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();

DROP TRIGGER IF EXISTS handle_habits_updated_at ON habits;
CREATE TRIGGER handle_habits_updated_at
BEFORE UPDATE ON habits
FOR EACH ROW
EXECUTE FUNCTION handle_updated_at();
