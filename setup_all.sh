#!/bin/bash
set -e

echo "======================================"
echo "POTSTracker - Dysautonomia Diary"
echo "Project Setup Script"
echo "======================================"
echo ""
echo "Creating project at ~/Desktop/POTSTracker..."
echo ""

# Create directory structure
mkdir -p ~/Desktop/POTSTracker/src/{app/{log,trends,insights,profile,onboarding},components/{ui,onboarding,log,trends,insights,profile,shared},lib,stores,types}
mkdir -p ~/Desktop/POTSTracker/public/icons
mkdir -p ~/Desktop/POTSTracker/ios/App


# ===== Part 1 =====

# Create directory structure
mkdir -p ~/Desktop/POTSTracker/src/{app/{log,trends,insights,profile,onboarding},components/{ui,onboarding,log,trends,insights,profile,shared},lib,stores,types} ~/Desktop/POTSTracker/public/icons ~/Desktop/POTSTracker/ios/App

# package.json
cat > ~/Desktop/POTSTracker/package.json << 'ENDOFFILE'
{
  "name": "potstracker",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "export": "next build",
    "cap:sync": "npx cap sync",
    "cap:open": "npx cap open ios",
    "ios": "npm run build && npx cap sync ios && npx cap open ios"
  },
  "dependencies": {
    "next": "14.2.15",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "typescript": "^5.5.4",
    "@capacitor/core": "^5.7.8",
    "@capacitor/ios": "^5.7.8",
    "@capacitor/preferences": "^5.0.8",
    "@capacitor/local-notifications": "^5.0.8",
    "@capacitor/haptics": "^5.0.8",
    "@capacitor/filesystem": "^5.2.2",
    "@capacitor/share": "^5.0.8",
    "@capacitor/splash-screen": "^5.0.8",
    "@capacitor/status-bar": "^5.0.8",
    "@capacitor/browser": "^5.2.1",
    "@capacitor-community/sqlite": "^5.6.3",
    "recharts": "^2.12.7",
    "zustand": "^4.5.5",
    "tailwindcss": "^3.4.13",
    "postcss": "^8.4.47",
    "autoprefixer": "^10.4.20",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.5.4",
    "class-variance-authority": "^0.7.0",
    "lucide-react": "^0.451.0",
    "date-fns": "^3.6.0",
    "jspdf": "^2.5.2",
    "jspdf-autotable": "^3.8.3",
    "@radix-ui/react-slider": "^1.2.1",
    "@radix-ui/react-switch": "^1.1.1",
    "@radix-ui/react-tabs": "^1.1.1",
    "@radix-ui/react-dialog": "^1.1.2",
    "@radix-ui/react-collapsible": "^1.1.1",
    "@radix-ui/react-select": "^2.1.2",
    "@radix-ui/react-checkbox": "^1.1.2",
    "@radix-ui/react-label": "^2.1.0",
    "@radix-ui/react-toast": "^1.2.2"
  },
  "devDependencies": {
    "@capacitor/cli": "^5.7.8",
    "@types/node": "^22.8.0",
    "@types/react": "^18.3.11",
    "@types/react-dom": "^18.3.1",
    "eslint": "^8.57.0",
    "eslint-config-next": "14.2.15"
  }
}
ENDOFFILE

# next.config.js
cat > ~/Desktop/POTSTracker/next.config.js << 'ENDOFFILE'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
};

module.exports = nextConfig;
ENDOFFILE

# tsconfig.json
cat > ~/Desktop/POTSTracker/tsconfig.json << 'ENDOFFILE'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    },
    "baseUrl": "."
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
ENDOFFILE

# tailwind.config.ts
cat > ~/Desktop/POTSTracker/tailwind.config.ts << 'ENDOFFILE'
import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#0D7377',
          50: '#E6F5F5',
          100: '#B3E0E1',
          200: '#80CBCD',
          300: '#4DB6B9',
          400: '#26A5A8',
          500: '#0D7377',
          600: '#0B6163',
          700: '#094E50',
          800: '#073C3D',
          900: '#042A2B',
        },
        accent: {
          DEFAULT: '#F4845F',
          50: '#FEF0EB',
          100: '#FCD5C9',
          200: '#F9BAA7',
          300: '#F7A085',
          400: '#F4845F',
          500: '#F16A3C',
          600: '#E04E1E',
          700: '#B53E18',
          800: '#8A2F12',
          900: '#5F200D',
        },
        success: '#2ECC71',
        warning: '#F39C12',
        danger: '#E74C3C',
        bg: {
          light: '#F8FAFB',
          dark: '#0F1923',
        },
        card: {
          light: '#FFFFFF',
          dark: '#1C2533',
        },
      },
      borderRadius: {
        card: '16px',
      },
      fontSize: {
        'dynamic-xs': ['clamp(0.65rem, 0.6rem + 0.25vw, 0.75rem)', { lineHeight: '1rem' }],
        'dynamic-sm': ['clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem)', { lineHeight: '1.25rem' }],
        'dynamic-base': ['clamp(0.875rem, 0.8rem + 0.35vw, 1rem)', { lineHeight: '1.5rem' }],
        'dynamic-lg': ['clamp(1rem, 0.9rem + 0.5vw, 1.125rem)', { lineHeight: '1.75rem' }],
        'dynamic-xl': ['clamp(1.125rem, 1rem + 0.6vw, 1.25rem)', { lineHeight: '1.75rem' }],
        'dynamic-2xl': ['clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem)', { lineHeight: '2rem' }],
        'dynamic-3xl': ['clamp(1.5rem, 1.3rem + 1vw, 1.875rem)', { lineHeight: '2.25rem' }],
      },
      minHeight: {
        'tap': '44px',
      },
      minWidth: {
        'tap': '44px',
      },
    },
  },
  plugins: [],
};

export default config;
ENDOFFILE

# postcss.config.js
cat > ~/Desktop/POTSTracker/postcss.config.js << 'ENDOFFILE'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
ENDOFFILE

# capacitor.config.ts
cat > ~/Desktop/POTSTracker/capacitor.config.ts << 'ENDOFFILE'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.potstracker.app',
  appName: 'POTSTracker',
  webDir: 'out',
  server: {
    androidScheme: 'https',
  },
  plugins: {
    LocalNotifications: {
      smallIcon: 'ic_stat_icon_config_sample',
      iconColor: '#0D7377',
    },
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#0D7377',
      showSpinner: false,
      launchAutoHide: true,
    },
    StatusBar: {
      style: 'DEFAULT',
    },
  },
  ios: {
    contentInset: 'automatic',
    preferredContentMode: 'mobile',
    scheme: 'POTSTracker',
  },
};

export default config;
ENDOFFILE

# next-env.d.ts
cat > ~/Desktop/POTSTracker/next-env.d.ts << 'ENDOFFILE'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/basic-features/typescript for more information.
ENDOFFILE

# .eslintrc.json
cat > ~/Desktop/POTSTracker/.eslintrc.json << 'ENDOFFILE'
{
  "extends": "next/core-web-vitals"
}
ENDOFFILE

# .gitignore
cat > ~/Desktop/POTSTracker/.gitignore << 'ENDOFFILE'
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts

# Capacitor
/ios/App/App/public
/android/app/src/main/assets/public
ENDOFFILE

# src/types/index.ts
cat > ~/Desktop/POTSTracker/src/types/index.ts << 'ENDOFFILE'
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
ENDOFFILE

