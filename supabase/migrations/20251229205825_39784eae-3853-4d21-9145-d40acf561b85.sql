-- =============================================
-- ENUMS
-- =============================================

CREATE TYPE public.app_role AS ENUM ('admin', 'moderator', 'user');
CREATE TYPE public.subscription_plan AS ENUM ('globo', 'volea', 'bandeja', 'smash');
CREATE TYPE public.subscription_status AS ENUM ('activa', 'cancelada', 'vencida', 'pago_fallido');
CREATE TYPE public.email_audience_type AS ENUM ('single', 'selected', 'filtered');
CREATE TYPE public.email_body_format AS ENUM ('markdown', 'html');
CREATE TYPE public.email_campaign_status AS ENUM ('draft', 'queued', 'sending', 'sent', 'failed');
CREATE TYPE public.email_message_status AS ENUM ('queued', 'sent', 'failed', 'skipped_opt_out');

-- =============================================
-- TABLES
-- =============================================

-- Profiles table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  weekly_goal INTEGER DEFAULT 3,
  aptitudes JSONB DEFAULT '{"fuerza": 0, "potencia": 0, "agilidad": 0, "flexibilidad": 0, "resistencia": 0, "coordinacion": 0}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- User Roles table (for admin system)
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role public.app_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, role)
);

-- Subscriptions table
CREATE TABLE public.subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  plan public.subscription_plan NOT NULL DEFAULT 'globo',
  status public.subscription_status NOT NULL DEFAULT 'activa',
  starts_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ,
  canceled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Professionals table
CREATE TABLE public.professionals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  specialty TEXT,
  bio TEXT,
  avatar_url TEXT,
  price_per_session NUMERIC(10,2),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Exercises table
CREATE TABLE public.exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  video_url TEXT,
  thumbnail_url TEXT,
  implementos TEXT[] DEFAULT '{}',
  muscle_groups TEXT[] DEFAULT '{}',
  difficulty INTEGER DEFAULT 1 CHECK (difficulty >= 1 AND difficulty <= 5),
  instructions TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Routines table
CREATE TABLE public.routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  difficulty INTEGER DEFAULT 1 CHECK (difficulty >= 1 AND difficulty <= 5),
  duration_minutes INTEGER,
  cover_image_url TEXT,
  objectives JSONB DEFAULT '{"fuerza": 0, "potencia": 0, "agilidad": 0, "flexibilidad": 0, "resistencia": 0, "coordinacion": 0}'::jsonb,
  is_published BOOLEAN DEFAULT false,
  is_program BOOLEAN DEFAULT false,
  professional_id UUID REFERENCES public.professionals(id) ON DELETE SET NULL,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Routine Blocks table
CREATE TABLE public.routine_blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0,
  repetitions INTEGER DEFAULT 1,
  rest_between_exercises INTEGER DEFAULT 30,
  rest_between_series INTEGER DEFAULT 60,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Block Exercises table
CREATE TABLE public.block_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_id UUID REFERENCES public.routine_blocks(id) ON DELETE CASCADE NOT NULL,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0,
  execution_type TEXT DEFAULT 'time' CHECK (execution_type IN ('time', 'reps')),
  duration_seconds INTEGER,
  repetitions INTEGER,
  rest_override INTEGER,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Program Weeks table
CREATE TABLE public.program_weeks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  week_number INTEGER NOT NULL,
  name TEXT,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (program_id, week_number)
);

-- Program Week Routines table
CREATE TABLE public.program_week_routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  week_id UUID REFERENCES public.program_weeks(id) ON DELETE CASCADE NOT NULL,
  routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  order_index INTEGER NOT NULL DEFAULT 0,
  custom_name TEXT,
  custom_description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- User Programs table
CREATE TABLE public.user_programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  program_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  current_week INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  enrolled_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, program_id)
);

-- Scheduled Routines table
CREATE TABLE public.scheduled_routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  scheduled_date DATE NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- User Events table
CREATE TABLE public.user_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  event_type TEXT NOT NULL,
  routine_id UUID REFERENCES public.routines(id) ON DELETE SET NULL,
  program_id UUID REFERENCES public.routines(id) ON DELETE SET NULL,
  event_date DATE NOT NULL,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- User Favorites table
