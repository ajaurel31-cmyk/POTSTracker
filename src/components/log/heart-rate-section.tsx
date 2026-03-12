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
