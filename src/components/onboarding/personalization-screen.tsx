'use client';

import { ChevronLeft } from 'lucide-react';
import { ChipSelect } from '@/components/ui/chip-select';
import { DIAGNOSIS_TYPES, DEFAULT_TRIGGERS, type DiagnosisType } from '@/types';

interface PersonalizationScreenProps {
  diagnosis: DiagnosisType;
  setDiagnosis: (d: DiagnosisType) => void;
  triggers: string[];
  setTriggers: (t: string[]) => void;
  medications: string;
  setMedications: (m: string) => void;
  onNext: () => void;
  onBack: () => void;
}

export function PersonalizationScreen({
  diagnosis,
  setDiagnosis,
  triggers,
  setTriggers,
  medications,
  setMedications,
  onNext,
  onBack,
}: PersonalizationScreenProps) {
  return (
    <div className="flex flex-col min-h-[calc(100vh-60px)] px-6 py-4">
      <button
        onClick={onBack}
        className="flex items-center gap-1 text-primary min-h-tap self-start mb-4"
        aria-label="Go back"
      >
        <ChevronLeft className="w-5 h-5" />
        <span className="text-dynamic-base">Back</span>
      </button>

      <h2 className="text-dynamic-2xl font-bold text-gray-900 dark:text-gray-100 mb-1">
        Personalize Your Experience
      </h2>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mb-6">
        Help us tailor the app to your needs. You can change these later.
      </p>

      <div className="flex-1 space-y-6 overflow-y-auto scrollbar-hide pb-4">
        {/* Diagnosis Type */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-3">
            Diagnosis Type
          </label>
          <div className="space-y-2">
            {DIAGNOSIS_TYPES.map((type) => (
              <button
                key={type}
                onClick={() => setDiagnosis(type)}
                className={`w-full text-left px-4 py-3 rounded-xl min-h-tap transition-all border ${
                  diagnosis === type
                    ? 'bg-primary/10 border-primary text-primary font-medium'
                    : 'bg-gray-50 dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300'
                }`}
                role="radio"
                aria-checked={diagnosis === type}
              >
                {type}
              </button>
            ))}
          </div>
        </div>

        {/* Triggers */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-3">
            Primary Triggers to Track
          </label>
          <p className="text-dynamic-sm text-gray-500 mb-3">Select all that apply</p>
          <ChipSelect
            options={[...DEFAULT_TRIGGERS]}
            selected={triggers}
            onChange={setTriggers}
          />
        </div>

        {/* Medications */}
        <div>
          <label className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100 block mb-2">
            Current Medications
          </label>
          <p className="text-dynamic-sm text-gray-500 mb-3">
            Optional — separate multiple with commas
          </p>
          <textarea
            value={medications}
            onChange={(e) => setMedications(e.target.value)}
            placeholder="e.g., Fludrocortisone, Midodrine, Metoprolol"
            className="input-field min-h-[80px] resize-none"
            aria-label="Current medications"
          />
        </div>
      </div>

      <button
        onClick={onNext}
        className="btn-primary w-full text-dynamic-lg mt-4"
        aria-label="Continue to permissions"
      >
        Continue
      </button>
    </div>
  );
}
