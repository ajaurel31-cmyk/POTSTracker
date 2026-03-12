'use client';

import { Pill } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { cn } from '@/lib/utils';
import type { MedicationTaken } from '@/types';

const statusOptions: { value: MedicationTaken['status']; label: string; color: string }[] = [
  { value: 'taken', label: 'Taken', color: 'bg-success/20 text-green-700 dark:text-green-300 border-success' },
  { value: 'skipped', label: 'Skipped', color: 'bg-warning/20 text-yellow-700 dark:text-yellow-300 border-warning' },
  { value: 'dose-changed', label: 'Dose Changed', color: 'bg-primary/20 text-primary border-primary' },
];

export function MedicationsSection() {
  const { currentLog, setMedicationTaken } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const medications = profile?.medications || [];

  if (medications.length === 0) {
    return (
      <CollapsibleCard title="Medications" icon={<Pill className="w-5 h-5" />} defaultOpen={false}>
        <p className="text-dynamic-sm text-gray-500 dark:text-gray-400">
          No medications added yet. Add medications in your Profile settings.
        </p>
      </CollapsibleCard>
    );
  }

  return (
    <CollapsibleCard title="Medications" icon={<Pill className="w-5 h-5" />}>
      <div className="space-y-3">
        {medications.map((med) => {
          const taken = currentLog.medications_taken.find(
            (m) => m.medication_id === med.id
          );
          return (
            <div
              key={med.id}
              className="bg-gray-50 dark:bg-gray-800 rounded-xl p-3"
            >
              <div className="flex items-center justify-between mb-2">
                <div>
                  <span className="text-dynamic-base font-medium text-gray-900 dark:text-gray-100">
                    {med.name}
                  </span>
                  {med.dosage && (
                    <span className="text-dynamic-sm text-gray-500 ml-2">{med.dosage}</span>
                  )}
                </div>
              </div>
              <div className="flex gap-2">
                {statusOptions.map((opt) => (
                  <button
                    key={opt.value}
                    onClick={() =>
                      setMedicationTaken({
                        medication_id: med.id,
                        name: med.name,
                        status: opt.value,
                      })
                    }
                    className={cn(
                      'px-3 py-1.5 rounded-lg text-dynamic-xs font-medium min-h-tap border transition-all',
                      taken?.status === opt.value
                        ? opt.color
                        : 'bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-400 border-gray-200 dark:border-gray-600'
                    )}
                    role="radio"
                    aria-checked={taken?.status === opt.value}
                    aria-label={`${med.name}: ${opt.label}`}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </CollapsibleCard>
  );
}
