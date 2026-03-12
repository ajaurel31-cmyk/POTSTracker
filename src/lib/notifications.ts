// Notification utilities for Capacitor LocalNotifications plugin
// In a real Capacitor build, import from @capacitor/local-notifications

interface ScheduleOptions {
  id: number;
  title: string;
  body: string;
  hour: number;
  minute: number;
  repeats?: boolean;
}

// Unique ID ranges for different notification types
const NOTIFICATION_IDS = {
  DAILY_LOG: 1000,
  HYDRATION_BASE: 2000,
  MEDICATION_BASE: 3000,
};

export async function scheduleDailyLogReminder(time: string): Promise<void> {
  const [hour, minute] = time.split(':').map(Number);

  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    // Cancel existing daily log notification
    await LocalNotifications.cancel({ notifications: [{ id: NOTIFICATION_IDS.DAILY_LOG }] });

    await LocalNotifications.schedule({
      notifications: [
        {
          title: 'POTSTracker',
          body: 'Time to log your vitals! Tap to open POTSTracker.',
          id: NOTIFICATION_IDS.DAILY_LOG,
          schedule: {
            on: { hour, minute },
            repeats: true,
            allowWhileIdle: true,
          },
          sound: 'default',
          actionTypeId: 'OPEN_LOG',
        },
      ],
    });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function scheduleHydrationReminders(intervalHours: number): Promise<void> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    // Cancel existing hydration notifications (IDs 2000-2099)
    const cancelIds = Array.from({ length: 12 }, (_, i) => ({
      id: NOTIFICATION_IDS.HYDRATION_BASE + i,
    }));
    await LocalNotifications.cancel({ notifications: cancelIds });

    // Schedule reminders from 8am to 10pm
    const notifications = [];
    let id = NOTIFICATION_IDS.HYDRATION_BASE;
    for (let hour = 8; hour <= 22; hour += intervalHours) {
      notifications.push({
        title: 'Stay Hydrated!',
        body: "Don't forget to hydrate! \uD83D\uDCA7",
        id: id++,
        schedule: {
          on: { hour, minute: 0 },
          repeats: true,
          allowWhileIdle: true,
        },
        sound: 'default',
      });
    }

    await LocalNotifications.schedule({ notifications });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function scheduleMedicationReminder(
  medicationId: string,
  name: string,
  time: string,
  index: number
): Promise<void> {
  const [hour, minute] = time.split(':').map(Number);

  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');

    const id = NOTIFICATION_IDS.MEDICATION_BASE + index;
    await LocalNotifications.cancel({ notifications: [{ id }] });

    await LocalNotifications.schedule({
      notifications: [
        {
          title: 'Medication Reminder',
          body: `Time to take ${name}`,
          id,
          schedule: {
            on: { hour, minute },
            repeats: true,
            allowWhileIdle: true,
          },
          sound: 'default',
        },
      ],
    });
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function cancelAllNotifications(): Promise<void> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');
    const pending = await LocalNotifications.getPending();
    if (pending.notifications.length > 0) {
      await LocalNotifications.cancel({ notifications: pending.notifications });
    }
  } catch {
    console.log('LocalNotifications not available (web environment)');
  }
}

export async function requestNotificationPermission(): Promise<boolean> {
  try {
    const { LocalNotifications } = await import('@capacitor/local-notifications');
    const result = await LocalNotifications.requestPermissions();
    return result.display === 'granted';
  } catch {
    // Web fallback
    if (typeof window !== 'undefined' && 'Notification' in window) {
      const result = await Notification.requestPermission();
      return result === 'granted';
    }
    return false;
  }
}
