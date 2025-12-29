export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.1"
  }
  public: {
    Tables: {
      appointments: {
        Row: {
          canceled_at: string | null
          cancellation_reason: string | null
          created_at: string
          duration_minutes: number
          id: string
          notes: string | null
          professional_id: string
          scheduled_at: string
          status: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          canceled_at?: string | null
          cancellation_reason?: string | null
          created_at?: string
          duration_minutes?: number
          id?: string
          notes?: string | null
          professional_id: string
          scheduled_at: string
          status?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          canceled_at?: string | null
          cancellation_reason?: string | null
          created_at?: string
          duration_minutes?: number
          id?: string
          notes?: string | null
          professional_id?: string
          scheduled_at?: string
          status?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "appointments_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: false
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      availability_exceptions: {
        Row: {
          created_at: string
          end_time: string | null
          exception_date: string
          id: string
          is_available: boolean | null
          professional_id: string
          reason: string | null
          start_time: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          end_time?: string | null
          exception_date: string
          id?: string
          is_available?: boolean | null
          professional_id: string
          reason?: string | null
          start_time?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          end_time?: string | null
          exception_date?: string
          id?: string
          is_available?: boolean | null
          professional_id?: string
          reason?: string | null
          start_time?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "availability_exceptions_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: false
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      availability_settings: {
        Row: {
          buffer_after: number | null
          buffer_before: number | null
          created_at: string
          id: string
          max_daily_sessions: number | null
          professional_id: string
          session_duration: number | null
          updated_at: string
        }
        Insert: {
          buffer_after?: number | null
          buffer_before?: number | null
          created_at?: string
          id?: string
          max_daily_sessions?: number | null
          professional_id: string
          session_duration?: number | null
          updated_at?: string
        }
        Update: {
          buffer_after?: number | null
          buffer_before?: number | null
          created_at?: string
          id?: string
          max_daily_sessions?: number | null
          professional_id?: string
          session_duration?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "availability_settings_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: true
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      block_exercises: {
        Row: {
          block_id: string
          created_at: string
          duration_seconds: number | null
          execution_type: string | null
          exercise_id: string
          id: string
          notes: string | null
          order_index: number
          repetitions: number | null
          rest_override: number | null
          updated_at: string
        }
        Insert: {
          block_id: string
          created_at?: string
          duration_seconds?: number | null
          execution_type?: string | null
          exercise_id: string
          id?: string
          notes?: string | null
          order_index?: number
          repetitions?: number | null
          rest_override?: number | null
          updated_at?: string
        }
        Update: {
          block_id?: string
          created_at?: string
          duration_seconds?: number | null
          execution_type?: string | null
          exercise_id?: string
          id?: string
          notes?: string | null
          order_index?: number
          repetitions?: number | null
          rest_override?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "block_exercises_block_id_fkey"
            columns: ["block_id"]
            isOneToOne: false
            referencedRelation: "routine_blocks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "block_exercises_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["id"]
          },
        ]
      }
      email_campaigns: {
        Row: {
          audience_filter: Json | null
          audience_type: Database["public"]["Enums"]["email_audience_type"]
          body: string
          body_format: Database["public"]["Enums"]["email_body_format"] | null
          created_at: string
          created_by: string | null
          failed_count: number | null
          id: string
          professional_id: string | null
          scheduled_at: string | null
          sent_at: string | null
          sent_count: number | null
          status: Database["public"]["Enums"]["email_campaign_status"] | null
          subject: string
          total_recipients: number | null
          updated_at: string
        }
        Insert: {
          audience_filter?: Json | null
          audience_type: Database["public"]["Enums"]["email_audience_type"]
          body: string
          body_format?: Database["public"]["Enums"]["email_body_format"] | null
          created_at?: string
          created_by?: string | null
          failed_count?: number | null
          id?: string
          professional_id?: string | null
          scheduled_at?: string | null
          sent_at?: string | null
          sent_count?: number | null
          status?: Database["public"]["Enums"]["email_campaign_status"] | null
          subject: string
          total_recipients?: number | null
          updated_at?: string
        }
        Update: {
          audience_filter?: Json | null
          audience_type?: Database["public"]["Enums"]["email_audience_type"]
          body?: string
          body_format?: Database["public"]["Enums"]["email_body_format"] | null
          created_at?: string
          created_by?: string | null
          failed_count?: number | null
          id?: string
          professional_id?: string | null
          scheduled_at?: string | null
          sent_at?: string | null
          sent_count?: number | null
          status?: Database["public"]["Enums"]["email_campaign_status"] | null
          subject?: string
          total_recipients?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "email_campaigns_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: false
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      email_messages: {
        Row: {
          campaign_id: string
          created_at: string
          email: string
          error_message: string | null
          id: string
          sent_at: string | null
          status: Database["public"]["Enums"]["email_message_status"] | null
          updated_at: string
          user_id: string
        }
        Insert: {
          campaign_id: string
          created_at?: string
          email: string
          error_message?: string | null
          id?: string
          sent_at?: string | null
          status?: Database["public"]["Enums"]["email_message_status"] | null
          updated_at?: string
          user_id: string
        }
        Update: {
          campaign_id?: string
          created_at?: string
          email?: string
          error_message?: string | null
          id?: string
          sent_at?: string | null
          status?: Database["public"]["Enums"]["email_message_status"] | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "email_messages_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "email_campaigns"
            referencedColumns: ["id"]
          },
        ]
      }
      exercises: {
        Row: {
          created_at: string
          description: string | null
          difficulty: number | null
          id: string
          implementos: string[] | null
          instructions: string | null
          is_active: boolean | null
          muscle_groups: string[] | null
          name: string
          thumbnail_url: string | null
          updated_at: string
          video_url: string | null
        }
        Insert: {
          created_at?: string
          description?: string | null
          difficulty?: number | null
          id?: string
          implementos?: string[] | null
          instructions?: string | null
          is_active?: boolean | null
          muscle_groups?: string[] | null
          name: string
          thumbnail_url?: string | null
          updated_at?: string
          video_url?: string | null
        }
        Update: {
          created_at?: string
          description?: string | null
          difficulty?: number | null
          id?: string
          implementos?: string[] | null
          instructions?: string | null
          is_active?: boolean | null
          muscle_groups?: string[] | null
          name?: string
          thumbnail_url?: string | null
          updated_at?: string
          video_url?: string | null
        }
        Relationships: []
      }
      professional_availability: {
        Row: {
          created_at: string
          day_of_week: number
          end_time: string
          id: string
          is_active: boolean | null
          professional_id: string
          start_time: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          day_of_week: number
          end_time: string
          id?: string
          is_active?: boolean | null
          professional_id: string
          start_time: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          day_of_week?: number
          end_time?: string
          id?: string
          is_active?: boolean | null
          professional_id?: string
          start_time?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "professional_availability_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: false
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      professionals: {
        Row: {
          avatar_url: string | null
          bio: string | null
          created_at: string
          id: string
          is_active: boolean | null
          name: string
          price_per_session: number | null
          specialty: string | null
          updated_at: string
          user_id: string | null
        }
        Insert: {
          avatar_url?: string | null
          bio?: string | null
          created_at?: string
          id?: string
          is_active?: boolean | null
          name: string
          price_per_session?: number | null
          specialty?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          avatar_url?: string | null
          bio?: string | null
          created_at?: string
          id?: string
          is_active?: boolean | null
          name?: string
          price_per_session?: number | null
          specialty?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Relationships: []
      }
      profiles: {
        Row: {
          aptitudes: Json | null
          avatar_url: string | null
          created_at: string
          email: string | null
          full_name: string | null
          id: string
          updated_at: string
          weekly_goal: number | null
        }
        Insert: {
          aptitudes?: Json | null
          avatar_url?: string | null
          created_at?: string
          email?: string | null
          full_name?: string | null
          id: string
          updated_at?: string
          weekly_goal?: number | null
        }
        Update: {
          aptitudes?: Json | null
          avatar_url?: string | null
          created_at?: string
          email?: string | null
          full_name?: string | null
          id?: string
          updated_at?: string
          weekly_goal?: number | null
        }
        Relationships: []
      }
      program_week_routines: {
        Row: {
          created_at: string
          custom_description: string | null
          custom_name: string | null
          id: string
          order_index: number
          routine_id: string
          updated_at: string
          week_id: string
        }
        Insert: {
          created_at?: string
          custom_description?: string | null
          custom_name?: string | null
          id?: string
          order_index?: number
          routine_id: string
          updated_at?: string
          week_id: string
        }
        Update: {
          created_at?: string
          custom_description?: string | null
          custom_name?: string | null
          id?: string
          order_index?: number
          routine_id?: string
          updated_at?: string
          week_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "program_week_routines_routine_id_fkey"
            columns: ["routine_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "program_week_routines_week_id_fkey"
            columns: ["week_id"]
            isOneToOne: false
            referencedRelation: "program_weeks"
            referencedColumns: ["id"]
          },
        ]
      }
      program_weeks: {
        Row: {
          created_at: string
          description: string | null
          id: string
          name: string | null
          program_id: string
          updated_at: string
          week_number: number
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          name?: string | null
          program_id: string
          updated_at?: string
          week_number: number
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          name?: string | null
          program_id?: string
          updated_at?: string
          week_number?: number
        }
        Relationships: [
          {
            foreignKeyName: "program_weeks_program_id_fkey"
            columns: ["program_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      routine_blocks: {
        Row: {
          created_at: string
          id: string
          name: string
          order_index: number
          repetitions: number | null
          rest_between_exercises: number | null
          rest_between_series: number | null
          routine_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
          order_index?: number
          repetitions?: number | null
          rest_between_exercises?: number | null
          rest_between_series?: number | null
          routine_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
          order_index?: number
          repetitions?: number | null
          rest_between_exercises?: number | null
          rest_between_series?: number | null
          routine_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "routine_blocks_routine_id_fkey"
            columns: ["routine_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      routines: {
        Row: {
          category: string | null
          cover_image_url: string | null
          created_at: string
          created_by: string | null
          description: string | null
          difficulty: number | null
          duration_minutes: number | null
          id: string
          is_program: boolean | null
          is_published: boolean | null
          name: string
          objectives: Json | null
          professional_id: string | null
          updated_at: string
        }
        Insert: {
          category?: string | null
          cover_image_url?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          difficulty?: number | null
          duration_minutes?: number | null
          id?: string
          is_program?: boolean | null
          is_published?: boolean | null
          name: string
          objectives?: Json | null
          professional_id?: string | null
          updated_at?: string
        }
        Update: {
          category?: string | null
          cover_image_url?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          difficulty?: number | null
          duration_minutes?: number | null
          id?: string
          is_program?: boolean | null
          is_published?: boolean | null
          name?: string
          objectives?: Json | null
          professional_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "routines_professional_id_fkey"
            columns: ["professional_id"]
            isOneToOne: false
            referencedRelation: "professionals"
            referencedColumns: ["id"]
          },
        ]
      }
      scheduled_routines: {
        Row: {
          completed: boolean | null
          completed_at: string | null
          created_at: string
          id: string
          routine_id: string
          scheduled_date: string
          updated_at: string
          user_id: string
        }
        Insert: {
          completed?: boolean | null
          completed_at?: string | null
          created_at?: string
          id?: string
          routine_id: string
          scheduled_date: string
          updated_at?: string
          user_id: string
        }
        Update: {
          completed?: boolean | null
          completed_at?: string | null
          created_at?: string
          id?: string
          routine_id?: string
          scheduled_date?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "scheduled_routines_routine_id_fkey"
            columns: ["routine_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      subscriptions: {
        Row: {
          canceled_at: string | null
          created_at: string
          expires_at: string | null
          id: string
          plan: Database["public"]["Enums"]["subscription_plan"]
          starts_at: string
          status: Database["public"]["Enums"]["subscription_status"]
          updated_at: string
          user_id: string
        }
        Insert: {
          canceled_at?: string | null
          created_at?: string
          expires_at?: string | null
          id?: string
          plan?: Database["public"]["Enums"]["subscription_plan"]
          starts_at?: string
          status?: Database["public"]["Enums"]["subscription_status"]
          updated_at?: string
          user_id: string
        }
        Update: {
          canceled_at?: string | null
          created_at?: string
          expires_at?: string | null
          id?: string
          plan?: Database["public"]["Enums"]["subscription_plan"]
          starts_at?: string
          status?: Database["public"]["Enums"]["subscription_status"]
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      support_tickets: {
        Row: {
          admin_response: string | null
          created_at: string
          id: string
          message: string
          priority: string | null
          responded_at: string | null
          responded_by: string | null
          status: string | null
          subject: string
          updated_at: string
          user_id: string
        }
        Insert: {
          admin_response?: string | null
          created_at?: string
          id?: string
          message: string
          priority?: string | null
          responded_at?: string | null
          responded_by?: string | null
          status?: string | null
          subject: string
          updated_at?: string
          user_id: string
        }
        Update: {
          admin_response?: string | null
          created_at?: string
          id?: string
          message?: string
          priority?: string | null
          responded_at?: string | null
          responded_by?: string | null
          status?: string | null
          subject?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      user_email_preferences: {
        Row: {
          appointment_reminders: boolean | null
          created_at: string
          id: string
          marketing_emails: boolean | null
          newsletter: boolean | null
          unsubscribed_at: string | null
          updated_at: string
          user_id: string
          workout_reminders: boolean | null
        }
        Insert: {
          appointment_reminders?: boolean | null
          created_at?: string
          id?: string
          marketing_emails?: boolean | null
          newsletter?: boolean | null
          unsubscribed_at?: string | null
          updated_at?: string
          user_id: string
          workout_reminders?: boolean | null
        }
        Update: {
          appointment_reminders?: boolean | null
          created_at?: string
          id?: string
          marketing_emails?: boolean | null
          newsletter?: boolean | null
          unsubscribed_at?: string | null
          updated_at?: string
          user_id?: string
          workout_reminders?: boolean | null
        }
        Relationships: []
      }
      user_events: {
        Row: {
          created_at: string
          event_date: string
          event_type: string
          id: string
          metadata: Json | null
          program_id: string | null
          routine_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          event_date: string
          event_type: string
          id?: string
          metadata?: Json | null
          program_id?: string | null
          routine_id?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          event_date?: string
          event_type?: string
          id?: string
          metadata?: Json | null
          program_id?: string | null
          routine_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_events_program_id_fkey"
            columns: ["program_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_events_routine_id_fkey"
            columns: ["routine_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      user_favorites: {
        Row: {
          created_at: string
          id: string
          routine_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          routine_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          routine_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_favorites_routine_id_fkey"
            columns: ["routine_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      user_programs: {
        Row: {
          completed_at: string | null
          created_at: string
          current_week: number | null
          enrolled_at: string
          id: string
          is_active: boolean | null
          program_id: string
          updated_at: string
          user_id: string
        }
        Insert: {
          completed_at?: string | null
          created_at?: string
          current_week?: number | null
          enrolled_at?: string
          id?: string
          is_active?: boolean | null
          program_id: string
          updated_at?: string
          user_id: string
        }
        Update: {
          completed_at?: string | null
          created_at?: string
          current_week?: number | null
          enrolled_at?: string
          id?: string
          is_active?: boolean | null
          program_id?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_programs_program_id_fkey"
            columns: ["program_id"]
            isOneToOne: false
            referencedRelation: "routines"
            referencedColumns: ["id"]
          },
        ]
      }
      user_roles: {
        Row: {
          created_at: string
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      cancel_subscription: {
        Args: { _user_id: string }
        Returns: {
          canceled_at: string | null
          created_at: string
          expires_at: string | null
          id: string
          plan: Database["public"]["Enums"]["subscription_plan"]
          starts_at: string
          status: Database["public"]["Enums"]["subscription_status"]
          updated_at: string
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "subscriptions"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      expire_old_subscriptions: { Args: never; Returns: undefined }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      has_valid_subscription: { Args: { _user_id: string }; Returns: boolean }
      mark_subscription_past_due: {
        Args: { _user_id: string }
        Returns: {
          canceled_at: string | null
          created_at: string
          expires_at: string | null
          id: string
          plan: Database["public"]["Enums"]["subscription_plan"]
          starts_at: string
          status: Database["public"]["Enums"]["subscription_status"]
          updated_at: string
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "subscriptions"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      renew_subscription: {
        Args: { _user_id: string }
        Returns: {
          canceled_at: string | null
          created_at: string
          expires_at: string | null
          id: string
          plan: Database["public"]["Enums"]["subscription_plan"]
          starts_at: string
          status: Database["public"]["Enums"]["subscription_status"]
          updated_at: string
          user_id: string
        }
        SetofOptions: {
          from: "*"
          to: "subscriptions"
          isOneToOne: true
          isSetofReturn: false
        }
      }
    }
    Enums: {
      app_role: "admin" | "moderator" | "user"
      email_audience_type: "single" | "selected" | "filtered"
      email_body_format: "markdown" | "html"
      email_campaign_status: "draft" | "queued" | "sending" | "sent" | "failed"
      email_message_status: "queued" | "sent" | "failed" | "skipped_opt_out"
      subscription_plan: "globo" | "volea" | "bandeja" | "smash"
      subscription_status: "activa" | "cancelada" | "vencida" | "pago_fallido"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["admin", "moderator", "user"],
      email_audience_type: ["single", "selected", "filtered"],
      email_body_format: ["markdown", "html"],
      email_campaign_status: ["draft", "queued", "sending", "sent", "failed"],
      email_message_status: ["queued", "sent", "failed", "skipped_opt_out"],
      subscription_plan: ["globo", "volea", "bandeja", "smash"],
      subscription_status: ["activa", "cancelada", "vencida", "pago_fallido"],
    },
  },
} as const
