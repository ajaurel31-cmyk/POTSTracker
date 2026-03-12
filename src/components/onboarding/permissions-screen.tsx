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