# src/lib/utils.ts
cat > ~/Desktop/POTSTracker/src/lib/utils.ts << 'ENDOFFILE'
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatDate(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export function formatDateShort(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

export function getToday(): string {
  return new Date().toISOString().split('T')[0];
}

export function getDateNDaysAgo(n: number): string {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().split('T')[0];
}

export function calculateHRDelta(lying?: number, standing?: number): number | null {
  if (lying == null || standing == null) return null;
  return standing - lying;
}

export function checkOrthostatic(
  lying?: number,
  standing?: number,
  ageUnder19?: boolean
): { met: boolean; delta: number | null; threshold: number } {
  const threshold = ageUnder19 ? 40 : 30;
  const delta = calculateHRDelta(lying, standing);
  return {
    met: delta !== null && delta >= threshold,
    delta,
    threshold,
  };
}

export function checkOrthostaticHypotension(
  lyingSys?: number,
  lyingDia?: number,
  standingSys?: number,
  standingDia?: number
): { met: boolean; sysDrop: number | null; diaDrop: number | null } {
  if (!lyingSys || !standingSys || !lyingDia || !standingDia) {
    return { met: false, sysDrop: null, diaDrop: null };
  }
  const sysDrop = lyingSys - standingSys;
  const diaDrop = lyingDia - standingDia;
  return {
    met: sysDrop >= 20 || diaDrop >= 10,
    sysDrop,
    diaDrop,
  };
}

export function calculateSodiumFromGrams(grams: number): number {
  return Math.round(grams * 393);
}

export function ozToMl(oz: number): number {
  return Math.round(oz * 29.5735);
}

export function mlToOz(ml: number): number {
  return Math.round(ml / 29.5735 * 10) / 10;
}

export function getEmojiForRating(rating: number): string {
  if (rating <= 2) return '😫';
  if (rating <= 4) return '😔';
  if (rating <= 6) return '😐';
  if (rating <= 8) return '🙂';
  return '😊';
}

export function getAgeFromDob(dob: string): number {
  const birth = new Date(dob);
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const m = today.getMonth() - birth.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

export function debounce<T extends (...args: unknown[]) => unknown>(
  fn: T,
  delay: number
): (...args: Parameters<T>) => void {
  let timer: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}
ENDOFFILE

# src/lib/database.ts
cat > ~/Desktop/POTSTracker/src/lib/database.ts << 'ENDOFFILE'
import { Preferences } from '@capacitor/preferences';
import type { DailyLog, Profile, SymptomEntry } from '@/types';

// Since we're building for Capacitor with SQLite, but need a fallback for web dev,
// we use Preferences (localStorage wrapper) as our storage engine with JSON serialization.
// In production iOS build, this could be swapped to @capacitor-community/sqlite.

const KEYS = {
  PROFILE: 'potstracker_profile',
  LOGS: 'potstracker_logs',
  ONBOARDING_COMPLETE: 'potstracker_onboarding',
  SYMPTOM_ENTRIES: 'potstracker_symptom_entries',
};

// ===== Helpers =====
async function getJSON<T>(key: string, fallback: T): Promise<T> {
  try {
    const { value } = await Preferences.get({ key });
    if (value) return JSON.parse(value) as T;
    return fallback;
  } catch {
    // Fallback to localStorage for web dev
    try {
      const value = localStorage.getItem(key);
      if (value) return JSON.parse(value) as T;
    } catch {
      // ignore
    }
    return fallback;
  }
}

async function setJSON<T>(key: string, data: T): Promise<void> {
  const value = JSON.stringify(data);
  try {
    await Preferences.set({ key, value });
  } catch {
    // Fallback to localStorage for web dev
    try {
      localStorage.setItem(key, value);
    } catch {
      // ignore
    }
  }
}

// ===== Onboarding =====
export async function isOnboardingComplete(): Promise<boolean> {
  const val = await getJSON<boolean>(KEYS.ONBOARDING_COMPLETE, false);
  return val;
}

export async function setOnboardingComplete(): Promise<void> {
  await setJSON(KEYS.ONBOARDING_COMPLETE, true);
}

// ===== Profile =====
export async function getProfile(): Promise<Profile | null> {
  return getJSON<Profile | null>(KEYS.PROFILE, null);
}

export async function saveProfile(profile: Partial<Profile>): Promise<Profile> {
  const existing = await getProfile();
  const updated: Profile = {
    id: 1,
    name: '',
    dob: '',
    diagnosis_type: 'Undiagnosed',
    gender: 'prefer-not-to-say',
    medications: [],
    custom_symptoms: [],
    custom_triggers: [],
    units: 'imperial',
    created_at: new Date().toISOString(),
    ...existing,
    ...profile,
  };
  await setJSON(KEYS.PROFILE, updated);
  return updated;
}

// ===== Daily Logs =====
export async function getAllLogs(): Promise<DailyLog[]> {
  return getJSON<DailyLog[]>(KEYS.LOGS, []);
}

export async function getLogByDate(date: string): Promise<DailyLog | null> {
  const logs = await getAllLogs();
  return logs.find((l) => l.log_date === date) || null;
}

export async function getLogsByDateRange(startDate: string, endDate: string): Promise<DailyLog[]> {
  const logs = await getAllLogs();
  return logs
    .filter((l) => l.log_date >= startDate && l.log_date <= endDate)
    .sort((a, b) => a.log_date.localeCompare(b.log_date));
}

export async function saveLog(log: DailyLog): Promise<DailyLog> {
  const logs = await getAllLogs();
  const existingIndex = logs.findIndex((l) => l.log_date === log.log_date);

  const now = new Date().toISOString();
  const savedLog: DailyLog = {
    ...log,
    updated_at: now,
    created_at: log.created_at || now,
  };

  if (existingIndex >= 0) {
    savedLog.id = logs[existingIndex].id;
    logs[existingIndex] = savedLog;
  } else {
    savedLog.id = logs.length > 0 ? Math.max(...logs.map((l) => l.id || 0)) + 1 : 1;
    logs.push(savedLog);
  }

  await setJSON(KEYS.LOGS, logs);

  // Also save individual symptom entries for trend analysis
  if (savedLog.symptoms && savedLog.symptoms.length > 0) {
    await saveSymptomEntries(savedLog.id!, savedLog.log_date, savedLog.symptoms);
  }

  return savedLog;
}

export async function deleteLog(date: string): Promise<void> {
  const logs = await getAllLogs();
  const filtered = logs.filter((l) => l.log_date !== date);
  await setJSON(KEYS.LOGS, filtered);
}

// ===== Symptom Entries =====
interface StoredSymptomEntry {
  id: number;
  log_id: number;
  symptom_name: string;
  severity: number;
  log_date: string;
}

async function saveSymptomEntries(
  logId: number,
  logDate: string,
  symptoms: SymptomEntry[]
): Promise<void> {
  const allEntries = await getJSON<StoredSymptomEntry[]>(KEYS.SYMPTOM_ENTRIES, []);
  // Remove old entries for this log
  const filtered = allEntries.filter((e) => e.log_id !== logId);
  // Add new entries
  let maxId = filtered.length > 0 ? Math.max(...filtered.map((e) => e.id)) : 0;
  const newEntries = symptoms.map((s) => ({
    id: ++maxId,
    log_id: logId,
    symptom_name: s.name,
    severity: s.severity,
    log_date: logDate,
  }));
  await setJSON(KEYS.SYMPTOM_ENTRIES, [...filtered, ...newEntries]);
}

export async function getSymptomEntriesByRange(
  startDate: string,
  endDate: string
): Promise<StoredSymptomEntry[]> {
  const entries = await getJSON<StoredSymptomEntry[]>(KEYS.SYMPTOM_ENTRIES, []);
  return entries.filter((e) => e.log_date >= startDate && e.log_date <= endDate);
}

// ===== Data Export =====
export async function exportAllDataAsCSV(): Promise<string> {
  const logs = await getAllLogs();
  if (logs.length === 0) return '';

  const headers = [
    'Date', 'HR Lying', 'HR Sitting', 'HR Standing', 'HR Delta',
    'BP Lying Sys', 'BP Lying Dia', 'BP Standing Sys', 'BP Standing Dia',
    'Symptoms', 'Triggers', 'Water Intake', 'Electrolyte Oz', 'Salt (mg)',
    'Activity Level', 'Time Upright', 'Exercise', 'Sleep Hours', 'Sleep Quality',
    'Unrefreshed', 'Cycle Phase', 'Overall Rating', 'Notes',
  ];

  const rows = logs.map((log) => [
    log.log_date,
    log.hr_lying ?? '',
    log.hr_sitting ?? '',
    log.hr_standing ?? '',
    log.hr_lying && log.hr_standing ? log.hr_standing - log.hr_lying : '',
    log.bp_lying_sys ?? '',
    log.bp_lying_dia ?? '',
    log.bp_standing_sys ?? '',
    log.bp_standing_dia ?? '',
    log.symptoms?.map((s) => `${s.name}(${s.severity})`).join('; ') ?? '',
    log.triggers?.join('; ') ?? '',
    log.water_intake ?? '',
    log.electrolyte_oz ?? '',
    log.salt_intake_mg ?? '',
    log.activity_level ?? '',
    log.time_upright ?? '',
    log.exercise_done
      ? `${log.exercise_data?.type || ''} ${log.exercise_data?.duration || ''}min`
      : 'No',
    log.sleep_hours ?? '',
    log.sleep_quality ?? '',
    log.unrefreshed ? 'Yes' : 'No',
    log.cycle_phase ?? '',
    log.overall_rating ?? '',
    log.notes?.replace(/"/g, '""') ?? '',
  ]);

  const csvContent =
    headers.join(',') + '\n' +
    rows.map((r) => r.map((v) => `"${v}"`).join(',')).join('\n');

  return csvContent;
}

// ===== Clear All Data =====
export async function clearAllData(): Promise<void> {
  try {
    await Preferences.clear();
  } catch {
    localStorage.clear();
  }
}
ENDOFFILE

echo "Part 1 setup complete!"

# ===== Part 2 =====

cat > ~/Desktop/POTSTracker/src/lib/insights-engine.ts << 'ENDOFFILE'
import type { DailyLog, Insight } from '@/types';

export function generateInsights(logs: DailyLog[]): Insight[] {
  const insights: Insight[] = [];
  if (logs.length < 3) return insights;

  const last14 = logs.slice(-14);
  const last7 = logs.slice(-7);
  const last30 = logs.slice(-30);

  // 1. HR Delta analysis
  const hrDeltaLogs = last14.filter(
    (l) => l.hr_lying != null && l.hr_standing != null
  );
  if (hrDeltaLogs.length >= 3) {
    const exceeded = hrDeltaLogs.filter(
      (l) => (l.hr_standing! - l.hr_lying!) >= 30
    );
    if (exceeded.length > 0) {
      insights.push({
        id: 'hr-delta-freq',
        title: 'Orthostatic HR Pattern',
        description: `Your HR delta has exceeded 30 BPM on ${exceeded.length} of the last ${hrDeltaLogs.length} days.`,
        type: exceeded.length > hrDeltaLogs.length / 2 ? 'warning' : 'info',
        tip: 'Consider increasing fluid and salt intake. Compression garments may help. Talk to your doctor about adjusting medications if this is persistent.',
      });
    }
  }

  // 2. Sleep and symptoms correlation
  const withSleepAndRating = last14.filter(
    (l) => l.sleep_hours != null && l.overall_rating != null
  );
  if (withSleepAndRating.length >= 5) {
    const poorSleepDays = withSleepAndRating.filter((l) => (l.sleep_hours || 0) < 6);
    const goodSleepDays = withSleepAndRating.filter((l) => (l.sleep_hours || 0) >= 7);
    if (poorSleepDays.length >= 2 && goodSleepDays.length >= 2) {
      const avgPoorRating =
        poorSleepDays.reduce((sum, l) => sum + (l.overall_rating || 0), 0) / poorSleepDays.length;
      const avgGoodRating =
        goodSleepDays.reduce((sum, l) => sum + (l.overall_rating || 0), 0) / goodSleepDays.length;
      if (avgGoodRating - avgPoorRating > 1.5) {
        insights.push({
          id: 'sleep-correlation',
          title: 'Sleep Affects Your Days',
          description: `Your worst symptom days correlated with sleeping less than 6 hours. Days with 7+ hours averaged a ${avgGoodRating.toFixed(1)} rating vs ${avgPoorRating.toFixed(1)}.`,
          type: 'info',
          tip: 'Try to maintain a consistent sleep schedule. Elevate the head of your bed 4-6 inches. Avoid screens 1 hour before bed.',
        });
      }
    }
  }

  // 3. Hydration goal tracking
  const hydrationGoal = 64; // oz, can be customized later
  const withWater = last7.filter((l) => l.water_intake != null);
  if (withWater.length >= 3) {
    const metGoal = withWater.filter((l) => (l.water_intake || 0) >= hydrationGoal);
    insights.push({
      id: 'hydration-goal',
      title: 'Hydration Progress',
      description: `You've hit your hydration goal ${metGoal.length} of the last ${withWater.length} days.`,
      type: metGoal.length >= withWater.length * 0.7 ? 'positive' : 'warning',
      tip: 'Aim for 2-3 liters of water daily. Consider adding electrolyte packets. Set hourly hydration reminders.',
    });
  }

  // 4. Trigger pattern analysis
  const withRating = last30.filter(
    (l) => l.overall_rating != null && l.triggers && l.triggers.length > 0
  );
  if (withRating.length >= 5) {
    const worstDays = [...withRating]
      .sort((a, b) => (a.overall_rating || 0) - (b.overall_rating || 0))
      .slice(0, 5);
    const triggerCounts: Record<string, number> = {};
    worstDays.forEach((day) => {
      day.triggers?.forEach((t) => {
        triggerCounts[t] = (triggerCounts[t] || 0) + 1;
      });
    });
    const topTrigger = Object.entries(triggerCounts).sort(([, a], [, b]) => b - a)[0];
    if (topTrigger && topTrigger[1] >= 3) {
      insights.push({
        id: 'trigger-pattern',
        title: 'Trigger Alert',
        description: `"${topTrigger[0]}" was logged as a trigger on ${topTrigger[1]} of your ${worstDays.length} worst days this month.`,
        type: 'warning',
        tip: `Try to minimize exposure to "${topTrigger[0]}" when possible. Track this trigger closely and discuss patterns with your doctor.`,
      });
    }
  }

  // 5. Symptom trend (improving or worsening)
  if (last14.length >= 7) {
    const firstHalf = last14.slice(0, 7);
    const secondHalf = last14.slice(7);

    const avgFirst =
      firstHalf.reduce((sum, l) => {
        const symptomAvg =
          l.symptoms && l.symptoms.length > 0
            ? l.symptoms.reduce((s, sym) => s + sym.severity, 0) / l.symptoms.length
            : 0;
        return sum + symptomAvg;
      }, 0) / firstHalf.length;

    const avgSecond =
      secondHalf.reduce((sum, l) => {
        const symptomAvg =
          l.symptoms && l.symptoms.length > 0
            ? l.symptoms.reduce((s, sym) => s + sym.severity, 0) / l.symptoms.length
            : 0;
        return sum + symptomAvg;
      }, 0) / secondHalf.length;

    if (avgFirst - avgSecond > 0.5) {
      insights.push({
        id: 'symptom-trend-down',
        title: 'Symptoms Improving',
        description: 'Your symptom severity is trending downward over the past 2 weeks.',
        type: 'positive',
        tip: 'Keep up what you\'re doing! Note any changes in routine, medications, or habits that may be helping.',
      });
    } else if (avgSecond - avgFirst > 0.5) {
      insights.push({
        id: 'symptom-trend-up',
        title: 'Symptoms Increasing',
        description: 'Your symptom severity has been trending upward over the past 2 weeks.',
        type: 'negative',
        tip: 'Consider scheduling a check-in with your doctor. Review any changes in medication, sleep, or stress levels.',
      });
    }
  }

  // 6. Activity impact
  const withActivity = last14.filter(
    (l) => l.activity_level != null && l.overall_rating != null
  );
  if (withActivity.length >= 5) {
    const restDays = withActivity.filter(
      (l) => l.activity_level === 'Bedbound' || l.activity_level === 'Mostly Resting'
    );
    const activeDays = withActivity.filter(
      (l) => l.activity_level === 'Light Activity' || l.activity_level === 'Moderate' || l.activity_level === 'Active'
    );
    if (restDays.length >= 2 && activeDays.length >= 2) {
      const avgRestRating =
        restDays.reduce((s, l) => s + (l.overall_rating || 0), 0) / restDays.length;
      const avgActiveRating =
        activeDays.reduce((s, l) => s + (l.overall_rating || 0), 0) / activeDays.length;
      if (avgActiveRating > avgRestRating + 1) {
        insights.push({
          id: 'activity-helps',
          title: 'Movement Helps',
          description: `Active days averaged a ${avgActiveRating.toFixed(1)} rating vs ${avgRestRating.toFixed(1)} on rest days.`,
          type: 'positive',
          tip: 'Gentle, recumbent exercise (like recumbent biking or swimming) is often well-tolerated with POTS. Start slow and gradually increase.',
        });
      }
    }
  }

  return insights;
}

// Generate a doctor visit summary
export function generateDoctorSummary(logs: DailyLog[], days: number): string {
  if (logs.length === 0) return 'No data available for this period.';

  const lines: string[] = [];
  lines.push(`POTSTracker - Doctor Visit Summary`);
  lines.push(`Period: Last ${days} days (${logs.length} entries)`);
  lines.push(`Generated: ${new Date().toLocaleDateString()}`);
  lines.push('');

  // HR summary
  const hrLogs = logs.filter((l) => l.hr_lying != null && l.hr_standing != null);
  if (hrLogs.length > 0) {
    const avgLying = Math.round(
      hrLogs.reduce((s, l) => s + (l.hr_lying || 0), 0) / hrLogs.length
    );
    const avgStanding = Math.round(
      hrLogs.reduce((s, l) => s + (l.hr_standing || 0), 0) / hrLogs.length
    );
    const avgDelta = avgStanding - avgLying;
    const daysOver30 = hrLogs.filter(
      (l) => (l.hr_standing! - l.hr_lying!) >= 30
    ).length;

    lines.push('HEART RATE');
    lines.push(`  Average Lying HR: ${avgLying} BPM`);
    lines.push(`  Average Standing HR: ${avgStanding} BPM`);
    lines.push(`  Average Orthostatic Delta: +${avgDelta} BPM`);
    lines.push(`  Days with delta ≥30 BPM: ${daysOver30}/${hrLogs.length}`);
    lines.push('');
  }

  // BP summary
  const bpLogs = logs.filter((l) => l.bp_lying_sys != null && l.bp_standing_sys != null);
  if (bpLogs.length > 0) {
    const avgLyingSys = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_lying_sys || 0), 0) / bpLogs.length
    );
    const avgLyingDia = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_lying_dia || 0), 0) / bpLogs.length
    );
    const avgStandSys = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_standing_sys || 0), 0) / bpLogs.length
    );
    const avgStandDia = Math.round(
      bpLogs.reduce((s, l) => s + (l.bp_standing_dia || 0), 0) / bpLogs.length
    );

    lines.push('BLOOD PRESSURE');
    lines.push(`  Average Lying: ${avgLyingSys}/${avgLyingDia} mmHg`);
    lines.push(`  Average Standing: ${avgStandSys}/${avgStandDia} mmHg`);
    lines.push('');
  }

  // Top symptoms
  const symptomCounts: Record<string, { count: number; totalSeverity: number }> = {};
  logs.forEach((l) => {
    l.symptoms?.forEach((s) => {
      if (!symptomCounts[s.name]) symptomCounts[s.name] = { count: 0, totalSeverity: 0 };
      symptomCounts[s.name].count++;
      symptomCounts[s.name].totalSeverity += s.severity;
    });
  });
  const topSymptoms = Object.entries(symptomCounts)
    .sort(([, a], [, b]) => b.count - a.count)
    .slice(0, 10);

  if (topSymptoms.length > 0) {
    lines.push('TOP SYMPTOMS');
    topSymptoms.forEach(([name, data]) => {
      const avgSev = (data.totalSeverity / data.count).toFixed(1);
      lines.push(`  ${name}: ${data.count} days, avg severity ${avgSev}/5`);
    });
    lines.push('');
  }

  // Triggers
  const triggerCounts: Record<string, number> = {};
  logs.forEach((l) => {
    l.triggers?.forEach((t) => {
      triggerCounts[t] = (triggerCounts[t] || 0) + 1;
    });
  });
  const topTriggers = Object.entries(triggerCounts)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 5);

  if (topTriggers.length > 0) {
    lines.push('TOP TRIGGERS');
    topTriggers.forEach(([name, count]) => {
      lines.push(`  ${name}: ${count} days`);
    });
    lines.push('');
  }

  // Overall ratings
  const rated = logs.filter((l) => l.overall_rating != null);
  if (rated.length > 0) {
    const avgRating =
      rated.reduce((s, l) => s + (l.overall_rating || 0), 0) / rated.length;
    const worst = Math.min(...rated.map((l) => l.overall_rating || 10));
    const best = Math.max(...rated.map((l) => l.overall_rating || 0));
    lines.push('OVERALL WELLBEING');
    lines.push(`  Average Day Rating: ${avgRating.toFixed(1)}/10`);
    lines.push(`  Best Day: ${best}/10`);
    lines.push(`  Worst Day: ${worst}/10`);
    lines.push('');
  }

  // Sleep
  const sleepLogs = logs.filter((l) => l.sleep_hours != null);
  if (sleepLogs.length > 0) {
    const avgSleep =
      sleepLogs.reduce((s, l) => s + (l.sleep_hours || 0), 0) / sleepLogs.length;
    const unrefreshed = sleepLogs.filter((l) => l.unrefreshed).length;
    lines.push('SLEEP');
    lines.push(`  Average: ${avgSleep.toFixed(1)} hours`);
    lines.push(`  Woke unrefreshed: ${unrefreshed}/${sleepLogs.length} days`);
    lines.push('');
  }

  lines.push('---');
  lines.push('Generated by POTSTracker – Dysautonomia Diary');

  return lines.join('\n');
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/lib/notifications.ts << 'ENDOFFILE'
// Notification utilities for Capacitor LocalNotifications plugin
// In a real Capacitor build, import from @capacitor/local-notifications

interface ScheduleOptions {
  id: number;
  title: string;
  body: string;
  hour: number;
  minute: number;
  repeats?: boolean;
}

// Unique ID ranges for different notification types
const NOTIFICATION_IDS = {
  DAILY_LOG: 1000,
  HYDRATION_BASE: 2000,
  MEDICATION_BASE: 3000,
};

