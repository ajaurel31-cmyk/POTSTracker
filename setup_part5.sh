#!/bin/bash
set -e

cat > ~/Desktop/POTSTracker/src/components/log/heart-rate-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/blood-pressure-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/symptoms-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/hydration-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/activity-section.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { Footprints } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { ToggleSwitch } from '@/components/ui/toggle-switch';
import { NumericInput } from '@/components/ui/numeric-input';
import { useLogStore } from '@/stores/log-store';
import { ACTIVITY_LEVELS, EXERCISE_TYPES, type ActivityLevel, type ExerciseData } from '@/types';
import { cn } from '@/lib/utils';

export function ActivitySection() {
  const {
    currentLog,
    setActivityLevel,
    setTimeUpright,
    setExerciseDone,
    setExerciseData,
  } = useLogStore();

  const [exerciseType, setExerciseType] = useState<ExerciseData['type']>(
    currentLog.exercise_data?.type || 'Walking'
  );
  const [exerciseDuration, setExerciseDuration] = useState<number>(
    currentLog.exercise_data?.duration || 30
  );
  const [exerciseIntensity, setExerciseIntensity] = useState<number>(
    currentLog.exercise_data?.intensity || 5
  );

  const updateExercise = (updates: Partial<ExerciseData>) => {
    const data: ExerciseData = {
      type: exerciseType,
      duration: exerciseDuration,
      intensity: exerciseIntensity,
      ...updates,
    };
    if (updates.type) setExerciseType(updates.type);
    if (updates.duration !== undefined) setExerciseDuration(updates.duration);
    if (updates.intensity !== undefined) setExerciseIntensity(updates.intensity);
    setExerciseData(data);
  };

  return (
    <CollapsibleCard title="Activity & Posture" icon={<Footprints className="w-5 h-5" />}>
      <div className="space-y-4">
        {/* Activity Level */}
        <div>
          <span className="text-dynamic-sm font-medium text-gray-600 dark:text-gray-400 mb-2 block">
            Activity Level Today
          </span>
          <div className="flex flex-wrap gap-2">
            {ACTIVITY_LEVELS.map((level) => (
              <button
                key={level}
                onClick={() => setActivityLevel(level)}
                className={cn(
                  'px-3 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap transition-all border',
                  currentLog.activity_level === level
                    ? 'bg-primary text-white border-primary'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="radio"
                aria-checked={currentLog.activity_level === level}
                aria-label={`Activity level: ${level}`}
              >
                {level}
              </button>
            ))}
          </div>
        </div>

        {/* Time Upright */}
        <RangeSlider
          label="Time Spent Upright"
          value={currentLog.time_upright || 0}
          onChange={setTimeUpright}
          min={0}
          max={16}
          step={0.5}
          unit=" hrs"
        />

        {/* Exercise */}
        <ToggleSwitch
          checked={currentLog.exercise_done}
          onChange={(v) => {
            setExerciseDone(v);
            if (!v) setExerciseData(undefined);
          }}
          label="Exercise Performed"
        />

        {currentLog.exercise_done && (
          <div className="space-y-3 pl-2 border-l-2 border-primary/20">
            {/* Exercise Type */}
            <div className="flex flex-wrap gap-2">
              {EXERCISE_TYPES.map((type) => (
                <button
                  key={type}
                  onClick={() => updateExercise({ type: type as ExerciseData['type'] })}
                  className={cn(
                    'px-3 py-2 rounded-lg text-dynamic-sm min-h-tap border',
                    exerciseType === type
                      ? 'bg-primary/10 border-primary text-primary'
                      : 'bg-gray-50 dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400'
                  )}
                  aria-label={`Exercise type: ${type}`}
                >
                  {type}
                </button>
              ))}
            </div>

            <NumericInput
              label="Duration"
              value={exerciseDuration}
              onChange={(v) => updateExercise({ duration: v || 0 })}
              unit="min"
              min={0}
              max={300}
              accessibilityLabel="Exercise duration in minutes"
            />

            <RangeSlider
              label="Intensity"
              value={exerciseIntensity}
              onChange={(v) => updateExercise({ intensity: v })}
              min={1}
              max={10}
            />
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/sleep-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/triggers-section.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { Zap, Plus } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { useAppStore } from '@/stores/app-store';
import { DEFAULT_TRIGGERS } from '@/types';
import { cn } from '@/lib/utils';

export function TriggersSection() {
  const { currentLog, toggleTrigger } = useLogStore();
  const profile = useAppStore((s) => s.profile);
  const [customTrigger, setCustomTrigger] = useState('');
  const [showCustom, setShowCustom] = useState(false);

  const allTriggers = [
    ...DEFAULT_TRIGGERS,
    ...(profile?.custom_triggers || []),
  ];

  const addCustomTrigger = () => {
    if (customTrigger.trim()) {
      toggleTrigger(customTrigger.trim());
      setCustomTrigger('');
      setShowCustom(false);
    }
  };

  return (
    <CollapsibleCard title="Triggers Today" icon={<Zap className="w-5 h-5" />}>
      <div className="space-y-3">
        <div className="flex flex-wrap gap-2">
          {allTriggers.map((trigger) => {
            const isSelected = currentLog.triggers.includes(trigger);
            return (
              <button
                key={trigger}
                onClick={() => toggleTrigger(trigger)}
                className={cn(
                  'px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap border transition-all',
                  isSelected
                    ? 'bg-warning/20 text-yellow-800 dark:text-yellow-200 border-warning'
                    : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
                )}
                role="checkbox"
                aria-checked={isSelected}
                aria-label={`Trigger: ${trigger}`}
              >
                {trigger}
              </button>
            );
          })}
          <button
            onClick={() => setShowCustom(true)}
            className="px-3 py-2 rounded-full text-dynamic-sm font-medium min-h-tap
              border border-dashed border-gray-300 dark:border-gray-600
              text-gray-500 flex items-center gap-1"
            aria-label="Add custom trigger"
          >
            <Plus className="w-4 h-4" />
            Custom
          </button>
        </div>

        {showCustom && (
          <div className="flex gap-2">
            <input
              type="text"
              value={customTrigger}
              onChange={(e) => setCustomTrigger(e.target.value)}
              placeholder="Enter custom trigger"
              className="input-field flex-1"
              onKeyDown={(e) => e.key === 'Enter' && addCustomTrigger()}
              aria-label="Custom trigger name"
              autoFocus
            />
            <button onClick={addCustomTrigger} className="btn-primary px-4" aria-label="Add trigger">
              Add
            </button>
          </div>
        )}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/cycle-section.tsx << 'ENDOFFILE'
'use client';

import { Calendar } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { useLogStore } from '@/stores/log-store';
import { cn } from '@/lib/utils';
import type { CyclePhase } from '@/types';

const phases: { value: CyclePhase; label: string }[] = [
  { value: 'on-period', label: 'On Period' },
  { value: 'pre-period', label: 'Pre-Period' },
  { value: 'mid-cycle', label: 'Mid-Cycle' },
  { value: 'post-period', label: 'Post-Period' },
];

export function CycleSection() {
  const { currentLog, setCyclePhase } = useLogStore();

  return (
    <CollapsibleCard
      title="Menstrual Cycle"
      icon={<Calendar className="w-5 h-5" />}
      defaultOpen={false}
    >
      <div className="flex flex-wrap gap-2">
        {phases.map(({ value, label }) => (
          <button
            key={value}
            onClick={() =>
              setCyclePhase(currentLog.cycle_phase === value ? undefined : value)
            }
            className={cn(
              'px-4 py-2 rounded-xl text-dynamic-sm font-medium min-h-tap border transition-all',
              currentLog.cycle_phase === value
                ? 'bg-accent/20 text-accent border-accent'
                : 'bg-gray-50 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'
            )}
            role="radio"
            aria-checked={currentLog.cycle_phase === value}
            aria-label={`Cycle phase: ${label}`}
          >
            {label}
          </button>
        ))}
      </div>
    </CollapsibleCard>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/medications-section.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/rating-notes-section.tsx << 'ENDOFFILE'
'use client';

import { Smile, StickyNote } from 'lucide-react';
import { CollapsibleCard } from '@/components/ui/collapsible-card';
import { RangeSlider } from '@/components/ui/range-slider';
import { useLogStore } from '@/stores/log-store';
import { getEmojiForRating } from '@/lib/utils';

export function RatingNotesSection() {
  const { currentLog, setOverallRating, setNotes } = useLogStore();

  return (
    <>
      <CollapsibleCard title="Overall Day Rating" icon={<Smile className="w-5 h-5" />}>
        <div className="space-y-2">
          <div className="flex items-center justify-center">
            <span className="text-4xl mr-3" role="img" aria-hidden="true">
              {getEmojiForRating(currentLog.overall_rating || 5)}
            </span>
            <span className="text-dynamic-3xl font-bold text-gray-900 dark:text-gray-100">
              {currentLog.overall_rating || 5}/10
            </span>
          </div>
          <RangeSlider
            label=""
            value={currentLog.overall_rating || 5}
            onChange={setOverallRating}
            min={1}
            max={10}
            showValue={false}
          />
          <div className="flex justify-between text-dynamic-xs text-gray-400">
            <span>Terrible</span>
            <span>Great</span>
          </div>
        </div>
      </CollapsibleCard>

      <CollapsibleCard title="Notes" icon={<StickyNote className="w-5 h-5" />} defaultOpen={false}>
        <div>
          <textarea
            value={currentLog.notes || ''}
            onChange={(e) => {
              if (e.target.value.length <= 500) {
                setNotes(e.target.value);
              }
            }}
            placeholder="Any additional notes about today..."
            className="input-field min-h-[100px] resize-none"
            aria-label="Daily notes"
            maxLength={500}
          />
          <p className="text-dynamic-xs text-gray-400 mt-1 text-right">
            {(currentLog.notes || '').length}/500
          </p>
        </div>
      </CollapsibleCard>
    </>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/log/daily-log-screen.tsx << 'ENDOFFILE'
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
ENDOFFILE
