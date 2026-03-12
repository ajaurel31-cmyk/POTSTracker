// ===== Profile =====
export interface Profile {
  id: number;
  name: string;
  dob: string;
  diagnosis_type: DiagnosisType;
  gender: 'male' | 'female' | 'non-binary' | 'prefer-not-to-say';
  medications: Medication[];
  custom_symptoms: string[];
  custom_triggers: string[];
  units: 'imperial' | 'metric';
  created_at: string;
  pin_enabled?: boolean;
  biometric_enabled?: boolean;
  hydration_goal?: number;
  notification_log_time?: string;
  notification_hydration_interval?: number;
  show_menstrual?: boolean;
}

export type DiagnosisType =
  | 'POTS'
  | 'Hyperadrenergic POTS'
  | 'Vasovagal Syncope'
  | 'Orthostatic Hypotension'
  | 'Other Dysautonomia'
  | 'Undiagnosed';

export interface Medication {
  id: string;
  name: string;
  dosage: string;
  time_of_day: 'morning' | 'afternoon' | 'evening' | 'bedtime' | 'as-needed';
  reminder_enabled: boolean;
  reminder_time?: string;
}

// ===== Daily Log =====
export interface DailyLog {
  id?: number;
  log_date: string;
  hr_lying?: number;
  hr_sitting?: number;
  hr_standing?: number;
  bp_lying_sys?: number;
  bp_lying_dia?: number;
  bp_standing_sys?: number;
  bp_standing_dia?: number;
  symptoms: SymptomEntry[];
  triggers: string[];
  water_intake?: number;
  electrolyte_oz?: number;
  salt_intake_mg?: number;
  activity_level?: ActivityLevel;
  time_upright?: number;
  exercise_done: boolean;
  exercise_data?: ExerciseData;
  sleep_hours?: number;
  sleep_quality?: number;
  unrefreshed: boolean;
  cycle_phase?: CyclePhase;
  medications_taken: MedicationTaken[];
  overall_rating?: number;
  notes?: string;
  created_at?: string;
  updated_at?: string;
}

export interface SymptomEntry {
  name: string;
  severity: number; // 1-5
}

export type ActivityLevel =
  | 'Bedbound'
  | 'Mostly Resting'
  | 'Light Activity'
  | 'Moderate'
  | 'Active';

export interface ExerciseData {
  type: 'Recumbent Bike' | 'Swimming' | 'Walking' | 'Rowing' | 'Other';
  duration: number; // minutes
  intensity: number; // 1-10
  other_type?: string;
}

export type CyclePhase = 'on-period' | 'pre-period' | 'mid-cycle' | 'post-period';

export interface MedicationTaken {
  medication_id: string;
  name: string;
  status: 'taken' | 'skipped' | 'dose-changed';
  notes?: string;
}

// ===== Symptoms =====
export const DEFAULT_SYMPTOMS = [
  'Lightheadedness / Presyncope',
  'Brain Fog',
  'Fatigue',
  'Palpitations',
  'Chest Pain',
  'Shortness of Breath',
  'Headache',
  'Nausea',
  'Exercise Intolerance',
  'Tremors/Shakiness',
  'Temperature Dysregulation',
  'Visual Disturbances',
  'Fainting / Near-fainting',
  'GI Issues',
] as const;

export const DEFAULT_TRIGGERS = [
  'Heat',
  'Dehydration',
  'Stress',
  'Menstrual Cycle',
  'Exercise',
  'Food/Meals',
  'Poor Sleep',
  'Standing Too Long',
] as const;

export const DIAGNOSIS_TYPES: DiagnosisType[] = [
  'POTS',
  'Hyperadrenergic POTS',
  'Vasovagal Syncope',
  'Orthostatic Hypotension',
  'Other Dysautonomia',
  'Undiagnosed',
];

export const ACTIVITY_LEVELS: ActivityLevel[] = [
  'Bedbound',
  'Mostly Resting',
  'Light Activity',
  'Moderate',
  'Active',
];

export const EXERCISE_TYPES = [
  'Recumbent Bike',
  'Swimming',
  'Walking',
  'Rowing',
  'Other',
] as const;

// ===== Insights =====
export interface Insight {
  id: string;
  title: string;
  description: string;
  type: 'positive' | 'warning' | 'info' | 'negative';
  metric?: string;
  tip?: string;
  data?: Record<string, unknown>;
}

// ===== Chart Data =====
export interface ChartDataPoint {
  date: string;
  label: string;
  [key: string]: string | number | undefined;
}

export interface DayRanking {
  date: string;
  rating: number;
  topSymptom?: string;
}

// ===== Notifications =====
export interface NotificationConfig {
  dailyLogReminder: boolean;
  dailyLogTime: string;
  hydrationReminder: boolean;
  hydrationInterval: number; // hours
  medicationReminders: boolean;
}