export async function scheduleDailyLogReminder(time: string): Promise<void> {
  const [hour, minute] = time.split(':').map(Number);

  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    // Cancel existing daily log notification
    await LocalNotifications.cancel({ notifications: [{ id: NOTIFICATION_IDS.DAILY_LOG }] });

    await LocalNotifications.schedule({
      notifications: [
        {
          title: 'POTSTracker',
          body: 'Time to log your vitals! Tap to open POTSTracker.',
          id: NOTIFICATION_IDS.DAILY_LOG,
          schedule: {
            on: { hour, minute },
            repeats: true,
            allowWhileIdle: true,
          },
          sound: 'default',
          actionTypeId: 'OPEN_LOG',
        },
      ],
    });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function scheduleHydrationReminders(intervalHours: number): Promise<void> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    // Cancel existing hydration notifications (IDs 2000-2099)
    const cancelIds = Array.from({ length: 12 }, (_, i) => ({
      id: NOTIFICATION_IDS.HYDRATION_BASE + i,
    }));
    await LocalNotifications.cancel({ notifications: cancelIds });

    // Schedule reminders from 8am to 10pm
    const notifications = [];
    let id = NOTIFICATION_IDS.HYDRATION_BASE;
    for (let hour = 8; hour <= 22; hour += intervalHours) {
      notifications.push({
        title: 'Stay Hydrated!',
        body: "Don't forget to hydrate! 💧",
        id: id++,
        schedule: {
          on: { hour, minute: 0 },
          repeats: true,
          allowWhileIdle: true,
        },
        sound: 'default',
      });
    }

    await LocalNotifications.schedule({ notifications });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function scheduleMedicationReminder(
  medicationId: string,
  name: string,
  time: string,
  index: number
): Promise<void> {
  const [hour, minute] = time.split(':').map(Number);

  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    const id = NOTIFICATION_IDS.MEDICATION_BASE + index;
    await LocalNotifications.cancel({ notifications: [{ id }] });

    await LocalNotifications.schedule({
      notifications: [
        {
          title: 'Medication Reminder',
          body: `Time to take ${name}`,
          id,
          schedule: {
            on: { hour, minute },
            repeats: true,
            allowWhileIdle: true,
          },
          sound: 'default',
        },
      ],
    });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function cancelAllNotifications(): Promise<void> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');
    const pending = await LocalNotifications.getPending();
    if (pending.notifications.length > 0) {
      await LocalNotifications.cancel({ notifications: pending.notifications });
    }
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function requestNotificationPermission(): Promise<boolean> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');
    const result = await LocalNotifications.requestPermissions();
    return result.display === 'granted';
  } catch {
    // Web fallback
    if (typeof window !== 'undefined' && 'Notification' in window) {
      const result = await Notification.requestPermission();
      return result === 'granted';
    }
    return false;
  }
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/lib/haptics.ts << 'ENDOFFILE'
// Haptic feedback utilities for Capacitor Haptics plugin

export type HapticStyle = 'light' | 'medium' | 'heavy';

export async function triggerHaptic(style: HapticStyle = 'light'): Promise<void> {
  try {
    const { Haptics, ImpactStyle } = await import('@capacitor/haptics');

    const styleMap = {
      light: ImpactStyle.Light,
      medium: ImpactStyle.Medium,
      heavy: ImpactStyle.Heavy,
    };

    await Haptics.impact({ style: styleMap[style] });
  } catch {
    // Haptics not available in web environment
  }
}

export async function triggerNotification(): Promise<void> {
  try {
    const { Haptics, NotificationType } = await import('@capacitor/haptics');
    await Haptics.notification({ type: NotificationType.Success });
  } catch {
    // Haptics not available
  }
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/lib/pdf-export.ts << 'ENDOFFILE'
// PDF export using jspdf
import type { DailyLog } from '@/types';
import { generateDoctorSummary } from './insights-engine';

export async function generatePDFReport(
  logs: DailyLog[],
  days: number
): Promise<Blob | null> {
  try {
    const jsPDF = (await import('jspdf')).default;

    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4',
    });

    const margin = 20;
    const pageWidth = doc.internal.pageSize.getWidth();
    let y = margin;

    // Header
    doc.setFontSize(22);
    doc.setTextColor(13, 115, 119); // primary color
    doc.text('POTSTracker', margin, y);
    y += 8;

    doc.setFontSize(12);
    doc.setTextColor(107, 114, 128);
    doc.text('Dysautonomia Diary - Doctor Visit Report', margin, y);
    y += 10;

    // Horizontal line
    doc.setDrawColor(13, 115, 119);
    doc.setLineWidth(0.5);
    doc.line(margin, y, pageWidth - margin, y);
    y += 8;

    // Summary text
    const summary = generateDoctorSummary(logs, days);
    const lines = summary.split('\n');

    doc.setFontSize(10);
    doc.setTextColor(31, 41, 55);

    for (const line of lines) {
      if (y > 270) {
        doc.addPage();
        y = margin;
      }

      // Section headers
      if (
        line === line.toUpperCase() &&
        line.trim().length > 0 &&
        !line.startsWith(' ') &&
        !line.startsWith('---')
      ) {
        y += 3;
        doc.setFontSize(12);
        doc.setTextColor(13, 115, 119);
        doc.text(line, margin, y);
        doc.setFontSize(10);
        doc.setTextColor(31, 41, 55);
      } else if (line.startsWith('---')) {
        y += 3;
        doc.setDrawColor(229, 231, 235);
        doc.line(margin, y, pageWidth - margin, y);
      } else {
        doc.text(line, margin, y);
      }
      y += 5;
    }

    // Footer
    y += 5;
    doc.setFontSize(8);
    doc.setTextColor(156, 163, 175);
    doc.text(
      `Generated by POTSTracker on ${new Date().toLocaleDateString()}`,
      margin,
      y
    );

    return doc.output('blob');
  } catch (error) {
    console.error('PDF generation failed:', error);
    return null;
  }
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/stores/app-store.ts << 'ENDOFFILE'
'use client';

import { create } from 'zustand';
import type { Profile, NotificationConfig } from '@/types';
import {
  getProfile,
  saveProfile as dbSaveProfile,
  isOnboardingComplete,
  setOnboardingComplete,
} from '@/lib/database';

interface AppState {
  // App state
  initialized: boolean;
  onboardingComplete: boolean;
  darkMode: boolean;
  activeTab: 'log' | 'trends' | 'insights' | 'profile';

  // Profile
  profile: Profile | null;

  // Notifications
  notificationConfig: NotificationConfig;

  // Actions
  initialize: () => Promise<void>;
  setActiveTab: (tab: AppState['activeTab']) => void;
  setDarkMode: (dark: boolean) => void;
  completeOnboarding: () => Promise<void>;
  updateProfile: (profile: Partial<Profile>) => Promise<void>;
  setNotificationConfig: (config: Partial<NotificationConfig>) => void;
}

export const useAppStore = create<AppState>((set, get) => ({
  initialized: false,
  onboardingComplete: false,
  darkMode: false,
  activeTab: 'log',
  profile: null,
  notificationConfig: {
    dailyLogReminder: false,
    dailyLogTime: '20:00',
    hydrationReminder: false,
    hydrationInterval: 2,
    medicationReminders: false,
  },

  initialize: async () => {
    try {
      const onboarded = await isOnboardingComplete();
      const profile = await getProfile();

      // Detect system dark mode
      const prefersDark =
        typeof window !== 'undefined' &&
        window.matchMedia('(prefers-color-scheme: dark)').matches;

      if (prefersDark) {
        document.documentElement.classList.add('dark');
      }

      set({
        initialized: true,
        onboardingComplete: onboarded,
        profile,
        darkMode: prefersDark,
      });
    } catch {
      set({ initialized: true });
    }
  },

  setActiveTab: (tab) => set({ activeTab: tab }),

  setDarkMode: (dark) => {
    if (dark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    set({ darkMode: dark });
  },

  completeOnboarding: async () => {
    await setOnboardingComplete();
    set({ onboardingComplete: true });
  },

  updateProfile: async (profileData) => {
    const updated = await dbSaveProfile(profileData);
    set({ profile: updated });
  },

  setNotificationConfig: (config) => {
    const current = get().notificationConfig;
    set({ notificationConfig: { ...current, ...config } });
  },
}));
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/stores/log-store.ts << 'ENDOFFILE'
'use client';

import { create } from 'zustand';
import type {
  DailyLog,
  SymptomEntry,
  ActivityLevel,
  CyclePhase,
  ExerciseData,
  MedicationTaken,
} from '@/types';
import { getLogByDate, saveLog as dbSaveLog, getToday } from '@/lib/database';
import { getToday as getTodayUtil } from '@/lib/utils';

function createEmptyLog(date: string): DailyLog {
  return {
    log_date: date,
    symptoms: [],
    triggers: [],
    exercise_done: false,
    unrefreshed: false,
    medications_taken: [],
  };
}

interface LogState {
  // Current log being edited
  currentLog: DailyLog;
  currentDate: string;
  isLoading: boolean;
  isSaving: boolean;
  lastSaved: string | null;
  saveSuccess: boolean;

  // Actions
  loadLog: (date: string) => Promise<void>;
  loadToday: () => Promise<void>;
  updateField: <K extends keyof DailyLog>(field: K, value: DailyLog[K]) => void;

  // Heart Rate
  setHRLying: (v?: number) => void;
  setHRSitting: (v?: number) => void;
  setHRStanding: (v?: number) => void;

  // Blood Pressure
  setBPLyingSys: (v?: number) => void;
  setBPLyingDia: (v?: number) => void;
  setBPStandingSys: (v?: number) => void;
  setBPStandingDia: (v?: number) => void;

  // Symptoms
  toggleSymptom: (name: string) => void;
  setSymptomSeverity: (name: string, severity: number) => void;

  // Triggers
  toggleTrigger: (trigger: string) => void;

  // Hydration
  setWaterIntake: (v?: number) => void;
  setElectrolyteOz: (v?: number) => void;
  setSaltIntakeMg: (v?: number) => void;

  // Activity
  setActivityLevel: (v?: ActivityLevel) => void;
  setTimeUpright: (v?: number) => void;
  setExerciseDone: (v: boolean) => void;
  setExerciseData: (v?: ExerciseData) => void;

  // Sleep
  setSleepHours: (v?: number) => void;
  setSleepQuality: (v?: number) => void;
  setUnrefreshed: (v: boolean) => void;

  // Cycle
  setCyclePhase: (v?: CyclePhase) => void;

  // Medications
  setMedicationTaken: (med: MedicationTaken) => void;

  // Other
  setOverallRating: (v?: number) => void;
  setNotes: (v?: string) => void;

  // Save
  save: () => Promise<boolean>;
  clearSaveSuccess: () => void;
}

export const useLogStore = create<LogState>((set, get) => ({
  currentLog: createEmptyLog(getTodayUtil()),
  currentDate: getTodayUtil(),
  isLoading: false,
  isSaving: false,
  lastSaved: null,
  saveSuccess: false,

  loadLog: async (date: string) => {
    set({ isLoading: true, currentDate: date });
    try {
      const log = await getLogByDate(date);
      set({
        currentLog: log || createEmptyLog(date),
        isLoading: false,
        lastSaved: log?.updated_at || null,
      });
    } catch {
      set({ currentLog: createEmptyLog(date), isLoading: false });
    }
  },

  loadToday: async () => {
    await get().loadLog(getTodayUtil());
  },

  updateField: (field, value) => {
    set((state) => ({
      currentLog: { ...state.currentLog, [field]: value },
    }));
  },

  setHRLying: (v) => get().updateField('hr_lying', v),
  setHRSitting: (v) => get().updateField('hr_sitting', v),
  setHRStanding: (v) => get().updateField('hr_standing', v),
  setBPLyingSys: (v) => get().updateField('bp_lying_sys', v),
  setBPLyingDia: (v) => get().updateField('bp_lying_dia', v),
  setBPStandingSys: (v) => get().updateField('bp_standing_sys', v),
  setBPStandingDia: (v) => get().updateField('bp_standing_dia', v),

  toggleSymptom: (name: string) => {
    const { currentLog } = get();
    const existing = currentLog.symptoms.find((s) => s.name === name);
    if (existing) {
      set({
        currentLog: {
          ...currentLog,
          symptoms: currentLog.symptoms.filter((s) => s.name !== name),
        },
      });
    } else {
      set({
        currentLog: {
          ...currentLog,
          symptoms: [...currentLog.symptoms, { name, severity: 3 }],
        },
      });
    }
  },

  setSymptomSeverity: (name: string, severity: number) => {
    const { currentLog } = get();
    set({
      currentLog: {
        ...currentLog,
        symptoms: currentLog.symptoms.map((s) =>
          s.name === name ? { ...s, severity } : s
        ),
      },
    });
  },

  toggleTrigger: (trigger: string) => {
    const { currentLog } = get();
    const has = currentLog.triggers.includes(trigger);
    set({
      currentLog: {
        ...currentLog,
        triggers: has
          ? currentLog.triggers.filter((t) => t !== trigger)
          : [...currentLog.triggers, trigger],
      },
    });
  },

  setWaterIntake: (v) => get().updateField('water_intake', v),
  setElectrolyteOz: (v) => get().updateField('electrolyte_oz', v),
  setSaltIntakeMg: (v) => get().updateField('salt_intake_mg', v),
  setActivityLevel: (v) => get().updateField('activity_level', v),
  setTimeUpright: (v) => get().updateField('time_upright', v),
  setExerciseDone: (v) => get().updateField('exercise_done', v),
  setExerciseData: (v) => get().updateField('exercise_data', v),
  setSleepHours: (v) => get().updateField('sleep_hours', v),
  setSleepQuality: (v) => get().updateField('sleep_quality', v),
  setUnrefreshed: (v) => get().updateField('unrefreshed', v),
  setCyclePhase: (v) => get().updateField('cycle_phase', v),

  setMedicationTaken: (med: MedicationTaken) => {
    const { currentLog } = get();
    const existing = currentLog.medications_taken.findIndex(
      (m) => m.medication_id === med.medication_id
    );
    const updated = [...currentLog.medications_taken];
    if (existing >= 0) {
      updated[existing] = med;
    } else {
      updated.push(med);
    }
    set({ currentLog: { ...currentLog, medications_taken: updated } });
  },

  setOverallRating: (v) => get().updateField('overall_rating', v),
  setNotes: (v) => get().updateField('notes', v),

  save: async () => {
    set({ isSaving: true });
    try {
      const saved = await dbSaveLog(get().currentLog);
      set({
        currentLog: saved,
        isSaving: false,
        lastSaved: saved.updated_at || new Date().toISOString(),
        saveSuccess: true,
      });
      // Auto-clear success after 3 seconds
      setTimeout(() => set({ saveSuccess: false }), 3000);
      return true;
    } catch {
      set({ isSaving: false });
      return false;
    }
  },

  clearSaveSuccess: () => set({ saveSuccess: false }),
}));
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/app/globals.css << 'ENDOFFILE'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --color-primary: 13 115 119;
    --color-accent: 244 132 95;
    --color-success: 46 204 113;
    --color-warning: 243 156 18;
    --color-danger: 231 76 60;
    --color-bg: 248 250 251;
    --color-card: 255 255 255;
    --color-text: 15 25 35;
    --color-text-secondary: 107 114 128;
    --safe-area-top: env(safe-area-inset-top, 0px);
    --safe-area-bottom: env(safe-area-inset-bottom, 0px);
    --safe-area-left: env(safe-area-inset-left, 0px);
    --safe-area-right: env(safe-area-inset-right, 0px);
  }

  .dark {
    --color-bg: 15 25 35;
    --color-card: 28 37 51;
    --color-text: 248 250 251;
    --color-text-secondary: 156 163 175;
  }

  html {
    -webkit-text-size-adjust: 100%;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  body {
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'SF Pro Display',
      system-ui, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background-color: rgb(var(--color-bg));
    color: rgb(var(--color-text));
    overflow-x: hidden;
    -webkit-overflow-scrolling: touch;
    padding-top: var(--safe-area-top);
    padding-bottom: var(--safe-area-bottom);
    padding-left: var(--safe-area-left);
    padding-right: var(--safe-area-right);
  }

  /* Support Dynamic Type */
  @supports (font: -apple-system-body) {
    body {
      font: -apple-system-body;
    }
  }
}

@layer components {
  .card {
    @apply bg-card-light dark:bg-card-dark rounded-card shadow-sm dark:shadow-none
           border border-gray-100 dark:border-gray-800;
  }

  .card-header {
    @apply flex items-center justify-between p-4 pb-2;
  }

  .card-body {
    @apply p-4 pt-2;
  }

  .btn-primary {
    @apply bg-primary text-white font-semibold py-3 px-6 rounded-xl
           min-h-tap min-w-tap flex items-center justify-center
           active:bg-primary-700 transition-colors duration-150;
  }

  .btn-secondary {
    @apply bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-gray-100
           font-semibold py-3 px-6 rounded-xl
           min-h-tap min-w-tap flex items-center justify-center
           active:bg-gray-200 dark:active:bg-gray-700 transition-colors duration-150;
  }

  .btn-danger {
    @apply bg-danger text-white font-semibold py-3 px-6 rounded-xl
           min-h-tap min-w-tap flex items-center justify-center
           active:bg-red-700 transition-colors duration-150;
  }

  .input-field {
    @apply w-full bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700
           rounded-xl px-4 py-3 text-dynamic-base min-h-tap
           focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent
           placeholder-gray-400 dark:placeholder-gray-500
           text-gray-900 dark:text-gray-100;
  }

  .section-title {
    @apply text-dynamic-lg font-bold text-gray-900 dark:text-gray-100;
  }

  .badge-warning {
    @apply inline-flex items-center px-3 py-1 rounded-full text-dynamic-xs
           font-medium bg-warning/20 text-yellow-800 dark:text-yellow-200;
  }

  .badge-danger {
    @apply inline-flex items-center px-3 py-1 rounded-full text-dynamic-xs
           font-medium bg-danger/20 text-red-800 dark:text-red-200;
  }

  .badge-success {
    @apply inline-flex items-center px-3 py-1 rounded-full text-dynamic-xs
           font-medium bg-success/20 text-green-800 dark:text-green-200;
  }

  .tab-bar {
    @apply fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900
           border-t border-gray-200 dark:border-gray-800
           flex items-center justify-around
           pb-[var(--safe-area-bottom)] z-50;
  }

  .tab-item {
    @apply flex flex-col items-center justify-center py-2 px-3
           min-h-tap min-w-tap text-gray-500 dark:text-gray-400
           transition-colors duration-150;
  }

  .tab-item-active {
    @apply text-primary dark:text-primary-300;
  }

  .skeleton {
    @apply animate-pulse bg-gray-200 dark:bg-gray-700 rounded-lg;
  }

  .empty-state {
    @apply flex flex-col items-center justify-center py-12 px-6 text-center;
  }
}

@layer utilities {
  .scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  .scrollbar-hide::-webkit-scrollbar {
    display: none;
  }

  .tap-highlight-none {
    -webkit-tap-highlight-color: transparent;
  }
}

/* Success animation */
@keyframes checkmark {
  0% { transform: scale(0); opacity: 0; }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); opacity: 1; }
}

.animate-checkmark {
  animation: checkmark 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-out forwards;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(100%); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-slide-up {
  animation: slideUp 0.3s ease-out forwards;
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/app/layout.tsx << 'ENDOFFILE'
import type { Metadata, Viewport } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'POTSTracker – Dysautonomia Diary',
  description:
    'Track your POTS and dysautonomia symptoms, vitals, and triggers. Understand patterns and share insights with your care team.',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'default',
    title: 'POTSTracker',
  },
  applicationName: 'POTSTracker',
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  viewportFit: 'cover',
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#F8FAFB' },
    { media: '(prefers-color-scheme: dark)', color: '#0F1923' },
  ],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <link rel="apple-touch-icon" href="/icons/icon-180.png" />
      </head>
      <body className="antialiased">{children}</body>
    </html>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/app/page.tsx << 'ENDOFFILE'
'use client';

import { AppShell } from '@/components/shared/app-shell';

export default function HomePage() {
  return <AppShell />;
}
ENDOFFILE

# ===== Part 3 =====

cat > ~/Desktop/POTSTracker/src/components/ui/collapsible-card.tsx << 'ENDOFFILE'
'use client';

import { useState, type ReactNode } from 'react';
import { ChevronDown, ChevronUp } from 'lucide-react';
import { cn } from '@/lib/utils';

interface CollapsibleCardProps {
  title: string;
  icon: ReactNode;
  children: ReactNode;
  defaultOpen?: boolean;
  className?: string;
}

