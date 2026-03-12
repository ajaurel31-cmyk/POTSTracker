'use client';

import { useState } from 'react';
import { WelcomeScreen } from './welcome-screen';
import { PersonalizationScreen } from './personalization-screen';
import { PermissionsScreen } from './permissions-screen';
import { useAppStore } from '@/stores/app-store';
import type { DiagnosisType } from '@/types';
import { DEFAULT_TRIGGERS } from '@/types';

export function OnboardingFlow() {
  const [step, setStep] = useState(0);
  const { completeOnboarding, updateProfile } = useAppStore();

  // Personalization state
  const [diagnosis, setDiagnosis] = useState<DiagnosisType>('Undiagnosed');
  const [triggers, setTriggers] = useState<string[]>([]);
  const [medications, setMedications] = useState('');

  const handlePersonalizationDone = async () => {
    await updateProfile({
      diagnosis_type: diagnosis,
      custom_triggers: triggers,
      medications: medications
        ? medications.split(',').map((m) => ({
            id: crypto.randomUUID?.() || Math.random().toString(36).slice(2),
            name: m.trim(),
            dosage: '',
            time_of_day: 'morning' as const,
            reminder_enabled: false,
          }))
        : [],
    });
    setStep(2);
  };

  const handleComplete = async () => {
    await completeOnboarding();
  };

  return (
    <div className="min-h-screen bg-bg-light dark:bg-bg-dark">
      {/* Progress dots */}
      <div className="flex justify-center gap-2 pt-safe-top pt-4 pb-2">
        {[0, 1, 2].map((i) => (
          <div
            key={i}
            className={`w-2.5 h-2.5 rounded-full transition-colors ${
              i === step ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'
            }`}
            aria-label={`Step ${i + 1} of 3${i === step ? ', current' : ''}`}
          />
        ))}
      </div>

      {step === 0 && <WelcomeScreen onNext={() => setStep(1)} />}
      {step === 1 && (
        <PersonalizationScreen
          diagnosis={diagnosis}
          setDiagnosis={setDiagnosis}
          triggers={triggers}
          setTriggers={setTriggers}
          medications={medications}
          setMedications={setMedications}
          onNext={handlePersonalizationDone}
          onBack={() => setStep(0)}
        />
      )}
      {step === 2 && (
        <PermissionsScreen onComplete={handleComplete} onBack={() => setStep(1)} />
      )}
    </div>
  );
}
