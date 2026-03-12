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