CREATE TABLE public.user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, routine_id)
);

-- Professional Availability table
CREATE TABLE public.professional_availability (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Availability Settings table
CREATE TABLE public.availability_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL UNIQUE,
  session_duration INTEGER DEFAULT 60,
  buffer_before INTEGER DEFAULT 0,
  buffer_after INTEGER DEFAULT 15,
  max_daily_sessions INTEGER DEFAULT 8,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Availability Exceptions table
CREATE TABLE public.availability_exceptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
  exception_date DATE NOT NULL,
  is_available BOOLEAN DEFAULT false,
  start_time TIME,
  end_time TIME,
  reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Appointments table
CREATE TABLE public.appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
  scheduled_at TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 60,
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show')),
  notes TEXT,
  canceled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Support Tickets table
CREATE TABLE public.support_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  admin_response TEXT,
  responded_at TIMESTAMPTZ,
  responded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Email Campaigns table
CREATE TABLE public.email_campaigns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID REFERENCES public.professionals(id) ON DELETE SET NULL,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  body_format public.email_body_format DEFAULT 'markdown',
  audience_type public.email_audience_type NOT NULL,
  audience_filter JSONB,
  status public.email_campaign_status DEFAULT 'draft',
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  total_recipients INTEGER DEFAULT 0,
  sent_count INTEGER DEFAULT 0,
  failed_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Email Messages table
CREATE TABLE public.email_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id UUID REFERENCES public.email_campaigns(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  email TEXT NOT NULL,
  status public.email_message_status DEFAULT 'queued',
  sent_at TIMESTAMPTZ,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- User Email Preferences table
CREATE TABLE public.user_email_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  marketing_emails BOOLEAN DEFAULT true,
  workout_reminders BOOLEAN DEFAULT true,
  appointment_reminders BOOLEAN DEFAULT true,
  newsletter BOOLEAN DEFAULT true,
  unsubscribed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================
-- INDEXES
-- =============================================

CREATE INDEX idx_profiles_email ON public.profiles(email);
CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions(status);
CREATE INDEX idx_routines_category ON public.routines(category);
CREATE INDEX idx_routines_is_published ON public.routines(is_published);
CREATE INDEX idx_routine_blocks_routine_id ON public.routine_blocks(routine_id);
CREATE INDEX idx_block_exercises_block_id ON public.block_exercises(block_id);
CREATE INDEX idx_scheduled_routines_user_date ON public.scheduled_routines(user_id, scheduled_date);
CREATE INDEX idx_user_events_user_date ON public.user_events(user_id, event_date);
CREATE INDEX idx_user_favorites_user_id ON public.user_favorites(user_id);
CREATE INDEX idx_appointments_user_id ON public.appointments(user_id);
CREATE INDEX idx_appointments_professional_id ON public.appointments(professional_id);
CREATE INDEX idx_appointments_scheduled_at ON public.appointments(scheduled_at);
CREATE INDEX idx_support_tickets_user_id ON public.support_tickets(user_id);
CREATE INDEX idx_support_tickets_status ON public.support_tickets(status);
CREATE INDEX idx_email_messages_campaign_id ON public.email_messages(campaign_id);

-- =============================================
-- ENABLE RLS ON ALL TABLES
-- =============================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professionals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routine_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.block_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.program_weeks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.program_week_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scheduled_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professional_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.availability_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.availability_exceptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_email_preferences ENABLE ROW LEVEL SECURITY;

-- =============================================
-- SECURITY DEFINER FUNCTIONS
-- =============================================

-- Check if user has a specific role
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role public.app_role)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id
      AND role = _role
  )
$$;

-- Check if user has valid subscription
CREATE OR REPLACE FUNCTION public.has_valid_subscription(_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.subscriptions
    WHERE user_id = _user_id
      AND status = 'activa'
      AND (expires_at IS NULL OR expires_at > now())
  )
$$;

