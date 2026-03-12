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
