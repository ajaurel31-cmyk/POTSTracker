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
