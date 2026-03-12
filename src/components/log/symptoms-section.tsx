'use client';

import { useState } from 'react';
import { AlertCircle, Plus } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { SeveritySlider } from '@/components/ui/severity-slider';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { DEFAULT_SYMPTOMS } from '@/types';
import { cn } from '@/lib/utils';

export function SymptomsSection() {
  const { currentLog, toggleSymptom, setSymptomSeverity } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const [customSymptom, setCustomSymptom] = useState('');
  const [showCustomInput, setShowCustomInput] = useState(false);

  const allSymptoms = [
    ...DEFAULT_SYMPTOMS,
    ...(profile?.custom_symptoms || []),
  ];

  const selectedNames = currentLog.symptoms.map((s) => s.name);

  const addCustomSymptom = () => {
    if (customSymptom.trim()) {
      toggleSymptom(customSymptom.trim());
      setCustomSymptom('');
      setShowCustomInput(false);
    }
  };

  return (
    <CollapsibleCard title="Symptoms" icon={<AlertCircle className="w-5 h-5" />}>
      <div className="space-y-4">
        {/* Symptom chips */}
        <div className="flex flex-wrap gap-2">
          {allSymptoms.map((symptom) => {
            const isSelected = selectedNames.includes(symptom);
            return (
              <button
                key={symptom}
                onClick={() => toggleSymptom(symptom)}
                className={cn(
                  'px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap',
                  'transition-all tap-highlight-none border',
                  isSelected
                    ? 'bg-accent text-white border-accent'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="checkbox"
                aria-checked={isSelected}
                aria-label={`${symptom}${isSelected ? ', selected' : ''}`}
              >
                {symptom}
              </button>
            );
          })}
          <button
            onClick={() => setShowCustomInput(true)}
            className="px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap
              border border-dashed border-gray-300 dark:border-gray-600
              text-gray-500 dark:text-gray-400 flex items-center gap-1"
            aria-label="Add custom symptom"
          >
            <Plus className="w-4 h-4" />
            Custom
          </button>
        </div>

        {/* Custom symptom input */}
        {showCustomInput && (
          <div className="flex gap-2">
            <input
              type="text"
              value={customSymptom}
              onChange={(e) => setCustomSymptom(e.target.value)}
              placeholder="Enter custom symptom"
              className="input-field flex-1"
              onKeyDown={(e) => e.key === 'Enter' && addCustomSymptom()}
              aria-label="Custom symptom name"
              autoFocus
            />
            <button onClick={addCustomSymptom} className="btn-primary px-4" aria-label="Add symptom">
              Add
            </button>
          </div>
        )}

        {/* Severity sliders for selected symptoms */}
        {currentLog.symptoms.length > 0 && (
          <div className="space-y-3 pt-2">
            <p className="text-dynamic-sm font-medium text-gray-500">Severity (1-5)</p>
            {currentLog.symptoms.map((symptom) => (
              <SeveritySlider
                key={symptom.name}
                label={symptom.name}
                value={symptom.severity}
                onChange={(v) => setSymptomSeverity(symptom.name, v)}
              />
            ))}
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
