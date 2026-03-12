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
