-- Migration: Expand profiles and create all game tables

-- =====================================================
-- PROFILES: Add missing game progression columns
-- =====================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS title TEXT NOT NULL DEFAULT 'Awakened',
  ADD COLUMN IF NOT EXISTS level INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS current_xp INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS xp_to_next_level INTEGER NOT NULL DEFAULT 100,
  ADD COLUMN IF NOT EXISTS str INTEGER NOT NULL DEFAULT 5,
  ADD COLUMN IF NOT EXISTS vit INTEGER NOT NULL DEFAULT 5,
  ADD COLUMN IF NOT EXISTS intel INTEGER NOT NULL DEFAULT 5,
  ADD COLUMN IF NOT EXISTS cha INTEGER NOT NULL DEFAULT 5,
  ADD COLUMN IF NOT EXISTS quests_completed INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS current_streak INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS longest_streak INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS arc_focus TEXT NOT NULL DEFAULT 'Balanced',
  ADD COLUMN IF NOT EXISTS achievements TEXT[] NOT NULL DEFAULT '{}';

-- =====================================================
-- QUESTS TABLE (user-created personal quests)
-- Must be created before user_quests FK can resolve
-- =====================================================
CREATE TABLE IF NOT EXISTS public.quests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    arc TEXT NOT NULL,
    rank TEXT NOT NULL DEFAULT 'C' CHECK (rank IN ('E', 'D', 'C', 'B', 'A', 'S')),
    xp_reward INTEGER NOT NULL DEFAULT 10,
    stat_rewards JSONB NOT NULL DEFAULT '{}',
    is_completed BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMPTZ,
    is_daily BOOLEAN NOT NULL DEFAULT false,
    available_until TIMESTAMPTZ,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'expired', 'failed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- USER_QUESTS: re-declare now that quests FK exists
-- (CREATE IF NOT EXISTS is safe if migration 001 already applied it)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.user_quests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    quest_id UUID REFERENCES public.quests(id) ON DELETE CASCADE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'failed')),
    progress INTEGER NOT NULL DEFAULT 0,
    max_progress INTEGER NOT NULL DEFAULT 1,
    proof_url TEXT,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, quest_id)
);

-- =====================================================
-- HABITS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.habits (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL,
    target_frequency INTEGER NOT NULL DEFAULT 1,
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    xp_reward INTEGER NOT NULL DEFAULT 10,
    stat_rewards TEXT[] NOT NULL DEFAULT '{}',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- HABIT_COMPLETIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.habit_completions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    habit_id UUID REFERENCES public.habits(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    proof_image_path TEXT
);

-- =====================================================
-- INDEXES
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_quests_user_id ON public.quests(user_id);
CREATE INDEX IF NOT EXISTS idx_quests_status ON public.quests(status);
CREATE INDEX IF NOT EXISTS idx_habits_user_id ON public.habits(user_id);
CREATE INDEX IF NOT EXISTS idx_habits_is_active ON public.habits(is_active);
CREATE INDEX IF NOT EXISTS idx_habit_completions_habit_id ON public.habit_completions(habit_id);
CREATE INDEX IF NOT EXISTS idx_habit_completions_user_id ON public.habit_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_quests_user_id ON public.user_quests(user_id);

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================
ALTER TABLE public.quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_completions ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "Users manage own quests" ON public.quests
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users manage own habits" ON public.habits
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users manage own habit completions" ON public.habit_completions
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- UPDATE new-user trigger to sync email + game defaults
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, username, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
        NEW.email
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
