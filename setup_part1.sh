#!/bin/bash
set -e

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
