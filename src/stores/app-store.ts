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
