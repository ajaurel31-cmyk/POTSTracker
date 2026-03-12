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
