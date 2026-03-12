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