-- Renew subscription
CREATE OR REPLACE FUNCTION public.renew_subscription(_user_id UUID)
RETURNS public.subscriptions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result public.subscriptions;
BEGIN
  UPDATE public.subscriptions
  SET status = 'activa',
      expires_at = now() + interval '1 month',
      updated_at = now()
  WHERE user_id = _user_id
  RETURNING * INTO result;
  RETURN result;
END;
$$;

-- Cancel subscription
CREATE OR REPLACE FUNCTION public.cancel_subscription(_user_id UUID)
RETURNS public.subscriptions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result public.subscriptions;
BEGIN
  UPDATE public.subscriptions
  SET status = 'cancelada',
      canceled_at = now(),
      updated_at = now()
  WHERE user_id = _user_id
  RETURNING * INTO result;
  RETURN result;
END;
$$;

-- Mark subscription as past due
CREATE OR REPLACE FUNCTION public.mark_subscription_past_due(_user_id UUID)
RETURNS public.subscriptions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result public.subscriptions;
BEGIN
  UPDATE public.subscriptions
  SET status = 'pago_fallido',
      updated_at = now()
  WHERE user_id = _user_id
  RETURNING * INTO result;
  RETURN result;
END;
$$;

-- Expire old subscriptions
CREATE OR REPLACE FUNCTION public.expire_old_subscriptions()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.subscriptions
  SET status = 'vencida',
      updated_at = now()
  WHERE status = 'activa'
    AND expires_at IS NOT NULL
    AND expires_at < now();
END;
$$;

