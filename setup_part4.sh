#!/bin/bash
set -e

cat > ~/Desktop/POTSTracker/src/components/onboarding/onboarding-flow.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/welcome-screen.tsx << 'ENDOFFILE'
'use client';

import { Heart, Activity, TrendingUp } from 'lucide-react';

interface WelcomeScreenProps {
  onNext: () => void;
}

export function WelcomeScreen({ onNext }: WelcomeScreenProps) {
  return (
    <div className="flex flex-col items-center justify-between min-h-[calc(100vh-60px)] px-6 py-8">
      <div className="flex-1 flex flex-col items-center justify-center text-center">
        {/* App Icon */}
        <div className="w-24 h-24 rounded-3xl bg-primary flex items-center justify-center mb-6 shadow-lg">
          <Heart className="w-12 h-12 text-white" fill="white" />
        </div>

        <h1 className="text-dynamic-3xl font-bold text-gray-900 dark:text-gray-100 mb-2">
          POTSTracker
        </h1>
        <p className="text-dynamic-lg text-primary font-medium mb-6">
          Track. Understand. Thrive.
        </p>

        <p className="text-dynamic-base text-gray-600 dark:text-gray-400 max-w-sm mb-8 leading-relaxed">
          Your personal dysautonomia diary. Track symptoms, vitals, and triggers
          to better understand your body and share insights with your care team.
        </p>

        {/* Feature highlights */}
        <div className="space-y-4 w-full max-w-sm">
          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0">
              <Activity className="w-5 h-5 text-primary" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Log Daily Vitals
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Heart rate, blood pressure, symptoms & more
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center flex-shrink-0">
              <TrendingUp className="w-5 h-5 text-accent" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Discover Patterns
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Charts and insights to understand your triggers
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3 text-left">
            <div className="w-10 h-10 rounded-full bg-success/10 flex items-center justify-center flex-shrink-0">
              <Heart className="w-5 h-5 text-success" />
            </div>
            <div>
              <p className="text-dynamic-sm font-medium text-gray-900 dark:text-gray-100">
                Share with Doctors
              </p>
              <p className="text-dynamic-xs text-gray-500">
                Export reports for your medical appointments
              </p>
            </div>
          </div>
        </div>
      </div>

      <button
        onClick={onNext}
        className="btn-primary w-full max-w-sm text-dynamic-lg mt-8"
        aria-label="Get Started"
      >
        Get Started
      </button>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/personalization-screen.tsx << 'ENDOFFILE'
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
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/onboarding/permissions-screen.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import { ChevronLeft, Heart, Bell, Shield } from 'lucide-react';

interface PermissionsScreenProps {
  onComplete: () => void;
  onBack: () => void;
}

export function PermissionsScreen({ onComplete, onBack }: PermissionsScreenProps) {
  const [healthKitGranted, setHealthKitGranted] = useState<boolean | null>(null);
  const [notificationsGranted, setNotificationsGranted] = useState<boolean | null>(null);

  const requestHealthKit = async () => {
    // In a real Capacitor build, this would call the HealthKit plugin
    // For now, simulate the request
    try {
      setHealthKitGranted(true);
    } catch {
      setHealthKitGranted(false);
    }
  };

  const requestNotifications = async () => {
    // In a real Capacitor build, this would call LocalNotifications.requestPermissions()
    try {
      if (typeof window !== 'undefined' && 'Notification' in window) {
        const result = await Notification.requestPermission();
        setNotificationsGranted(result === 'granted');
      } else {
        setNotificationsGranted(true);
      }
    } catch {
      setNotificationsGranted(false);
    }
  };

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
        Permissions
      </h2>
      <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mb-8">
        These are optional. You can enable them later in Settings.
      </p>

      <div className="flex-1 space-y-4">
        {/* HealthKit */}
        <div className="card p-4">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-red-50 dark:bg-red-900/20 flex items-center justify-center flex-shrink-0">
              <Heart className="w-5 h-5 text-red-500" />
            </div>
            <div className="flex-1">
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Apple Health
              </h3>
              <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mt-1">
                Import heart rate and step count data automatically. Your health data
                stays on your device and is never sent to any server.
              </p>
              <button
                onClick={requestHealthKit}
                disabled={healthKitGranted !== null}
                className={`mt-3 px-4 py-2 rounded-xl min-h-tap text-dynamic-sm font-medium transition-colors ${
                  healthKitGranted === true
                    ? 'bg-success/20 text-green-700 dark:text-green-300'
                    : healthKitGranted === false
                    ? 'bg-gray-100 dark:bg-gray-800 text-gray-500'
                    : 'bg-primary text-white'
                }`}
                aria-label={
                  healthKitGranted === true
                    ? 'Apple Health connected'
                    : 'Connect Apple Health'
                }
              >
                {healthKitGranted === true
                  ? 'Connected'
                  : healthKitGranted === false
                  ? 'Skipped'
                  : 'Connect Apple Health'}
              </button>
            </div>
          </div>
        </div>

        {/* Notifications */}
        <div className="card p-4">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center flex-shrink-0">
              <Bell className="w-5 h-5 text-blue-500" />
            </div>
            <div className="flex-1">
              <h3 className="text-dynamic-base font-semibold text-gray-900 dark:text-gray-100">
                Notifications
              </h3>
              <p className="text-dynamic-sm text-gray-500 dark:text-gray-400 mt-1">
                Get daily reminders to log your vitals, take medications, and stay hydrated.
                You control exactly which reminders you receive.
              </p>
              <button
                onClick={requestNotifications}
                disabled={notificationsGranted !== null}
                className={`mt-3 px-4 py-2 rounded-xl min-h-tap text-dynamic-sm font-medium transition-colors ${
                  notificationsGranted === true
                    ? 'bg-success/20 text-green-700 dark:text-green-300'
                    : notificationsGranted === false
                    ? 'bg-gray-100 dark:bg-gray-800 text-gray-500'
                    : 'bg-primary text-white'
                }`}
                aria-label={
                  notificationsGranted === true
                    ? 'Notifications enabled'
                    : 'Enable notifications'
                }
              >
                {notificationsGranted === true
                  ? 'Enabled'
                  : notificationsGranted === false
                  ? 'Skipped'
                  : 'Enable Notifications'}
              </button>
            </div>
          </div>
        </div>

        {/* Privacy note */}
        <div className="flex items-start gap-3 px-2 py-3">
          <Shield className="w-5 h-5 text-primary flex-shrink-0 mt-0.5" />
          <p className="text-dynamic-sm text-gray-500 dark:text-gray-400">
            Your data is stored locally on your device. POTSTracker never sends your
            health information to external servers.
          </p>
        </div>
      </div>

      <div className="space-y-3 mt-4">
        <button
          onClick={onComplete}
          className="btn-primary w-full text-dynamic-lg"
          aria-label="Start using POTSTracker"
        >
          Start Tracking
        </button>
        <button
          onClick={onComplete}
          className="w-full text-center text-dynamic-sm text-gray-500 min-h-tap flex items-center justify-center"
          aria-label="Skip permissions and start"
        >
          Skip for now
        </button>
      </div>
    </div>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/shared/tab-navigation.tsx << 'ENDOFFILE'
'use client';

import { ClipboardList, TrendingUp, Lightbulb, User } from 'lucide-react';
import { useAppStore } from '@/stores/app-store';
import { cn } from '@/lib/utils';

const tabs = [
  { id: 'log' as const, label: 'Log Today', icon: ClipboardList },
  { id: 'trends' as const, label: 'Trends', icon: TrendingUp },
  { id: 'insights' as const, label: 'Insights', icon: Lightbulb },
  { id: 'profile' as const, label: 'Profile', icon: User },
];

export function TabNavigation() {
  const { activeTab, setActiveTab } = useAppStore();

  return (
    <nav className="tab-bar" role="tablist" aria-label="Main navigation">
      {tabs.map(({ id, label, icon: Icon }) => (
        <button
          key={id}
          onClick={() => setActiveTab(id)}
          className={cn('tab-item', activeTab === id && 'tab-item-active')}
          role="tab"
          aria-selected={activeTab === id}
          aria-label={label}
        >
          <Icon className="w-6 h-6" />
          <span className="text-[10px] mt-0.5 font-medium">{label}</span>
        </button>
      ))}
    </nav>
  );
}
ENDOFFILE

cat > ~/Desktop/POTSTracker/src/components/shared/app-shell.tsx << 'ENDOFFILE'
'use client';

import { useEffect } from 'react';
import { useAppStore } from '@/stores/app-store';
import { OnboardingFlow } from '@/components/onboarding/onboarding-flow';
import { DailyLogScreen } from '@/components/log/daily-log-screen';
import { TrendsScreen } from '@/components/trends/trends-screen';
import { InsightsScreen } from '@/components/insights/insights-screen';
import { ProfileScreen } from '@/components/profile/profile-screen';
import { TabNavigation } from './tab-navigation';

export function AppShell() {
  const { initialized, onboardingComplete, activeTab, initialize } = useAppStore();

  useEffect(() => {
    initialize();
  }, [initialize]);

  // Loading screen
  if (!initialized) {
    return (
      <div className="min-h-screen bg-primary flex items-center justify-center">
        <div className="text-center">
          <div className="w-20 h-20 rounded-3xl bg-white/20 flex items-center justify-center mx-auto mb-4">
            <svg className="w-10 h-10 text-white" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-white">POTSTracker</h1>
          <p className="text-white/70 mt-1">Loading...</p>
        </div>
      </div>
    );
  }

  // Show onboarding if not completed
  if (!onboardingComplete) {
    return <OnboardingFlow />;
  }

  // Main app
  return (
    <div className="min-h-screen bg-bg-light dark:bg-bg-dark">
      <main>
        {activeTab === 'log' && <DailyLogScreen />}
        {activeTab === 'trends' && <TrendsScreen />}
        {activeTab === 'insights' && <InsightsScreen />}
        {activeTab === 'profile' && <ProfileScreen />}
      </main>
      <TabNavigation />
    </div>
  );
}
ENDOFFILE
