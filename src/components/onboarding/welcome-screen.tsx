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