-- Handle new user (create profile automatically)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.raw_user_meta_data ->> 'name', '')
  );
  
  -- Create default subscription
  INSERT INTO public.subscriptions (user_id, plan, status)
  VALUES (NEW.id, 'globo', 'activa');
  
  -- Create default email preferences
  INSERT INTO public.user_email_preferences (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$;

-- Update updated_at column
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- =============================================
-- TRIGGERS
-- =============================================

-- Trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Updated_at triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_professionals_updated_at BEFORE UPDATE ON public.professionals FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON public.exercises FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_routines_updated_at BEFORE UPDATE ON public.routines FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_routine_blocks_updated_at BEFORE UPDATE ON public.routine_blocks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_block_exercises_updated_at BEFORE UPDATE ON public.block_exercises FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_program_weeks_updated_at BEFORE UPDATE ON public.program_weeks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_program_week_routines_updated_at BEFORE UPDATE ON public.program_week_routines FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_programs_updated_at BEFORE UPDATE ON public.user_programs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_scheduled_routines_updated_at BEFORE UPDATE ON public.scheduled_routines FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_professional_availability_updated_at BEFORE UPDATE ON public.professional_availability FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_availability_settings_updated_at BEFORE UPDATE ON public.availability_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_availability_exceptions_updated_at BEFORE UPDATE ON public.availability_exceptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON public.appointments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON public.support_tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_email_campaigns_updated_at BEFORE UPDATE ON public.email_campaigns FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_email_messages_updated_at BEFORE UPDATE ON public.email_messages FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_user_email_preferences_updated_at BEFORE UPDATE ON public.user_email_preferences FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =============================================
-- RLS POLICIES
-- =============================================

-- PROFILES
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- USER ROLES
CREATE POLICY "Users can view own roles" ON public.user_roles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage all roles" ON public.user_roles FOR ALL USING (public.has_role(auth.uid(), 'admin'));

-- SUBSCRIPTIONS
CREATE POLICY "Users can view own subscription" ON public.subscriptions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own subscription" ON public.subscriptions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own subscription" ON public.subscriptions FOR UPDATE USING (auth.uid() = user_id);

-- PROFESSIONALS
CREATE POLICY "Anyone can view active professionals" ON public.professionals FOR SELECT USING (is_active = true);
CREATE POLICY "Authenticated can view all professionals" ON public.professionals FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can manage professionals" ON public.professionals FOR ALL TO authenticated USING (true);

-- EXERCISES
CREATE POLICY "Anyone can view exercises" ON public.exercises FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage exercises" ON public.exercises FOR ALL TO authenticated USING (true);

-- ROUTINES
CREATE POLICY "Anyone can view published routines" ON public.routines FOR SELECT USING (is_published = true);
CREATE POLICY "Authenticated can view all routines" ON public.routines FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can manage routines" ON public.routines FOR ALL TO authenticated USING (true);

-- ROUTINE BLOCKS
CREATE POLICY "Anyone can view routine blocks" ON public.routine_blocks FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage routine blocks" ON public.routine_blocks FOR ALL TO authenticated USING (true);

-- BLOCK EXERCISES
CREATE POLICY "Anyone can view block exercises" ON public.block_exercises FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage block exercises" ON public.block_exercises FOR ALL TO authenticated USING (true);

-- PROGRAM WEEKS
CREATE POLICY "Anyone can view program weeks" ON public.program_weeks FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage program weeks" ON public.program_weeks FOR ALL TO authenticated USING (true);

-- PROGRAM WEEK ROUTINES
CREATE POLICY "Anyone can view program week routines" ON public.program_week_routines FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage program week routines" ON public.program_week_routines FOR ALL TO authenticated USING (true);

-- USER PROGRAMS
CREATE POLICY "Users can view own programs" ON public.user_programs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own programs" ON public.user_programs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own programs" ON public.user_programs FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own programs" ON public.user_programs FOR DELETE USING (auth.uid() = user_id);

-- SCHEDULED ROUTINES
CREATE POLICY "Users can view own scheduled routines" ON public.scheduled_routines FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own scheduled routines" ON public.scheduled_routines FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own scheduled routines" ON public.scheduled_routines FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own scheduled routines" ON public.scheduled_routines FOR DELETE USING (auth.uid() = user_id);

-- USER EVENTS
CREATE POLICY "Users can view own events" ON public.user_events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own events" ON public.user_events FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own events" ON public.user_events FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own events" ON public.user_events FOR DELETE USING (auth.uid() = user_id);

-- USER FAVORITES
CREATE POLICY "Users can view own favorites" ON public.user_favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own favorites" ON public.user_favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own favorites" ON public.user_favorites FOR DELETE USING (auth.uid() = user_id);

-- PROFESSIONAL AVAILABILITY
CREATE POLICY "Anyone can view availability" ON public.professional_availability FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage availability" ON public.professional_availability FOR ALL TO authenticated USING (true);

-- AVAILABILITY SETTINGS
CREATE POLICY "Anyone can view availability settings" ON public.availability_settings FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage availability settings" ON public.availability_settings FOR ALL TO authenticated USING (true);

-- AVAILABILITY EXCEPTIONS
CREATE POLICY "Anyone can view availability exceptions" ON public.availability_exceptions FOR SELECT USING (true);
CREATE POLICY "Authenticated can manage availability exceptions" ON public.availability_exceptions FOR ALL TO authenticated USING (true);

-- APPOINTMENTS
CREATE POLICY "Users can view own appointments" ON public.appointments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all appointments" ON public.appointments FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Users can insert own appointments" ON public.appointments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own appointments" ON public.appointments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own appointments" ON public.appointments FOR DELETE USING (auth.uid() = user_id);

-- SUPPORT TICKETS
CREATE POLICY "Users can view own tickets" ON public.support_tickets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admins can view all tickets" ON public.support_tickets FOR SELECT USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Users can insert own tickets" ON public.support_tickets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can update any ticket" ON public.support_tickets FOR UPDATE USING (public.has_role(auth.uid(), 'admin'));

-- EMAIL CAMPAIGNS
CREATE POLICY "Authenticated can view campaigns" ON public.email_campaigns FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can insert campaigns" ON public.email_campaigns FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated can update campaigns" ON public.email_campaigns FOR UPDATE TO authenticated USING (true);

-- EMAIL MESSAGES
CREATE POLICY "Authenticated can view messages" ON public.email_messages FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can insert messages" ON public.email_messages FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated can update messages" ON public.email_messages FOR UPDATE TO authenticated USING (true);

-- USER EMAIL PREFERENCES
CREATE POLICY "Users can view own email prefs" ON public.user_email_preferences FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own email prefs" ON public.user_email_preferences FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own email prefs" ON public.user_email_preferences FOR UPDATE USING (auth.uid() = user_id);