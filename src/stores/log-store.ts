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