export function CollapsibleCard({
  title,
  icon,
  children,
  defaultOpen = true,
  className,
}: CollapsibleCardProps) {
  const [isOpen, setIsOpen] = useState(defaultOpen);

  return (
    <div className={cn('card', className)}>
      <button
        className="card-header w-full tap-highlight-none"
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        aria-label={`${title} section, ${isOpen ? 'collapse' : 'expand'}`}
      >
        <div className="flex items-center gap-2">
          <span className="text-primary" aria-hidden="true">{icon}</span>
          <h3 className="section-title">{title}</h3>
        </div>
        {isOpen ? (
          <ChevronUp className="w-5 h-5 text-gray-400" />
        ) : (
          <ChevronDown className="w-5 h-5 text-gray-400" />
        )}
      </button>
      {isOpen && <div className="card-body animate-fade-in">{children}</div>}
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/numeric-input.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface NumericInputProps {
  label: string;
  value?: number;
  onChange: (value?: number) => void;
  unit?: string;
  min?: number;
  max?: number;
  placeholder?: string;
  className?: string;
  accessibilityLabel?: string;
}

export function NumericInput({
  label,
  value,
  onChange,
  unit,
  min = 0,
  max = 999,
  placeholder,
  className,
  accessibilityLabel,
}: NumericInputProps) {
  return (
    <div className={cn('flex flex-col gap-1', className)}>
      <label className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
        {label}
      </label>
      <div className="relative">
        <input
          type="number"
          inputMode="numeric"
          pattern="[0-9]*"
          value={value ?? ''}
          onChange={(e) => {
            const v = e.target.value;
            if (v === '') {
              onChange(undefined);
            } else {
              const num = parseInt(v, 10);
              if (!isNaN(num) && num >= min && num <= max) {
                onChange(num);
              }
            }
          }}
          placeholder={placeholder || label}
          className="input-field pr-12"
          aria-label={accessibilityLabel || label}
          min={min}
          max={max}
        />
        {unit && (
          <span className="absolute right-3 top-1/2 -translate-y-1/2 text-dynamic-sm text-gray-400">
            {unit}
          </span>
        )}
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/severity-slider.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface SeveritySliderProps {
  value: number;
  onChange: (value: number) => void;
  label: string;
  min?: number;
  max?: number;
}

const severityColors = [
  'bg-green-400',
  'bg-yellow-300',
  'bg-yellow-500',
  'bg-orange-500',
  'bg-red-500',
];

const severityLabels = ['Mild', 'Light', 'Moderate', 'Severe', 'Extreme'];

export function SeveritySlider({
  value,
  onChange,
  label,
  min = 1,
  max = 5,
}: SeveritySliderProps) {
  return (
    <div className="flex flex-col gap-1.5">
      <div className="flex justify-between items-center">
        <span className="text-dynamic-sm text-gray-700 dark:text-gray-300 truncate mr-2">
          {label}
        </span>
        <span className={cn(
          'text-dynamic-xs font-medium px-2 py-0.5 rounded-full text-white',
          severityColors[value - 1]
        )}>
          {severityLabels[value - 1]}
        </span>
      </div>
      <div className="flex gap-1.5">
        {Array.from({ length: max - min + 1 }, (_, i) => i + min).map((level) => (
          <button
            key={level}
            onClick={() => onChange(level)}
            className={cn(
              'flex-1 h-8 rounded-lg transition-all min-w-tap min-h-[32px]',
              level <= value
                ? severityColors[level - 1]
                : 'bg-gray-200 dark:bg-gray-700'
            )}
            aria-label={`Set ${label} severity to ${level}: ${severityLabels[level - 1]}`}
          />
        ))}
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/star-rating.tsx << 'ENDOFFILE'
'use client';

import { Star } from 'lucide-react';
import { cn } from '@/lib/utils';

interface StarRatingProps {
  value: number;
  onChange: (value: number) => void;
  max?: number;
  label?: string;
}

export function StarRating({ value, onChange, max = 5, label }: StarRatingProps) {
  return (
    <div className="flex flex-col gap-1">
      {label && (
        <span className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </span>
      )}
      <div className="flex gap-1" role="radiogroup" aria-label={label || 'Rating'}>
        {Array.from({ length: max }, (_, i) => i + 1).map((star) => (
          <button
            key={star}
            onClick={() => onChange(star)}
            className="min-w-tap min-h-tap flex items-center justify-center tap-highlight-none"
            role="radio"
            aria-checked={star === value}
            aria-label={`${star} star${star > 1 ? 's' : ''}`}
          >
            <Star
              className={cn(
                'w-8 h-8 transition-colors',
                star <= value
                  ? 'fill-warning text-warning'
                  : 'fill-none text-gray-300 dark:text-gray-600'
              )}
            />
          </button>
        ))}
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/chip-select.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface ChipSelectProps {
  options: string[];
  selected: string[];
  onChange: (selected: string[]) => void;
  multiSelect?: boolean;
  label?: string;
}

export function ChipSelect({
  options,
  selected,
  onChange,
  multiSelect = true,
  label,
}: ChipSelectProps) {
  const toggle = (option: string) => {
    if (multiSelect) {
      if (selected.includes(option)) {
        onChange(selected.filter((s) => s !== option));
      } else {
        onChange([...selected, option]);
      }
    } else {
      onChange([option]);
    }
  };

  return (
    <div className="flex flex-col gap-2">
      {label && (
        <span className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </span>
      )}
      <div className="flex flex-wrap gap-2" role="group" aria-label={label || 'Select options'}>
        {options.map((option) => {
          const isSelected = selected.includes(option);
          return (
            <button
              key={option}
              onClick={() => toggle(option)}
              className={cn(
                'px-3 py-2 rounded-full text-dynamic-sm font-medium',
                'min-h-tap transition-all tap-highlight-none',
                'border',
                isSelected
                  ? 'bg-primary text-white border-primary'
                  : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
              )}
              role={multiSelect ? 'checkbox' : 'radio'}
              aria-checked={isSelected}
              aria-label={option}
            >
              {option}
            </button>
          );
        })}
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/range-slider.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface RangeSliderProps {
  value: number;
  onChange: (value: number) => void;
  min: number;
  max: number;
  step?: number;
  label: string;
  unit?: string;
  showValue?: boolean;
  className?: string;
}

export function RangeSlider({
  value,
  onChange,
  min,
  max,
  step = 1,
  label,
  unit,
  showValue = true,
  className,
}: RangeSliderProps) {
  const percentage = ((value - min) / (max - min)) * 100;

  return (
    <div className={cn('flex flex-col gap-2', className)}>
      <div className="flex justify-between items-center">
        <label className="text-dynamic-sm text-gray-600 dark:text-gray-400 font-medium">
          {label}
        </label>
        {showValue && (
          <span className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
            {value}
            {unit && <span className="text-dynamic-sm text-gray-500 ml-1">{unit}</span>}
          </span>
        )}
      </div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(e) => onChange(parseFloat(e.target.value))}
        className="w-full h-2 rounded-full appearance-none cursor-pointer
          [&::-webkit-slider-thumb]:appearance-none
          [&::-webkit-slider-thumb]:w-6
          [&::-webkit-slider-thumb]:h-6
          [&::-webkit-slider-thumb]:rounded-full
          [&::-webkit-slider-thumb]:bg-primary
          [&::-webkit-slider-thumb]:shadow-md
          [&::-webkit-slider-thumb]:cursor-pointer"
        style={{
          background: `linear-gradient(to right, #0D7377 0%, #0D7377 ${percentage}%, #d1d5db ${percentage}%, #d1d5db 100%)`,
        }}
        aria-label={label}
        aria-valuemin={min}
        aria-valuemax={max}
        aria-valuenow={value}
      />
      <div className="flex justify-between text-dynamic-xs text-gray-400">
        <span>{min}{unit}</span>
        <span>{max}{unit}</span>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/toggle-switch.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface ToggleSwitchProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label: string;
  description?: string;
}

export function ToggleSwitch({ checked, onChange, label, description }: ToggleSwitchProps) {
  return (
    <button
      className="flex items-center justify-between w-full min-h-tap py-2 tap-highlight-none"
      onClick={() => onChange(!checked)}
      role="switch"
      aria-checked={checked}
      aria-label={label}
    >
      <div className="flex flex-col items-start">
        <span className="text-dynamic-base text-gray-900 dark:text-gray-100">{label}</span>
        {description && (
          <span className="text-dynamic-sm text-gray-500 dark:text-gray-400">{description}</span>
        )}
      </div>
      <div
        className={cn(
          'relative w-12 h-7 rounded-full transition-colors duration-200 flex-shrink-0 ml-3',
          checked ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'
        )}
      >
        <div
          className={cn(
            'absolute top-0.5 w-6 h-6 rounded-full bg-white shadow-md transition-transform duration-200',
            checked ? 'translate-x-[22px]' : 'translate-x-0.5'
          )}
        />
      </div>
    </button>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/empty-state.tsx << 'ENDOFFILE'
'use client';

import { BarChart3 } from 'lucide-react';
import type { ReactNode } from 'react';

interface EmptyStateProps {
  icon?: ReactNode;
  title: string;
  description: string;
  action?: ReactNode;
}

export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
  return (
    <div className="empty-state">
      <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mb-4">
        {icon || <BarChart3 className="w-8 h-8 text-primary" />}
      </div>
      <h3 className="text-dynamic-lg font-semibold text-gray-900 dark:text-gray-100 mb-2">
        {title}
      </h3>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 max-w-xs">
        {description}
      </p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/skeleton-loader.tsx << 'ENDOFFILE'
'use client';

import { cn } from '@/lib/utils';

interface SkeletonProps {
  className?: string;
}

export function Skeleton({ className }: SkeletonProps) {
  return <div className={cn('skeleton', className)} />;
}

export function ChartSkeleton() {
  return (
    <div className="card p-4 space-y-3">
      <Skeleton className="h-5 w-32" />
      <Skeleton className="h-48 w-full" />
      <div className="flex gap-2">
        <Skeleton className="h-4 w-16" />
        <Skeleton className="h-4 w-16" />
        <Skeleton className="h-4 w-16" />
      </div>
    </div>
  );
}

export function CardSkeleton() {
  return (
    <div className="card p-4 space-y-3">
      <Skeleton className="h-5 w-40" />
      <Skeleton className="h-4 w-full" />
      <Skeleton className="h-4 w-3/4" />
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/ui/success-overlay.tsx << 'ENDOFFILE'
'use client';

import { Check } from 'lucide-react';

interface SuccessOverlayProps {
  show: boolean;
  message?: string;
}

export function SuccessOverlay({ show, message = 'Saved!' }: SuccessOverlayProps) {
  if (!show) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 animate-fade-in">
      <div className="bg-white dark:bg-card-dark rounded-2xl p-8 flex flex-col items-center shadow-xl animate-checkmark">
        <div className="w-16 h-16 rounded-full bg-success flex items-center justify-center mb-3">
          <Check className="w-10 h-10 text-white" strokeWidth={3} />
        </div>
        <span className="text-dynamic-lg font-semibold text-gray-900 dark:text-gray-100">
          {message}
        </span>
      </div>
    </div>
  );
}
ENDOFFILE

# ===== Part 4 =====

cat > ~/Desktop/POTSTracker/src/components/onboarding/onboarding-flow.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { WelcomeScreen } from './welcome-screen';
import { PersonalizationScreen } from './personalization-screen';
import { PermissionsScreen } from './permissions-screen';
import { useAppStore } from '@/stores/app-store';
import type { DiagnosisType } from '@/types';
import { DEFAULT_TRIGGERS } from '@/types';

export function OnboardingFlow() {
  const [step, setStep] = useState(0);
  const { completeOnboarding, updateProfile } = useAppStore();

  // Personalization state
  const [diagnosis, setDiagnosis] = useState<DiagnosisType>('Undiagnosed');
  const [triggers, setTriggers] = useState<string[]>([]);
  const [medications, setMedications] = useState('');

  const handlePersonalizationDone = async () => {
    await updateProfile({
      diagnosis_type: diagnosis,
      custom_triggers: triggers,
      medications: medications
        ? medications.split(',').map((m) => ({
            id: crypto.randomUUID?.() || Math.random().toString(36).slice(2),
            name: m.trim(),
            dosage: '',
            time_of_day: 'morning' as const,
            reminder_enabled: false,
          }))
        : [],
    });
    setStep(2);
  };

  const handleComplete = async () => {
    await completeOnboarding();
  };

  return (
    <div className="min-h-screen bg-bg-light dark:bg-bg-dark">
      {/* Progress dots */}
      <div className="flex justify-center gap-2 pt-safe-top pt-4 pb-2">
        {[0, 1, 2].map((i) => (
          <div
            key={i}
            className={`w-2.5 h-2.5 rounded-full transition-colors ${
              i === step ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'
            }`}
            aria-label={`Step ${i + 1} of 3${i === step ? ', current' : ''}`}
          />
        ))}
      </div>

      {step === 0 && <WelcomeScreen onNext={() => setStep(1)} />}
      {step === 1 && (
        <PersonalizationScreen
          diagnosis={diagnosis}
          setDiagnosis={setDiagnosis}
          triggers={triggers}
          setTriggers={setTriggers}
          medications={medications}
          setMedications={setMedications}
          onNext={handlePersonalizationDone}
          onBack={() => setStep(0)}
        />
      )}
      {step === 2 && (
        <PermissionsScreen onComplete={handleComplete} onBack={() => setStep(1)} />
      )}
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/welcome-screen.tsx << 'ENDOFFILE'
'use client';

import { Heart, Activity, TrendingUp } from 'lucide-react';

interface WelcomeScreenProps {
  onNext: () => void;
}

export function WelcomeScreen({ onNext }: WelcomeScreenProps) {
  return (
    <div className="flex flex-col items-center justify-between min-h-[calc(100vh-60px)] px-6 py-8">
      <div className="flex-1 flex flex-col items-center justify-center text-center">
        {/* App Icon */}
        <div className="w-24 h-24 rounded-3xl bg-primary flex items-center justify-center mb-6 shadow-lg">
          <Heart className="w-12 h-12 text-white" fill="white" />
        </div>

        <h1 className="text-dynamic-3xl font-bold text-gray-900 dark:text-gray-100 mb-2">
          POTSTracker
        </h1>
        <p className="text-dynamic-lg text-primary font-medium mb-6">
          Track. Understand. Thrive.
        </p>

        <p className="text-dynamic-base text-gray-600 dark:text-gray-400 max-w-sm mb-8 leading-relaxed">
          Your personal dysautonomia diary. Track symptoms, vitals, and triggers
          to better understand your body and share insights with your care team.
        </p>

        {/* Feature highlights */}
        <div className="space-y-4 w-full max-w-sm">
          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0">
              <Activity className="w-5 h-5 text-primary" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Log Daily Vitals
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Heart rate, blood pressure, symptoms & more
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center flex-shrink-0">
              <TrendingUp className="w-5 h-5 text-accent" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Discover Patterns
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Charts and insights to understand your triggers
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-success/10 flex items-center justify-center flex-shrink-0">
              <Heart className="w-5 h-5 text-success" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Share with Doctors
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Export reports for your medical appointments
              </p>
            </div>
          </div>
        </div>
      </div>

      <button
        onClick={onNext}
        className="btn-primary w-full max-w-sm text-dynamic-lg mt-8"
        aria-label="Get Started"
      >
        Get Started
      </button>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/personalization-screen.tsx << 'ENDOFFILE'
'use client';

import { ChevronLeft } from 'lucide-react';
import { ChipSelect } from '@/components/ui/chip-select';
import { DIAGNOSIS_TYPES, DEFAULT_TRIGGERS, type DiagnosisType } from '@/types';

interface PersonalizationScreenProps {
  diagnosis: DiagnosisType;
  setDiagnosis: (d: DiagnosisType) => void;
  triggers: string[];
  setTriggers: (t: string[]) => void;
  medications: string;
  setMedications: (m: string) => void;
  onNext: () => void;
  onBack: () => void;
}

export function PersonalizationScreen({
  diagnosis,
  setDiagnosis,
  triggers,
  setTriggers,
  medications,
  setMedications,
  onNext,
  onBack,
}: PersonalizationScreenProps) {
  return (
    <div className="flex flex-col min-h-[calc(100vh-60px)] px-6 py-4">
      <button
        onClick={onBack}
        className="flex items-center gap-1 text-primary min-h-tap self-start mb-4"
        aria-label="Go back"
      >
        <ChevronLeft className="w-5 h-5" />
        <span className="text-dynamic-base">Back</span>
      </button>

      <h2 className="text-dynamic-2xl font-bold text-gray-900 dark:text-gray-100 mb-1">
        Personalize Your Experience
      </h2>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mb-6">
        Help us tailor the app to your needs. You can change these later.
      </p>

      <div className="flex-1 space-y-6 overflow-y-auto scrollbar-hide pb-4">
        {/* Diagnosis Type */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-3">
            Diagnosis Type
          </label>
          <div className="space-y-2">
            {DIAGNOSIS_TYPES.map((type) => (
              <button
                key={type}
                onClick={() => setDiagnosis(type)}
                className={`w-full text-left px-4 py-3 rounded-xl min-h-tap transition-all border ${
                  diagnosis === type
                    ? 'bg-primary/10 border-primary text-primary font-medium'
                    : 'bg-gray-50 dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300'
                }`}
                role="radio"
                aria-checked={diagnosis === type}
              >
                {type}
              </button>
            ))}
          </div>
        </div>

        {/* Triggers */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-3">
            Primary Triggers to Track
          </label>
          <p className="text-dynamic-sm text-gray-500 mb-3">Select all that apply</p>
          <ChipSelect
            options={[...DEFAULT_TRIGGERS]}
            selected={triggers}
            onChange={setTriggers}
          />
        </div>

        {/* Medications */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-2">
            Current Medications
          </label>
          <p className="text-dynamic-sm text-gray-500 mb-3">
            Optional — separate multiple with commas
          </p>
          <textarea
            value={medications}
            onChange={(e) => setMedications(e.target.value)}
            placeholder="e.g., Fludrocortisone, Midodrine, Metoprolol"
            className="input-field min-h-[80px] resize-none"
            aria-label="Current medications"
          />
        </div>
      </div>

      <button
        onClick={onNext}
        className="btn-primary w-full text-dynamic-lg mt-4"
        aria-label="Continue to permissions"
      >
        Continue
      </button>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/permissions-screen.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { ChevronLeft, Heart, Bell, Shield } from 'lucide-react';

interface PermissionsScreenProps {
  onComplete: () => void;
  onBack: () => void;
}

export function PermissionsScreen({ onComplete, onBack }: PermissionsScreenProps) {
  const [healthKitGranted, setHealthKitGranted] = useState<boolean | null>(null);
  const [notificationsGranted, setNotificationsGranted] = useState<boolean | null>(null);

  const requestHealthKit = async () => {
    // In a real Capacitor build, this would call the HealthKit plugin
    // For now, simulate the request
    try {
      setHealthKitGranted(true);
    } catch {
      setHealthKitGranted(false);
    }
  };

  const requestNotifications = async () => {
    // In a real Capacitor build, this would call LocalNotifications.requestPermissions()
    try {
      if (typeof window !== 'undefined' && 'Notification' in window) {
        const result = await Notification.requestPermission();
        setNotificationsGranted(result === 'granted');
      } else {
        setNotificationsGranted(true);
      }
    } catch {
      setNotificationsGranted(false);
    }
  };

  return (
    <div className="flex flex-col min-h-[calc(100vh-60px)] px-6 py-4">
      <button
        onClick={onBack}
        className="flex items-center gap-1 text-primary min-h-tap self-start mb-4"
        aria-label="Go back"
      >
        <ChevronLeft className="w-5 h-5" />
        <span className="text-dynamic-base">Back</span>
      </button>

      <h2 className="text-dynamic-2xl font-bold text-gray-900 dark:text-gray-100 mb-1">
        Permissions
      </h2>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mb-8">
        These are optional. You can enable them later in Settings.
      </p>

      <div className="flex-1 space-y-4">
        {/* HealthKit */}
        <div className="card p-4">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-red-50 dark:bg-red-900/20 flex items-center justify-center flex-shrink-0">
              <Heart className="w-5 h-5 text-red-500" />
            </div>
            <div className="flex-1">
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Apple Health
              </h3>
              <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mt-1">
                Import heart rate and step count data automatically. Your health data
                stays on your device and is never sent to any server.
              </p>
              <button
                onClick={requestHealthKit}
                disabled={healthKitGranted !== null}
                className={`mt-3 px-4 py-2 rounded-xl min-h-tap text-dynamic-sm font-medium transition-colors ${
                  healthKitGranted === true
                    ? 'bg-success/20 text-green-700 dark:text-green-300'
                    : healthKitGranted === false
                    ? 'bg-gray-100 dark:bg-gray-800 text-gray-500'
                    : 'bg-primary text-white'
                }`}
                aria-label={
                  healthKitGranted === true
                    ? 'Apple Health connected'
                    : 'Connect Apple Health'
                }
              >
                {healthKitGranted === true
                  ? 'Connected'
                  : healthKitGranted === false
                  ? 'Skipped'
                  : 'Connect Apple Health'}
              </button>
            </div>
          </div>
        </div>

        {/* Notifications */}
        <div className="card p-4">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center flex-shrink-0">
              <Bell className="w-5 h-5 text-blue-500" />
            </div>
            <div className="flex-1">
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Notifications
              </h3>
              <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mt-1">
                Get daily reminders to log your vitals, take medications, and stay hydrated.
                You control exactly which reminders you receive.
              </p>
              <button
                onClick={requestNotifications}
                disabled={notificationsGranted !== null}
                className={`mt-3 px-4 py-2 rounded-xl min-h-tap text-dynamic-sm font-medium transition-colors ${
                  notificationsGranted === true
                    ? 'bg-success/20 text-green-700 dark:text-green-300'
                    : notificationsGranted === false
                    ? 'bg-gray-100 dark:bg-gray-800 text-gray-500'
                    : 'bg-primary text-white'
                }`}
                aria-label={
                  notificationsGranted === true
                    ? 'Notifications enabled'
                    : 'Enable notifications'
                }
              >
                {notificationsGranted === true
                  ? 'Enabled'
                  : notificationsGranted === false
                  ? 'Skipped'
                  : 'Enable Notifications'}
              </button>
            </div>
          </div>
        </div>

        {/* Privacy note */}
        <div className="flex items-start gap-3 px-2 py-3">
          <Shield className="w-5 h-5 text-primary flex-shrink-0 mt-0.5" />
          <p className="text-dynamic-sm text-gray-500 dark:text-gray-400">
            Your data is stored locally on your device. POTSTracker never sends your
            health information to external servers.
          </p>
        </div>
      </div>

      <div className="space-y-3 mt-4">
        <button
          onClick={onComplete}
          className="btn-primary w-full text-dynamic-lg"
          aria-label="Start using POTSTracker"
        >
          Start Tracking
        </button>
        <button
          onClick={onComplete}
          className="w-full text-center text-dynamic-sm text-gray-500 min-h-tap flex items-center justify-center"
          aria-label="Skip permissions and start"
        >
          Skip for now
        </button>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/shared/tab-navigation.tsx << 'ENDOFFILE'
'use client';

import { ClipboardList, TrendingUp, Lightbulb, User } from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { cn } from '@/lib/utils';

const tabs = [
  { id: 'log' as const, label: 'Log Today', icon: ClipboardList },
  { id: 'trends' as const, label: 'Trends', icon: TrendingUp },
  { id: 'insights' as const, label: 'Insights', icon: Lightbulb },
  { id: 'profile' as const, label: 'Profile', icon: User },
];

export function TabNavigation() {
  const { activeTab, setActiveTab } = useAppStore();

  return (
    <nav className="tab-bar" role="tablist" aria-label="Main navigation">
      {tabs.map(({ id, label, icon: Icon }) => (
        <button
          key={id}
          onClick={() => setActiveTab(id)}
          className={cn('tab-item', activeTab === id && 'tab-item-active')}
          role="tab"
          aria-selected={activeTab === id}
          aria-label={label}
        >
          <Icon className="w-6 h-6" />
          <span className="text-[10px] mt-0.5 font-medium">{label}</span>
        </button>
      ))}
    </nav>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/shared/app-shell.tsx << 'ENDOFFILE'
'use client';

import { useEffect } from 'react';
import { useAppStore } from '@/stores/app-store';
import { OnboardingFlow } from '@/components/onboarding/onboarding-flow';
import { DailyLogScreen } from '@/components/log/daily-log-screen';
import { TrendsScreen } from '@/components/trends/trends-screen';
import { InsightsScreen } from '@/components/insights/insights-screen';
import { ProfileScreen } from '@/components/profile/profile-screen';
import { TabNavigation } from './tab-navigation';

export function AppShell() {
  const { initialized, onboardingComplete, activeTab, initialize } = useAppStore();

  useEffect(() => {
    initialize();
  }, [initialize]);

  // Loading screen
  if (!initialized) {
    return (
      <div className="min-h-screen bg-primary flex items-center justify-center">
        <div className="text-center">
          <div className="w-20 h-20 rounded-3xl bg-white/20 flex items-center justify-center mx-auto mb-4">
            <svg className="w-10 h-10 text-white" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-white">POTSTracker</h1>
          <p className="text-white/70 mt-1">Loading...</p>
        </div>
      </div>
    );
  }

  // Show onboarding if not completed
  if (!onboardingComplete) {
    return <OnboardingFlow />;
  }

  // Main app
  return (
    <div className="min-h-screen bg-bg-light dark:bg-bg-dark">
      <main>
        {activeTab === 'log' && <DailyLogScreen />}
        {activeTab === 'trends' && <TrendsScreen />}
        {activeTab === 'insights' && <InsightsScreen />}
        {activeTab === 'profile' && <ProfileScreen />}
      </main>
      <TabNavigation />
    </div>
  );
}
ENDOFFILE

# ===== Part 5 =====

cat > ~/Desktop/POTSTracker/src/components/log/heart-rate-section.tsx << 'ENDOFFILE'
'use client';

import { Heart, Download } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { NumericInput } from '@/components/ui/numeric-input';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { checkOrthostatic, getAgeFromDob } from '@/lib/utils';

export function HeartRateSection() {
  const {
    currentLog,
    setHRLying,
    setHRSitting,
    setHRStanding,
  } = useLogStore();
  const profile = useAppStore((s) => s.profile);

  const isUnder19 = profile?.dob ? getAgeFromDob(profile.dob) < 19 : false;
  const ortho = checkOrthostatic(currentLog.hr_lying, currentLog.hr_standing, isUnder19);

  return (
    <CollapsibleCard title="Heart Rate" icon={<Heart className="w-5 h-5" />}>
      <div className="space-y-3">
        <div className="grid grid-cols-3 gap-3">
          <NumericInput
            label="Lying"
            value={currentLog.hr_lying}
            onChange={setHRLying}
            unit="BPM"
            min={30}
            max={250}
            accessibilityLabel="Lying heart rate in beats per minute"
          />
          <NumericInput
            label="Sitting"
            value={currentLog.hr_sitting}
            onChange={setHRSitting}
            unit="BPM"
            min={30}
            max={250}
            accessibilityLabel="Sitting heart rate in beats per minute"
          />
          <NumericInput
            label="Standing"
            value={currentLog.hr_standing}
            onChange={setHRStanding}
            unit="BPM"
            min={30}
            max={250}
            accessibilityLabel="Standing heart rate in beats per minute"
          />
        </div>

        {/* Orthostatic delta */}
        {ortho.delta !== null && (
          <div className="flex items-center justify-between bg-gray-50 dark:bg-gray-800 rounded-xl p-3">
            <div>
              <span className="text-dynamic-sm text-gray-500">Orthostatic Delta</span>
              <p className="text-dynamic-lg font-bold text-gray-900 dark:text-gray-100">
                +{ortho.delta} BPM
              </p>
            </div>
            {ortho.met && (
              <div className="badge-warning" role="alert">
                Possible POTS criteria met ({'\u2265'}{ortho.threshold} BPM increase)
              </div>
            )}
          </div>
        )}

        {/* Import from Health */}
        <button
          className="flex items-center gap-2 text-primary text-dynamic-sm font-medium min-h-tap"
          aria-label="Import heart rate from Apple Health"
        >
          <Download className="w-4 h-4" />
          Import from Apple Health
        </button>
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/blood-pressure-section.tsx << 'ENDOFFILE'
'use client';

import { Activity } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { NumericInput } from '@/components/ui/numeric-input';
import { useLogStore } from '@/stores/log-store';
import { checkOrthostaticHypotension } from '@/lib/utils';

export function BloodPressureSection() {
  const {
    currentLog,
    setBPLyingSys,
    setBPLyingDia,
    setBPStandingSys,
    setBPStandingDia,
  } = useLogStore();

  const oh = checkOrthostaticHypotension(
    currentLog.bp_lying_sys,
    currentLog.bp_lying_dia,
    currentLog.bp_standing_sys,
    currentLog.bp_standing_dia
  );

  return (
    <CollapsibleCard title="Blood Pressure" icon={<Activity className="w-5 h-5" />}>
      <div className="space-y-4">
        {/* Lying */}
        <div>
          <span className="text-dynamic-sm font-medium text-gray-500 dark:text-gray-400 mb-2 block">
            Lying Down
          </span>
          <div className="grid grid-cols-2 gap-3">
            <NumericInput
              label="Systolic"
              value={currentLog.bp_lying_sys}
              onChange={setBPLyingSys}
              unit="mmHg"
              min={60}
              max={250}
              accessibilityLabel="Lying systolic blood pressure"
            />
            <NumericInput
              label="Diastolic"
              value={currentLog.bp_lying_dia}
              onChange={setBPLyingDia}
              unit="mmHg"
              min={30}
              max={150}
              accessibilityLabel="Lying diastolic blood pressure"
            />
          </div>
        </div>

        {/* Standing */}
        <div>
          <span className="text-dynamic-sm font-medium text-gray-500 dark:text-gray-400 mb-2 block">
            Standing
          </span>
          <div className="grid grid-cols-2 gap-3">
            <NumericInput
              label="Systolic"
              value={currentLog.bp_standing_sys}
              onChange={setBPStandingSys}
              unit="mmHg"
              min={60}
              max={250}
              accessibilityLabel="Standing systolic blood pressure"
            />
            <NumericInput
              label="Diastolic"
              value={currentLog.bp_standing_dia}
              onChange={setBPStandingDia}
              unit="mmHg"
              min={30}
              max={150}
              accessibilityLabel="Standing diastolic blood pressure"
            />
          </div>
        </div>

        {/* Orthostatic hypotension warning */}
        {oh.met && (
          <div className="badge-danger" role="alert">
            Possible orthostatic hypotension detected
            {oh.sysDrop !== null && ` (systolic drop: ${oh.sysDrop} mmHg`}
            {oh.diaDrop !== null && `, diastolic drop: ${oh.diaDrop} mmHg)`}
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/symptoms-section.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { AlertCircle, Plus } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { SeveritySlider } from '@/components/ui/severity-slider';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { DEFAULT_SYMPTOMS } from '@/types';
import { cn } from '@/lib/utils';

export function SymptomsSection() {
  const { currentLog, toggleSymptom, setSymptomSeverity } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const [customSymptom, setCustomSymptom] = useState('');
  const [showCustomInput, setShowCustomInput] = useState(false);

  const allSymptoms = [
    ...DEFAULT_SYMPTOMS,
    ...(profile?.custom_symptoms || []),
  ];

  const selectedNames = currentLog.symptoms.map((s) => s.name);

  const addCustomSymptom = () => {
    if (customSymptom.trim()) {
      toggleSymptom(customSymptom.trim());
      setCustomSymptom('');
      setShowCustomInput(false);
    }
  };

  return (
    <CollapsibleCard title="Symptoms" icon={<AlertCircle className="w-5 h-5" />}>
      <div className="space-y-4">
        {/* Symptom chips */}
        <div className="flex flex-wrap gap-2">
          {allSymptoms.map((symptom) => {
            const isSelected = selectedNames.includes(symptom);
            return (
              <button
                key={symptom}
                onClick={() => toggleSymptom(symptom)}
                className={cn(
                  'px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap',
                  'transition-all tap-highlight-none border',
                  isSelected
                    ? 'bg-accent text-white border-accent'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="checkbox"
                aria-checked={isSelected}
                aria-label={`${symptom}${isSelected ? ', selected' : ''}`}
              >
                {symptom}
              </button>
            );
          })}
          <button
            onClick={() => setShowCustomInput(true)}
            className="px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap
              border border-dashed border-gray-300 dark:border-gray-600
              text-gray-500 dark:text-gray-400 flex items-center gap-1"
            aria-label="Add custom symptom"
          >
            <Plus className="w-4 h-4" />
            Custom
          </button>
        </div>

        {/* Custom symptom input */}
        {showCustomInput && (
          <div className="flex gap-2">
            <input
              type="text"
              value={customSymptom}
              onChange={(e) => setCustomSymptom(e.target.value)}
              placeholder="Enter custom symptom"
              className="input-field flex-1"
              onKeyDown={(e) => e.key === 'Enter' && addCustomSymptom()}
              aria-label="Custom symptom name"
              autoFocus
            />
            <button onClick={addCustomSymptom} className="btn-primary px-4" aria-label="Add symptom">
              Add
            </button>
          </div>
        )}

        {/* Severity sliders for selected symptoms */}
        {currentLog.symptoms.length > 0 && (
          <div className="space-y-3 pt-2">
            <p className="text-dynamic-sm font-medium text-gray-500">Severity (1-5)</p>
            {currentLog.symptoms.map((symptom) => (
              <SeveritySlider
                key={symptom.name}
                label={symptom.name}
                value={symptom.severity}
                onChange={(v) => setSymptomSeverity(symptom.name, v)}
              />
            ))}
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/hydration-section.tsx << 'ENDOFFILE'
'use client';

import { Droplets } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { NumericInput } from '@/components/ui/numeric-input';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { useState } from 'react';

export function HydrationSection() {
  const { currentLog, setWaterIntake, setElectrolyteOz, setSaltIntakeMg } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const isMetric = profile?.units === 'metric';
  const [showElectrolytes, setShowElectrolytes] = useState(!!currentLog.electrolyte_oz);
  const [saltGrams, setSaltGrams] = useState<number | undefined>(undefined);

  const handleSaltGramsChange = (g?: number) => {
    setSaltGrams(g);
    if (g !== undefined) {
      setSaltIntakeMg(Math.round(g * 393));
    } else {
      setSaltIntakeMg(undefined);
    }
  };

  return (
    <CollapsibleCard title="Hydration & Salt" icon={<Droplets className="w-5 h-5" />}>
      <div className="space-y-4">
        <NumericInput
          label={`Water Intake (${isMetric ? 'mL' : 'oz'})`}
          value={currentLog.water_intake}
          onChange={setWaterIntake}
          unit={isMetric ? 'mL' : 'oz'}
          min={0}
          max={isMetric ? 10000 : 300}
          accessibilityLabel={`Water intake in ${isMetric ? 'milliliters' : 'ounces'}`}
        />

        <ToggleSwitch
          checked={showElectrolytes}
          onChange={(v) => {
            setShowElectrolytes(v);
            if (!v) setElectrolyteOz(undefined);
          }}
          label="Electrolyte Drinks"
        />

        {showElectrolytes && (
          <NumericInput
            label={`Electrolytes (${isMetric ? 'mL' : 'oz'})`}
            value={currentLog.electrolyte_oz}
            onChange={setElectrolyteOz}
            unit={isMetric ? 'mL' : 'oz'}
            min={0}
            max={isMetric ? 5000 : 150}
            accessibilityLabel="Electrolyte drink intake"
          />
        )}

        <div className="grid grid-cols-2 gap-3">
          <NumericInput
            label="Salt (grams)"
            value={saltGrams}
            onChange={handleSaltGramsChange}
            unit="g"
            min={0}
            max={50}
            accessibilityLabel="Salt intake in grams"
          />
          <NumericInput
            label="Sodium (mg)"
            value={currentLog.salt_intake_mg}
            onChange={setSaltIntakeMg}
            unit="mg"
            min={0}
            max={20000}
            accessibilityLabel="Sodium intake in milligrams"
          />
        </div>
        <p className="text-dynamic-xs text-gray-400">
          1g salt = ~393mg sodium. Enter either field.
        </p>
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/activity-section.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { Footprints } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { NumericInput } from '@/components/ui/numeric-input';
import { useLogStore } from '@/stores/log-store';
import { ACTIVITY_LEVELS, EXERCISE_TYPES, type ActivityLevel, type ExerciseData } from '@/types';
import { cn } from '@/lib/utils';

export function ActivitySection() {
  const {
    currentLog,
    setActivityLevel,
    setTimeUpright,
    setExerciseDone,
    setExerciseData,
  } = useLogStore();

  const [exerciseType, setExerciseType] = useState<ExerciseData['type']>(
    currentLog.exercise_data?.type || 'Walking'
  );
  const [exerciseDuration, setExerciseDuration] = useState<number>(
    currentLog.exercise_data?.duration || 30
  );
  const [exerciseIntensity, setExerciseIntensity] = useState<number>(
    currentLog.exercise_data?.intensity || 5
  );

  const updateExercise = (updates: Partial<ExerciseData>) => {
    const data: ExerciseData = {
      type: exerciseType,
      duration: exerciseDuration,
      intensity: exerciseIntensity,
      ...updates,
    };
    if (updates.type) setExerciseType(updates.type);
    if (updates.duration !== undefined) setExerciseDuration(updates.duration);
    if (updates.intensity !== undefined) setExerciseIntensity(updates.intensity);
    setExerciseData(data);
  };

  return (
    <CollapsibleCard title="Activity & Posture" icon={<Footprints className="w-5 h-5" />}>
      <div className="space-y-4">
        {/* Activity Level */}
        <div>
          <span className="text-dynamic-sm font-medium text-gray-600 dark:text-gray-400 mb-2 block">
            Activity Level Today
          </span>
          <div className="flex flex-wrap gap-2">
            {ACTIVITY_LEVELS.map((level) => (
              <button
                key={level}
                onClick={() => setActivityLevel(level)}
                className={cn(
                  'px-3 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all border',
                  currentLog.activity_level === level
                    ? 'bg-primary text-white border-primary'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="radio"
                aria-checked={currentLog.activity_level === level}
                aria-label={`Activity level: ${level}`}
              >
                {level}
              </button>
            ))}
          </div>
        </div>

        {/* Time Upright */}
        <RangeSlider
          label="Time Spent Upright"
          value={currentLog.time_upright || 0}
          onChange={setTimeUpright}
          min={0}
          max={16}
          step={0.5}
          unit=" hrs"
        />

        {/* Exercise */}
        <ToggleSwitch
          checked={currentLog.exercise_done}
          onChange={(v) => {
            setExerciseDone(v);
            if (!v) setExerciseData(undefined);
          }}
          label="Exercise Performed"
        />

        {currentLog.exercise_done && (
          <div className="space-y-3 pl-2 border-l-2 border-primary/20">
            {/* Exercise Type */}
            <div className="flex flex-wrap gap-2">
              {EXERCISE_TYPES.map((type) => (
                <button
                  key={type}
                  onClick={() => updateExercise({ type: type as ExerciseData['type'] })}
                  className={cn(
                    'px-3 py-2 rounded-lg text-dynamic-sm min-h-tap border',
                    exerciseType === type
                      ? 'bg-primary/10 border-primary text-primary'
                      : 'bg-gray-50 dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400'
                  )}
                  aria-label={`Exercise type: ${type}`}
                >
                  {type}
                </button>
              ))}
            </div>

            <NumericInput
              label="Duration"
              value={exerciseDuration}
              onChange={(v) => updateExercise({ duration: v || 0 })}
              unit="min"
              min={0}
              max={300}
              accessibilityLabel="Exercise duration in minutes"
            />

            <RangeSlider
              label="Intensity"
              value={exerciseIntensity}
              onChange={(v) => updateExercise({ intensity: v })}
              min={1}
              max={10}
            />
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/sleep-section.tsx << 'ENDOFFILE'
'use client';

import { Moon } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { StarRating } from '@/components/ui/star-rating';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { useLogStore } from '@/stores/log-store';

export function SleepSection() {
  const { currentLog, setSleepHours, setSleepQuality, setUnrefreshed } = useLogStore();

  return (
    <CollapsibleCard title="Sleep" icon={<Moon className="w-5 h-5" />}>
      <div className="space-y-4">
        <RangeSlider
          label="Hours Slept"
          value={currentLog.sleep_hours || 0}
          onChange={setSleepHours}
          min={0}
          max={14}
          step={0.5}
          unit=" hrs"
        />

        <StarRating
          label="Sleep Quality"
          value={currentLog.sleep_quality || 0}
          onChange={setSleepQuality}
        />

        <ToggleSwitch
          checked={currentLog.unrefreshed}
          onChange={setUnrefreshed}
          label="Woke Up Unrefreshed"
        />
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/triggers-section.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { Zap, Plus } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { DEFAULT_TRIGGERS } from '@/types';
import { cn } from '@/lib/utils';

export function TriggersSection() {
  const { currentLog, toggleTrigger } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const [customTrigger, setCustomTrigger] = useState('');
  const [showCustom, setShowCustom] = useState(false);

  const allTriggers = [
    ...DEFAULT_TRIGGERS,
    ...(profile?.custom_triggers || []),
  ];

  const addCustomTrigger = () => {
    if (customTrigger.trim()) {
      toggleTrigger(customTrigger.trim());
      setCustomTrigger('');
      setShowCustom(false);
    }
  };

  return (
    <CollapsibleCard title="Triggers Today" icon={<Zap className="w-5 h-5" />}>
      <div className="space-y-3">
        <div className="flex flex-wrap gap-2">
          {allTriggers.map((trigger) => {
            const isSelected = currentLog.triggers.includes(trigger);
            return (
              <button
                key={trigger}
                onClick={() => toggleTrigger(trigger)}
                className={cn(
                  'px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap border transition-all',
                  isSelected
                    ? 'bg-warning/20 text-yellow-800 dark:text-yellow-200 border-warning'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="checkbox"
                aria-checked={isSelected}
                aria-label={`Trigger: ${trigger}`}
              >
                {trigger}
              </button>
            );
          })}
          <button
            onClick={() => setShowCustom(true)}
            className="px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap
              border border-dashed border-gray-300 dark:border-gray-600
              text-gray-500 flex items-center gap-1"
            aria-label="Add custom trigger"
          >
            <Plus className="w-4 h-4" />
            Custom
          </button>
        </div>

        {showCustom && (
          <div className="flex gap-2">
            <input
              type="text"
              value={customTrigger}
              onChange={(e) => setCustomTrigger(e.target.value)}
              placeholder="Enter custom trigger"
              className="input-field flex-1"
              onKeyDown={(e) => e.key === 'Enter' && addCustomTrigger()}
              aria-label="Custom trigger name"
              autoFocus
            />
            <button onClick={addCustomTrigger} className="btn-primary px-4" aria-label="Add trigger">
              Add
            </button>
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/cycle-section.tsx << 'ENDOFFILE'
'use client';

import { Calendar } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { cn } from '@/lib/utils';
import type { CyclePhase } from '@/types';

const phases: { value: CyclePhase; label: string }[] = [
  { value: 'on-period', label: 'On Period' },
  { value: 'pre-period', label: 'Pre-Period' },
  { value: 'mid-cycle', label: 'Mid-Cycle' },
  { value: 'post-period', label: 'Post-Period' },
];

export function CycleSection() {
  const { currentLog, setCyclePhase } = useLogStore();

  return (
    <CollapsibleCard
      title="Menstrual Cycle"
      icon={<Calendar className="w-5 h-5" />}
      defaultOpen={false}
    >
      <div className="flex flex-wrap gap-2">
        {phases.map(({ value, label }) => (
          <button
            key={value}
            onClick={() =>
              setCyclePhase(currentLog.cycle_phase === value ? undefined : value)
            }
            className={cn(
              'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap border transition-all',
              currentLog.cycle_phase === value
                ? 'bg-accent/20 text-accent border-accent'
                : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
            )}
            role="radio"
            aria-checked={currentLog.cycle_phase === value}
            aria-label={`Cycle phase: ${label}`}
          >
            {label}
          </button>
        ))}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/medications-section.tsx << 'ENDOFFILE'
'use client';

import { Pill } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { cn } from '@/lib/utils';
import type { MedicationTaken } from '@/types';

const statusOptions: { value: MedicationTaken['status']; label: string; color: string }[] = [
  { value: 'taken', label: 'Taken', color: 'bg-success/20 text-green-700 dark:text-green-300 border-success' },
  { value: 'skipped', label: 'Skipped', color: 'bg-warning/20 text-yellow-700 dark:text-yellow-300 border-warning' },
  { value: 'dose-changed', label: 'Dose Changed', color: 'bg-primary/20 text-primary border-primary' },
];

export function MedicationsSection() {
  const { currentLog, setMedicationTaken } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const medications = profile?.medications || [];

  if (medications.length === 0) {
    return (
      <CollapsibleCard title="Medications" icon={<Pill className="w-5 h-5" />} defaultOpen={false}>
        <p className="text-dynamic-sm text-gray-500 dark:text-gray-400">
          No medications added yet. Add medications in your Profile settings.
        </p>
      </CollapsibleCard>
    );
  }

  return (
    <CollapsibleCard title="Medications" icon={<Pill className="w-5 h-5" />}>
      <div className="space-y-3">
        {medications.map((med) => {
          const taken = currentLog.medications_taken.find(
            (m) => m.medication_id === med.id
          );
          return (
            <div
              key={med.id}
              className="bg-gray-50 dark:bg-gray-800 rounded-xl p-3"
            >
              <div className="flex items-center justify-between mb-2">
                <div>
                  <span className="text-dynamic-base font-medium text-gray-900 dark:text-gray-100">
                    {med.name}
                  </span>
                  {med.dosage && (
                    <span className="text-dynamic-sm text-gray-500 ml-2">{med.dosage}</span>
                  )}
                </div>
              </div>
              <div className="flex gap-2">
                {statusOptions.map((opt) => (
                  <button
                    key={opt.value}
                    onClick={() =>
                      setMedicationTaken({
                        medication_id: med.id,
                        name: med.name,
                        status: opt.value,
                      })
                    }
                    className={cn(
                      'px-3 py-1.5 rounded-lg text-dynamic-xs font-medium min-h-tap border transition-all',
                      taken?.status === opt.value
                        ? opt.color
                        : 'bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-400 border-gray-200 dark:border-gray-600'
                    )}
                    role="radio"
                    aria-checked={taken?.status === opt.value}
                    aria-label={`${med.name}: ${opt.label}`}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/rating-notes-section.tsx << 'ENDOFFILE'
'use client';

import { Smile, StickyNote } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { useLogStore } from '@/stores/log-store';
import { getEmojiForRating } from '@/lib/utils';

export function RatingNotesSection() {
  const { currentLog, setOverallRating, setNotes } = useLogStore();

  return (
    <>
      <CollapsibleCard title="Overall Day Rating" icon={<Smile className="w-5 h-5" />}>
        <div className="space-y-2">
          <div className="flex items-center justify-center">
            <span className="text-4xl mr-3" role="img" aria-hidden="true">
              {getEmojiForRating(currentLog.overall_rating || 5)}
            </span>
            <span className="text-dynamic-3xl font-bold text-gray-900 dark:text-gray-100">
              {currentLog.overall_rating || 5}/10
            </span>
          </div>
          <RangeSlider
            label=""
            value={currentLog.overall_rating || 5}
            onChange={setOverallRating}
            min={1}
            max={10}
            showValue={false}
          />
          <div className="flex justify-between text-dynamic-xs text-gray-400">
            <span>Terrible</span>
            <span>Great</span>
          </div>
        </div>
      </CollapsibleCard>

      <CollapsibleCard title="Notes" icon={<StickyNote className="w-5 h-5" />} defaultOpen={false}>
        <div>
          <textarea
            value={currentLog.notes || ''}
            onChange={(e) => {
              if (e.target.value.length <= 500) {
                setNotes(e.target.value);
              }
            }}
            placeholder="Any additional notes about today..."
            className="input-field min-h-[100px] resize-none"
            aria-label="Daily notes"
            maxLength={500}
          />
          <p className="text-dynamic-xs text-gray-400 mt-1 text-right">
            {(currentLog.notes || '').length}/500
          </p>
        </div>
      </CollapsibleCard>
    </>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/daily-log-screen.tsx << 'ENDOFFILE'
'use client';

import { useEffect } from 'react';
import { Save, Clock } from 'lucide-react';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { formatDate } from '@/lib/utils';
import { SuccessOverlay } from '@/components/ui/success-overlay';
import { HeartRateSection } from './heart-rate-section';
import { BloodPressureSection } from './blood-pressure-section';
import { SymptomsSection } from './symptoms-section';
import { HydrationSection } from './hydration-section';
import { ActivitySection } from './activity-section';
import { SleepSection } from './sleep-section';
import { TriggersSection } from './triggers-section';
import { CycleSection } from './cycle-section';
import { MedicationsSection } from './medications-section';
import { RatingNotesSection } from './rating-notes-section';

export function DailyLogScreen() {
  const { loadToday, isSaving, lastSaved, saveSuccess, save, currentDate } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const showMenstrual = profile?.show_menstrual !== false &&
    profile?.gender !== 'male';

  useEffect(() => {
    loadToday();
  }, [loadToday]);

  return (
    <div className="pb-24">
      <SuccessOverlay show={saveSuccess} message="Log Saved!" />

      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Log Today
        </h1>
        <div className="flex items-center justify-between mt-1">
          <p className="text-dynamic-sm text-gray-500">{formatDate(currentDate)}</p>
          {lastSaved && (
            <div className="flex items-center gap-1 text-dynamic-xs text-gray-400">
              <Clock className="w-3 h-3" />
              Last saved: {new Date(lastSaved).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit',
              })}
            </div>
          )}
        </div>
      </div>

      {/* Form Sections */}
      <div className="px-4 py-3 space-y-3">
        <HeartRateSection />
        <BloodPressureSection />
        <SymptomsSection />
        <HydrationSection />
        <ActivitySection />
        <SleepSection />
        <TriggersSection />
        {showMenstrual && <CycleSection />}
        <MedicationsSection />
        <RatingNotesSection />
      </div>

      {/* Sticky Save Button */}
      <div className="fixed bottom-16 left-0 right-0 px-4 pb-4 pt-2 bg-gradient-to-t from-bg-light dark:from-bg-dark via-bg-light/95 dark:via-bg-dark/95 to-transparent z-40">
        <button
          onClick={save}
          disabled={isSaving}
          className="btn-primary w-full text-dynamic-lg gap-2"
          aria-label="Save daily log"
        >
          <Save className="w-5 h-5" />
          {isSaving ? 'Saving...' : 'Save Log'}
        </button>
      </div>
    </div>
  );
}
ENDOFFILE

# ===== Part 6 =====

cat > ~/Desktop/POTSTracker/src/components/trends/trends-screen.tsx << 'ENDOFFILE'
'use client';

import { useState, useEffect, useMemo } from 'react';
import { getLogsByDateRange } from '@/lib/database';
import { getDateNDaysAgo, getToday } from '@/lib/utils';
import { EmptyState } from '@/components/ui/empty-state';
import { ChartSkeleton } from '@/components/ui/skeleton-loader';
import { HRDeltaChart } from './hr-delta-chart';
import { SymptomHeatmap } from './symptom-heatmap';
import { HydrationChart } from './hydration-chart';
import { ActivitySymptomChart } from './activity-symptom-chart';
import { HeartRateChart } from './heart-rate-chart';
import { BestWorstDays } from './best-worst-days';
import { TrendingUp, BarChart3 } from 'lucide-react';
import type { DailyLog } from '@/types';
import { cn } from '@/lib/utils';

const TIME_RANGES = [
  { label: '7 Days', days: 7 },
  { label: '30 Days', days: 30 },
  { label: '90 Days', days: 90 },
];

export function TrendsScreen() {
  const [selectedRange, setSelectedRange] = useState(30);
  const [logs, setLogs] = useState<DailyLog[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLogs = async () => {
      setLoading(true);
      const startDate = getDateNDaysAgo(selectedRange);
      const endDate = getToday();
      const data = await getLogsByDateRange(startDate, endDate);
      setLogs(data);
      setLoading(false);
    };
    fetchLogs();
  }, [selectedRange]);

  if (loading) {
    return (
      <div className="px-4 py-3 space-y-3">
        <ChartSkeleton />
        <ChartSkeleton />
        <ChartSkeleton />
      </div>
    );
  }

  if (logs.length === 0) {
    return (
      <EmptyState
        icon={<TrendingUp className="w-8 h-8 text-primary" />}
        title="No Data Yet"
        description="Start logging your daily vitals to see your trends and patterns here."
      />
    );
  }

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100 mb-3">
          Trends
        </h1>
        {/* Time range selector */}
        <div className="flex gap-2">
          {TIME_RANGES.map(({ label, days }) => (
            <button
              key={days}
              onClick={() => setSelectedRange(days)}
              className={cn(
                'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all',
                selectedRange === days
                  ? 'bg-primary text-white'
                  : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400'
              )}
              aria-label={`Show ${label} of data`}
              aria-pressed={selectedRange === days}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      {/* Charts */}
      <div className="px-4 py-3 space-y-4">
        <HRDeltaChart logs={logs} />
        <SymptomHeatmap logs={logs} />
        <HydrationChart logs={logs} />
        <ActivitySymptomChart logs={logs} />
        <HeartRateChart logs={logs} />
        <BestWorstDays logs={logs} />
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/hr-delta-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ReferenceLine,
  ResponsiveContainer,
  Area,
  ComposedChart,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function HRDeltaChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.hr_lying != null && l.hr_standing != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      delta: (l.hr_standing || 0) - (l.hr_lying || 0),
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">HR Orthostatic Delta</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log lying and standing heart rates to see your orthostatic delta trend.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">HR Orthostatic Delta</h3>
      <ResponsiveContainer width="100%" height={220}>
        <ComposedChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis
            dataKey="label"
            tick={{ fontSize: 11 }}
            stroke="#9ca3af"
          />
          <YAxis
            tick={{ fontSize: 11 }}
            stroke="#9ca3af"
            domain={[0, 'auto']}
          />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`+${value} BPM`, 'HR Delta']}
          />
          <ReferenceLine
            y={30}
            stroke="#F39C12"
            strokeDasharray="5 5"
            label={{ value: '30 BPM', position: 'right', fontSize: 10 }}
          />
          <ReferenceLine
            y={40}
            stroke="#E74C3C"
            strokeDasharray="5 5"
            label={{ value: '40 BPM', position: 'right', fontSize: 10 }}
          />
          <Line
            type="monotone"
            dataKey="delta"
            stroke="#0D7377"
            strokeWidth={2}
            dot={{ fill: '#0D7377', r: 4 }}
            activeDot={{ r: 6 }}
          />
        </ComposedChart>
      </ResponsiveContainer>
      <div className="flex gap-4 mt-2 text-dynamic-xs">
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-success inline-block" /> &lt;30
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-warning inline-block" /> 30-39
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded-full bg-danger inline-block" /> {'\u2265'}40
        </span>
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/symptom-heatmap.tsx << 'ENDOFFILE'
'use client';

import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';
import { cn } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

function getSeverityColor(severity: number): string {
  if (severity === 0) return 'bg-gray-100 dark:bg-gray-800';
  if (severity === 1) return 'bg-green-200 dark:bg-green-900';
  if (severity === 2) return 'bg-yellow-200 dark:bg-yellow-900';
  if (severity === 3) return 'bg-orange-300 dark:bg-orange-800';
  if (severity === 4) return 'bg-red-400 dark:bg-red-700';
  return 'bg-red-600 dark:bg-red-600';
}

export function SymptomHeatmap({ logs }: Props) {
  // Collect all unique symptoms across logs
  const symptomSet = new Set<string>();
  logs.forEach((log) => {
    log.symptoms?.forEach((s) => symptomSet.add(s.name));
  });
  const symptoms = Array.from(symptomSet);

  if (symptoms.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Symptom Frequency</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log symptoms to see a frequency heatmap.
        </p>
      </div>
    );
  }

  // Take last 14 days max for display
  const displayLogs = logs.slice(-14);

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Symptom Frequency</h3>
      <div className="overflow-x-auto scrollbar-hide">
        <table className="min-w-full" role="grid" aria-label="Symptom frequency heatmap">
          <thead>
            <tr>
              <th className="text-left text-dynamic-xs text-gray-500 pb-2 pr-2 sticky left-0 bg-card-light dark:bg-card-dark">
                Symptom
              </th>
              {displayLogs.map((log) => (
                <th
                  key={log.log_date}
                  className="text-dynamic-xs text-gray-500 pb-2 px-0.5 min-w-[28px] text-center"
                >
                  {formatDateShort(log.log_date).split(' ')[1]}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {symptoms.map((symptom) => (
              <tr key={symptom}>
                <td className="text-dynamic-xs text-gray-700 dark:text-gray-300 pr-2 py-0.5 truncate max-w-[120px] sticky left-0 bg-card-light dark:bg-card-dark">
                  {symptom.length > 15 ? symptom.slice(0, 15) + '...' : symptom}
                </td>
                {displayLogs.map((log) => {
                  const entry = log.symptoms?.find((s) => s.name === symptom);
                  const severity = entry?.severity || 0;
                  return (
                    <td key={log.log_date} className="px-0.5 py-0.5 text-center">
                      <div
                        className={cn(
                          'w-6 h-6 rounded-sm mx-auto',
                          getSeverityColor(severity)
                        )}
                        title={`${symptom}: ${severity > 0 ? `Severity ${severity}` : 'Not logged'} on ${log.log_date}`}
                        aria-label={`${symptom} severity ${severity} on ${log.log_date}`}
                      />
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Legend */}
      <div className="flex items-center gap-1 mt-3 text-dynamic-xs text-gray-500">
        <span>Less</span>
        {[0, 1, 2, 3, 4, 5].map((s) => (
          <div key={s} className={cn('w-4 h-4 rounded-sm', getSeverityColor(s))} />
        ))}
        <span>More</span>
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/hydration-chart.tsx << 'ENDOFFILE'
'use client';

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ReferenceLine,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
  goal?: number;
}

export function HydrationChart({ logs, goal = 64 }: Props) {
  const data = logs
    .filter((l) => l.water_intake != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      water: l.water_intake || 0,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Hydration</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log your water intake to track hydration trends.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Hydration</h3>
      <ResponsiveContainer width="100%" height={200}>
        <BarChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`${value} oz`, 'Water']}
          />
          <ReferenceLine
            y={goal}
            stroke="#2ECC71"
            strokeDasharray="5 5"
            label={{ value: `Goal: ${goal}oz`, position: 'right', fontSize: 10 }}
          />
          <Bar
            dataKey="water"
            fill="#0D7377"
            radius={[4, 4, 0, 0]}
            maxBarSize={30}
          />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/activity-symptom-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

const activityToNumber: Record<string, number> = {
  'Bedbound': 1,
  'Mostly Resting': 2,
  'Light Activity': 3,
  'Moderate': 4,
  'Active': 5,
};

export function ActivitySymptomChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.activity_level || l.overall_rating)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      activity: l.activity_level ? activityToNumber[l.activity_level] || 0 : undefined,
      rating: l.overall_rating,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Activity vs. Day Rating</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log activity and day ratings to see correlations.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Activity vs. Day Rating</h3>
      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis yAxisId="left" tick={{ fontSize: 11 }} stroke="#9ca3af" domain={[1, 5]} />
          <YAxis yAxisId="right" orientation="right" tick={{ fontSize: 11 }} stroke="#9ca3af" domain={[1, 10]} />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
          />
          <Legend />
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="activity"
            stroke="#F4845F"
            strokeWidth={2}
            name="Activity (1-5)"
            dot={{ r: 3 }}
          />
          <Line
            yAxisId="right"
            type="monotone"
            dataKey="rating"
            stroke="#0D7377"
            strokeWidth={2}
            name="Day Rating (1-10)"
            dot={{ r: 3 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/heart-rate-chart.tsx << 'ENDOFFILE'
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import type { DailyLog } from '@/types';
import { formatDateShort } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function HeartRateChart({ logs }: Props) {
  const data = logs
    .filter((l) => l.hr_lying != null || l.hr_sitting != null || l.hr_standing != null)
    .map((l) => ({
      date: l.log_date,
      label: formatDateShort(l.log_date),
      lying: l.hr_lying,
      sitting: l.hr_sitting,
      standing: l.hr_standing,
    }));

  if (data.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Heart Rate Over Time</h3>
        <p className="text-dynamic-sm text-gray-500">
          Log heart rates to see positional trends.
        </p>
      </div>
    );
  }

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Heart Rate Over Time</h3>
      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={data} margin={{ top: 5, right: 5, bottom: 5, left: -10 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="label" tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <YAxis tick={{ fontSize: 11 }} stroke="#9ca3af" />
          <Tooltip
            contentStyle={{
              borderRadius: '12px',
              border: 'none',
              boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
            }}
            formatter={(value: number) => [`${value} BPM`]}
          />
          <Legend />
          <Line
            type="monotone"
            dataKey="lying"
            stroke="#2ECC71"
            strokeWidth={2}
            name="Lying"
            dot={{ r: 3 }}
            connectNulls
          />
          <Line
            type="monotone"
            dataKey="sitting"
            stroke="#F39C12"
            strokeWidth={2}
            name="Sitting"
            dot={{ r: 3 }}
            connectNulls
          />
          <Line
            type="monotone"
            dataKey="standing"
            stroke="#E74C3C"
            strokeWidth={2}
            name="Standing"
            dot={{ r: 3 }}
            connectNulls
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/trends/best-worst-days.tsx << 'ENDOFFILE'
'use client';

import type { DailyLog } from '@/types';
import { formatDate, getEmojiForRating } from '@/lib/utils';
import { cn } from '@/lib/utils';

interface Props {
  logs: DailyLog[];
}

export function BestWorstDays({ logs }: Props) {
  const rated = logs.filter((l) => l.overall_rating != null);

  if (rated.length === 0) {
    return (
      <div className="card p-4">
        <h3 className="section-title mb-2">Best & Worst Days</h3>
        <p className="text-dynamic-sm text-gray-500">
          Rate your days to see your best and worst.
        </p>
      </div>
    );
  }

  const sorted = [...rated].sort((a, b) => (b.overall_rating || 0) - (a.overall_rating || 0));
  const best = sorted.slice(0, 5);
  const worst = [...sorted].reverse().slice(0, 5);

  const DayRow = ({ log, rank }: { log: DailyLog; rank: number }) => {
    const rating = log.overall_rating || 0;
    const width = `${(rating / 10) * 100}%`;
    const topSymptom = log.symptoms?.[0]?.name;

    return (
      <div className="flex items-center gap-3 py-1.5">
        <span className="text-dynamic-xs text-gray-400 w-4">{rank}</span>
        <div className="flex-1">
          <div className="flex items-center justify-between mb-1">
            <span className="text-dynamic-sm text-gray-700 dark:text-gray-300">
              {formatDate(log.log_date)}
            </span>
            <span className="text-dynamic-sm font-semibold">
              {getEmojiForRating(rating)} {rating}/10
            </span>
          </div>
          <div className="w-full h-2 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
            <div
              className={cn(
                'h-full rounded-full transition-all',
                rating >= 7 ? 'bg-success' : rating >= 4 ? 'bg-warning' : 'bg-danger'
              )}
              style={{ width }}
            />
          </div>
          {topSymptom && (
            <span className="text-dynamic-xs text-gray-400 mt-0.5 block">
              Top symptom: {topSymptom}
            </span>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="card p-4">
      <h3 className="section-title mb-4">Best & Worst Days</h3>

      <div className="space-y-4">
        <div>
          <h4 className="text-dynamic-sm font-medium text-success mb-2">Best Days</h4>
          {best.map((log, i) => (
            <DayRow key={log.log_date} log={log} rank={i + 1} />
          ))}
        </div>

        <div className="border-t border-gray-100 dark:border-gray-700 pt-3">
          <h4 className="text-dynamic-sm font-medium text-danger mb-2">Toughest Days</h4>
          {worst.map((log, i) => (
            <DayRow key={log.log_date} log={log} rank={i + 1} />
          ))}
        </div>
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/insights/insights-screen.tsx << 'ENDOFFILE'
'use client';

import { useState, useEffect } from 'react';
import { Lightbulb, FileText, ChevronRight, TrendingDown, TrendingUp, AlertTriangle, Info, CheckCircle } from 'lucide-react';
import { getLogsByDateRange } from '@/lib/database';
import { generateInsights, generateDoctorSummary } from '@/lib/insights-engine';
import { getDateNDaysAgo, getToday } from '@/lib/utils';
import { EmptyState } from '@/components/ui/empty-state';
import { CardSkeleton } from '@/components/ui/skeleton-loader';
import type { DailyLog, Insight } from '@/types';
import { cn } from '@/lib/utils';

const typeConfig = {
  positive: { icon: CheckCircle, color: 'text-success', bg: 'bg-success/10', border: 'border-success/30' },
  warning: { icon: AlertTriangle, color: 'text-warning', bg: 'bg-warning/10', border: 'border-warning/30' },
  negative: { icon: TrendingDown, color: 'text-danger', bg: 'bg-danger/10', border: 'border-danger/30' },
  info: { icon: Info, color: 'text-primary', bg: 'bg-primary/10', border: 'border-primary/30' },
};

export function InsightsScreen() {
  const [insights, setInsights] = useState<Insight[]>([]);
  const [logs, setLogs] = useState<DailyLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [expandedTip, setExpandedTip] = useState<string | null>(null);
  const [showSummary, setShowSummary] = useState(false);
  const [summaryDays, setSummaryDays] = useState(30);

  useEffect(() => {
    const fetch = async () => {
      setLoading(true);
      const startDate = getDateNDaysAgo(90);
      const endDate = getToday();
      const data = await getLogsByDateRange(startDate, endDate);
      setLogs(data);
      setInsights(generateInsights(data));
      setLoading(false);
    };
    fetch();
  }, []);

  if (loading) {
    return (
      <div className="px-4 py-3 space-y-3">
        <CardSkeleton />
        <CardSkeleton />
        <CardSkeleton />
      </div>
    );
  }

  if (logs.length < 3) {
    return (
      <EmptyState
        icon={<Lightbulb className="w-8 h-8 text-primary" />}
        title="Not Enough Data"
        description="Log at least 3 days of data to start seeing insights and patterns."
      />
    );
  }

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Insights
        </h1>
        <p className="text-dynamic-sm text-gray-500 mt-1">
          Patterns detected from your data
        </p>
      </div>

      <div className="px-4 py-3 space-y-3">
        {/* Insight Cards */}
        {insights.length === 0 ? (
          <div className="card p-4 text-center">
            <p className="text-dynamic-sm text-gray-500">
              Keep logging to discover patterns. More data = better insights.
            </p>
          </div>
        ) : (
          insights.map((insight) => {
            const config = typeConfig[insight.type];
            const Icon = config.icon;
            const isExpanded = expandedTip === insight.id;

            return (
              <div
                key={insight.id}
                className={cn('card border', config.border)}
              >
                <div className="p-4">
                  <div className="flex items-start gap-3">
                    <div className={cn('w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0', config.bg)}>
                      <Icon className={cn('w-5 h-5', config.color)} />
                    </div>
                    <div className="flex-1">
                      <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                        {insight.title}
                      </h3>
                      <p className="text-dynamic-sm text-gray-600 dark:text-gray-400 mt-1">
                        {insight.description}
                      </p>
                    </div>
                  </div>

                  {insight.tip && (
                    <>
                      <button
                        onClick={() =>
                          setExpandedTip(isExpanded ? null : insight.id)
                        }
                        className="mt-3 flex items-center gap-1 text-primary text-dynamic-sm font-medium min-h-tap"
                        aria-label={`${isExpanded ? 'Hide' : 'Show'} tips for ${insight.title}`}
                        aria-expanded={isExpanded}
                      >
                        What can I do?
                        <ChevronRight
                          className={cn(
                            'w-4 h-4 transition-transform',
                            isExpanded && 'rotate-90'
                          )}
                        />
                      </button>
                      {isExpanded && (
                        <div className="mt-2 p-3 bg-gray-50 dark:bg-gray-800 rounded-xl animate-fade-in">
                          <p className="text-dynamic-sm text-gray-700 dark:text-gray-300 leading-relaxed">
                            {insight.tip}
                          </p>
                        </div>
                      )}
                    </>
                  )}
                </div>
              </div>
            );
          })
        )}

        {/* Doctor Visit Prep */}
        <div className="card p-4 mt-6">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
              <FileText className="w-5 h-5 text-primary" />
            </div>
            <div>
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Doctor Visit Prep
              </h3>
              <p className="text-dynamic-sm text-gray-500">
                Generate a summary report for your doctor
              </p>
            </div>
          </div>

          <div className="flex gap-2 mb-3">
            {[30, 90].map((days) => (
              <button
                key={days}
                onClick={() => setSummaryDays(days)}
                className={cn(
                  'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all',
                  summaryDays === days
                    ? 'bg-primary text-white'
                    : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400'
                )}
                aria-pressed={summaryDays === days}
              >
                Last {days} Days
              </button>
            ))}
          </div>

          <button
            onClick={() => setShowSummary(!showSummary)}
            className="btn-primary w-full"
            aria-label="Generate doctor visit summary"
          >
            {showSummary ? 'Hide Summary' : 'Generate Summary'}
          </button>

          {showSummary && (
            <div className="mt-4 animate-fade-in">
              <pre className="bg-gray-50 dark:bg-gray-800 rounded-xl p-4 text-dynamic-xs text-gray-700 dark:text-gray-300 overflow-x-auto whitespace-pre-wrap font-mono leading-relaxed">
                {generateDoctorSummary(
                  logs.filter(
                    (l) => l.log_date >= getDateNDaysAgo(summaryDays)
                  ),
                  summaryDays
                )}
              </pre>
              <div className="flex gap-2 mt-3">
                <button
                  className="btn-secondary flex-1 text-dynamic-sm"
                  onClick={() => {
                    const text = generateDoctorSummary(
                      logs.filter((l) => l.log_date >= getDateNDaysAgo(summaryDays)),
                      summaryDays
                    );
                    if (navigator.clipboard) {
                      navigator.clipboard.writeText(text);
                    }
                  }}
                  aria-label="Copy summary to clipboard"
                >
                  Copy Text
                </button>
                <button
                  className="btn-primary flex-1 text-dynamic-sm"
                  aria-label="Share summary"
                >
                  Share / Export PDF
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/profile/profile-screen.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import {
  User, Pill, AlertCircle, Bell, Ruler, Database,
  Shield, Info, ChevronRight, Trash2, Download,
  FileText, Cloud, Star, ExternalLink, Plus, X,
} from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { exportAllDataAsCSV, clearAllData } from '@/lib/database';
import { DIAGNOSIS_TYPES, type DiagnosisType, type Medication } from '@/types';
import { cn } from '@/lib/utils';

export function ProfileScreen() {
  const { profile, updateProfile } = useAppStore();
  const [showClearConfirm, setShowClearConfirm] = useState(false);
  const [editingMed, setEditingMed] = useState(false);
  const [newMedName, setNewMedName] = useState('');
  const [newMedDosage, setNewMedDosage] = useState('');
  const [newCustomSymptom, setNewCustomSymptom] = useState('');
  const [showAddSymptom, setShowAddSymptom] = useState(false);

  const handleExportCSV = async () => {
    const csv = await exportAllDataAsCSV();
    if (!csv) return;
    // Create blob and download
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `POTSTracker_Export_${new Date().toISOString().split('T')[0]}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const handleClearData = async () => {
    await clearAllData();
    setShowClearConfirm(false);
    window.location.reload();
  };

  const addMedication = () => {
    if (!newMedName.trim()) return;
    const med: Medication = {
      id: crypto.randomUUID?.() || Math.random().toString(36).slice(2),
      name: newMedName.trim(),
      dosage: newMedDosage.trim(),
      time_of_day: 'morning',
      reminder_enabled: false,
    };
    updateProfile({
      medications: [...(profile?.medications || []), med],
    });
    setNewMedName('');
    setNewMedDosage('');
    setEditingMed(false);
  };

  const removeMedication = (id: string) => {
    updateProfile({
      medications: (profile?.medications || []).filter((m) => m.id !== id),
    });
  };

  const addCustomSymptom = () => {
    if (!newCustomSymptom.trim()) return;
    updateProfile({
      custom_symptoms: [...(profile?.custom_symptoms || []), newCustomSymptom.trim()],
    });
    setNewCustomSymptom('');
    setShowAddSymptom(false);
  };

  const removeCustomSymptom = (symptom: string) => {
    updateProfile({
      custom_symptoms: (profile?.custom_symptoms || []).filter((s) => s !== symptom),
    });
  };

  return (
    <div className="pb-24">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-bg-light dark:bg-bg-dark px-4 py-3 border-b border-gray-100 dark:border-gray-800">
        <h1 className="text-dynamic-xl font-bold text-gray-900 dark:text-gray-100">
          Profile & Settings
        </h1>
      </div>

      <div className="px-4 py-3 space-y-4">
        {/* Personal Info */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <User className="w-5 h-5 text-primary" />
            <h3 className="section-title">Personal Info</h3>
          </div>
          <div className="space-y-3">
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Name</label>
              <input
                type="text"
                value={profile?.name || ''}
                onChange={(e) => updateProfile({ name: e.target.value })}
                className="input-field"
                placeholder="Your name"
                aria-label="Name"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Date of Birth</label>
              <input
                type="date"
                value={profile?.dob || ''}
                onChange={(e) => updateProfile({ dob: e.target.value })}
                className="input-field"
                aria-label="Date of birth"
              />
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Diagnosis</label>
              <select
                value={profile?.diagnosis_type || 'Undiagnosed'}
                onChange={(e) =>
                  updateProfile({ diagnosis_type: e.target.value as DiagnosisType })
                }
                className="input-field"
                aria-label="Diagnosis type"
              >
                {DIAGNOSIS_TYPES.map((d) => (
                  <option key={d} value={d}>{d}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-dynamic-sm text-gray-500 block mb-1">Gender</label>
              <select
                value={profile?.gender || 'prefer-not-to-say'}
                onChange={(e) =>
                  updateProfile({ gender: e.target.value as Profile['gender'] })
                }
                className="input-field"
                aria-label="Gender"
              >
                <option value="female">Female</option>
                <option value="male">Male</option>
                <option value="non-binary">Non-Binary</option>
                <option value="prefer-not-to-say">Prefer not to say</option>
              </select>
            </div>
          </div>
        </div>

        {/* Medications */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Pill className="w-5 h-5 text-primary" />
              <h3 className="section-title">Medications</h3>
            </div>
            <button
              onClick={() => setEditingMed(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add medication"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.medications || []).length === 0 && !editingMed && (
            <p className="text-dynamic-sm text-gray-500">No medications added.</p>
          )}

          {(profile?.medications || []).map((med) => (
            <div
              key={med.id}
              className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700 last:border-0"
            >
              <div>
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  {med.name}
                </span>
                {med.dosage && (
                  <span className="text-dynamic-sm text-gray-500 ml-2">{med.dosage}</span>
                )}
              </div>
              <button
                onClick={() => removeMedication(med.id)}
                className="min-h-tap min-w-tap flex items-center justify-center text-danger"
                aria-label={`Remove ${med.name}`}
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          ))}

          {editingMed && (
            <div className="space-y-2 mt-3 pt-3 border-t border-gray-100 dark:border-gray-700">
              <input
                type="text"
                value={newMedName}
                onChange={(e) => setNewMedName(e.target.value)}
                placeholder="Medication name"
                className="input-field"
                aria-label="New medication name"
                autoFocus
              />
              <input
                type="text"
                value={newMedDosage}
                onChange={(e) => setNewMedDosage(e.target.value)}
                placeholder="Dosage (e.g., 10mg)"
                className="input-field"
                aria-label="Medication dosage"
              />
              <div className="flex gap-2">
                <button onClick={addMedication} className="btn-primary flex-1 text-dynamic-sm">
                  Save
                </button>
                <button
                  onClick={() => setEditingMed(false)}
                  className="btn-secondary flex-1 text-dynamic-sm"
                >
                  Cancel
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Custom Symptoms */}
        <div className="card p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-primary" />
              <h3 className="section-title">Custom Symptoms</h3>
            </div>
            <button
              onClick={() => setShowAddSymptom(true)}
              className="text-primary text-dynamic-sm font-medium min-h-tap flex items-center gap-1"
              aria-label="Add custom symptom"
            >
              <Plus className="w-4 h-4" /> Add
            </button>
          </div>

          {(profile?.custom_symptoms || []).length === 0 && !showAddSymptom && (
            <p className="text-dynamic-sm text-gray-500">No custom symptoms added.</p>
          )}

          <div className="flex flex-wrap gap-2">
            {(profile?.custom_symptoms || []).map((symptom) => (
              <span
                key={symptom}
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-full bg-gray-100 dark:bg-gray-800 text-dynamic-sm"
              >
                {symptom}
                <button
                  onClick={() => removeCustomSymptom(symptom)}
                  className="text-gray-400 hover:text-danger min-w-tap min-h-[28px] flex items-center"
                  aria-label={`Remove ${symptom}`}
                >
                  <X className="w-3 h-3" />
                </button>
              </span>
            ))}
          </div>

          {showAddSymptom && (
            <div className="flex gap-2 mt-3">
              <input
                type="text"
                value={newCustomSymptom}
                onChange={(e) => setNewCustomSymptom(e.target.value)}
                placeholder="Symptom name"
                className="input-field flex-1"
                onKeyDown={(e) => e.key === 'Enter' && addCustomSymptom()}
                aria-label="New custom symptom"
                autoFocus
              />
              <button onClick={addCustomSymptom} className="btn-primary px-4 text-dynamic-sm">
                Add
              </button>
            </div>
          )}
        </div>

        {/* Notifications */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Bell className="w-5 h-5 text-primary" />
            <h3 className="section-title">Notifications</h3>
          </div>
          <div className="space-y-1">
            <ToggleSwitch
              checked={!!profile?.notification_log_time}
              onChange={(v) =>
                updateProfile({ notification_log_time: v ? '20:00' : undefined })
              }
              label="Daily Log Reminder"
              description="Reminds you to log your vitals"
            />
            {profile?.notification_log_time && (
              <div className="pl-4 py-1">
                <label className="text-dynamic-xs text-gray-500 block mb-1">Reminder Time</label>
                <input
                  type="time"
                  value={profile.notification_log_time}
                  onChange={(e) => updateProfile({ notification_log_time: e.target.value })}
                  className="input-field w-40"
                  aria-label="Daily log reminder time"
                />
              </div>
            )}
            <ToggleSwitch
              checked={!!profile?.notification_hydration_interval}
              onChange={(v) =>
                updateProfile({ notification_hydration_interval: v ? 2 : undefined })
              }
              label="Hydration Reminders"
              description="Every 2 hours during the day"
            />
          </div>
        </div>

        {/* Units */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Ruler className="w-5 h-5 text-primary" />
            <h3 className="section-title">Units</h3>
          </div>
          <div className="flex gap-2">
            {(['imperial', 'metric'] as const).map((unit) => (
              <button
                key={unit}
                onClick={() => updateProfile({ units: unit })}
                className={cn(
                  'flex-1 py-3 rounded-xl text-dynamic-base font-medium min-h-tap transition-all border',
                  profile?.units === unit
                    ? 'bg-primary text-white border-primary'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                aria-pressed={profile?.units === unit}
              >
                {unit === 'imperial' ? 'Imperial (oz, lbs)' : 'Metric (mL, kg)'}
              </button>
            ))}
          </div>
        </div>

        {/* Data Management */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Database className="w-5 h-5 text-primary" />
            <h3 className="section-title">Data Management</h3>
          </div>
          <div className="space-y-2">
            <button
              onClick={handleExportCSV}
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export data as CSV"
            >
              <div className="flex items-center gap-3">
                <Download className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export All Data (CSV)
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <button
              className="flex items-center justify-between w-full py-3 min-h-tap"
              aria-label="Export PDF summary report"
            >
              <div className="flex items-center gap-3">
                <FileText className="w-5 h-5 text-gray-500" />
                <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                  Export PDF Report
                </span>
              </div>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>

            <div className="flex items-center justify-between w-full py-3 min-h-tap opacity-60">
              <div className="flex items-center gap-3">
                <Cloud className="w-5 h-5 text-gray-500" />
                <div>
                  <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                    iCloud Backup
                  </span>
                  <span className="badge-warning ml-2">Coming Soon</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setShowClearConfirm(true)}
              className="flex items-center gap-3 w-full py-3 min-h-tap text-danger"
              aria-label="Clear all data"
            >
              <Trash2 className="w-5 h-5" />
              <span className="text-dynamic-base font-medium">Clear All Data</span>
            </button>
          </div>
        </div>

        {/* Clear data confirmation */}
        {showClearConfirm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-6">
            <div className="bg-white dark:bg-card-dark rounded-2xl p-6 max-w-sm w-full animate-fade-in">
              <h3 className="text-dynamic-lg font-bold text-danger mb-2">
                Delete All Data?
              </h3>
              <p className="text-dynamic-sm text-gray-600 dark:text-gray-400 mb-4">
                This will permanently delete all your logs, profile data, and settings.
                This action cannot be undone.
              </p>
              <div className="flex gap-3">
                <button
                  onClick={() => setShowClearConfirm(false)}
                  className="btn-secondary flex-1"
                >
                  Cancel
                </button>
                <button onClick={handleClearData} className="btn-danger flex-1">
                  Delete Everything
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Security */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Shield className="w-5 h-5 text-primary" />
            <h3 className="section-title">Security</h3>
          </div>
          <ToggleSwitch
            checked={!!profile?.biometric_enabled}
            onChange={(v) => updateProfile({ biometric_enabled: v })}
            label="Face ID / Touch ID"
            description="Protect your health data with biometrics"
          />
        </div>

        {/* About */}
        <div className="card p-4">
          <div className="flex items-center gap-2 mb-4">
            <Info className="w-5 h-5 text-primary" />
            <h3 className="section-title">About</h3>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between py-2">
              <span className="text-dynamic-base text-gray-600 dark:text-gray-400">Version</span>
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">1.0.0</span>
            </div>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Privacy Policy
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button className="flex items-center justify-between w-full py-2 min-h-tap">
              <span className="text-dynamic-base text-gray-900 dark:text-gray-100">
                Terms of Use
              </span>
              <ExternalLink className="w-4 h-4 text-gray-400" />
            </button>
            <button
              className="flex items-center gap-2 w-full py-2 min-h-tap text-primary font-medium"
              aria-label="Rate the app"
            >
              <Star className="w-5 h-5" />
              <span className="text-dynamic-base">Rate POTSTracker</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/PrivacyInfo.xcprivacy << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>CA92.1</string>
      </array>
    </dict>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array>
        <string>C617.1</string>
      </array>
    </dict>
  </array>
</dict>
</plist>

ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/Info.plist.additions << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Add these keys to your Info.plist in Xcode.
  These are the required privacy descriptions for App Store submission.
-->
<dict>
  <!-- Face ID / Biometric Auth -->
  <key>NSFaceIDUsageDescription</key>
  <string>Used to protect your private health data</string>

  <!-- HealthKit Read -->
  <key>NSHealthShareUsageDescription</key>
  <string>Used to read heart rate data from Apple Health</string>

  <!-- HealthKit Write -->
  <key>NSHealthUpdateUsageDescription</key>
  <string>Used to write symptom data to Apple Health</string>

  <!-- HealthKit Entitlement -->
  <key>UIBackgroundModes</key>
  <array>
    <string>processing</string>
  </array>

  <!-- App Category -->
  <key>LSApplicationCategoryType</key>
  <string>public.app-category.medical</string>

  <!-- Minimum iOS Version -->
  <key>MinimumOSVersion</key>
  <string>16.0</string>
</dict>

ENDOFFILE

cat > ~/Desktop/POTSTracker/ios/App/App.entitlements << 'ENDOFFILE'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.developer.healthkit</key>
  <true/>
  <key>com.apple.developer.healthkit.access</key>
  <array>
    <string>health-records</string>
  </array>
</dict>
</plist>

ENDOFFILE

cat > ~/Desktop/POTSTracker/IOS_SETUP.md << 'ENDOFFILE'
# POTSTracker — iOS Build & Submission Guide

## Prerequisites
- macOS with Xcode 15+ installed
- Apple Developer Account ($99/year)
- Node.js 18+
- CocoaPods (`sudo gem install cocoapods`)

## Step 1: Install Dependencies
```bash
cd POTSTracker
npm install
```

## Step 2: Build the Web App
```bash
npm run build
```
This generates the static export in the `/out` directory.

## Step 3: Initialize Capacitor iOS
```bash
npx cap add ios
npx cap sync ios
```

## Step 4: Open in Xcode
```bash
npx cap open ios
```

## Step 5: Configure in Xcode

### Info.plist
Add these keys (from `ios/App/Info.plist.additions`):
- `NSFaceIDUsageDescription`: "Used to protect your private health data"
- `NSHealthShareUsageDescription`: "Used to read heart rate data from Apple Health"
- `NSHealthUpdateUsageDescription`: "Used to write symptom data to Apple Health"

### Signing & Capabilities
1. Select your Development Team
2. Add **HealthKit** capability
3. Add **Background Modes** → Background Processing

### Privacy Manifest
Copy `ios/App/PrivacyInfo.xcprivacy` into the Xcode project navigator under `App/App/`.

### Entitlements
Copy `ios/App/App.entitlements` and add it to the project.

### Deployment Target
Set minimum iOS deployment target to **16.0** in:
- Project settings → General → Minimum Deployments
- Both App and Pods targets

### App Icons
Generate app icons (1024x1024 source) and add to Assets.xcassets/AppIcon.

### Launch Screen
Configure `LaunchScreen.storyboard`:
- Set background color to #0D7377 (primary teal)
- Add centered app name label "POTSTracker" in white

## Step 6: Test on Simulator / Device
```bash
# Build and run on simulator
npx cap run ios

# Or use Xcode: Product → Run
```

## Step 7: Archive for TestFlight
1. In Xcode: Product → Archive
2. Distribute App → App Store Connect
3. Upload to TestFlight
4. Add testers in App Store Connect

## Step 8: App Store Submission Metadata

### App Information
- **App Name**: POTSTracker – Dysautonomia Diary
- **Category**: Medical
- **Subcategory**: Health & Fitness
- **Age Rating**: 4+
- **Price**: Free

### App Description
```
Track. Understand. Thrive.

POTSTracker is your personal dysautonomia diary designed specifically for people
living with POTS (Postural Orthostatic Tachycardia Syndrome), orthostatic
hypotension, vasovagal syncope, and other forms of dysautonomia.

DAILY LOGGING
• Record lying, sitting, and standing heart rates with automatic orthostatic
  delta calculation
• Track blood pressure changes between positions
• Log 14+ common dysautonomia symptoms with severity ratings
• Monitor hydration, salt intake, sleep, and activity levels
• Track medications and menstrual cycle phases

SMART INSIGHTS
• Automatic pattern detection identifies your personal triggers
• Correlation analysis between sleep, activity, and symptom severity
• Hydration goal tracking and reminders

DOCTOR VISIT PREP
• One-tap generation of comprehensive summary reports
• Export as PDF or CSV for your medical team
• Includes averages, trends, and top symptoms

DESIGNED FOR DYSAUTONOMIA
• Built with input from the POTS community
• Orthostatic HR criteria alerts (≥30 BPM increase)
• Orthostatic hypotension detection
• Recumbent exercise tracking options

PRIVACY FIRST
• All data stored locally on your device
• No accounts or cloud services required
• Face ID / Touch ID protection
• No ads, no tracking, no data collection

Apple Health integration available for automatic heart rate and step count import.
```

### Keywords
POTS, dysautonomia, tachycardia, orthostatic, symptom tracker, health diary,
heart rate, chronic illness, vasovagal, blood pressure

### Support URL
[Your support URL]

### Privacy Policy URL
[Your privacy policy URL — required for Medical category]

ENDOFFILE

echo ""
echo "======================================"
echo "Project created successfully!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  cd ~/Desktop/POTSTracker"
echo "  npm install"
echo "  npm run build"
echo "  npx cap add ios"
echo "  npx cap sync ios"
echo "  npx cap open ios"
echo ""
echo "See IOS_SETUP.md for full Xcode configuration guide."
echo ""
