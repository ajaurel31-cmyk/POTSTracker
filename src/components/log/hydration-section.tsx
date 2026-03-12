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
