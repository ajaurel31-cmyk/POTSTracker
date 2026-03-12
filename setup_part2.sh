#!/bin/bash
set -e

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
