// Haptic feedback utilities for Capacitor Haptics plugin

export type HapticStyle = 'light' | 'medium' | 'heavy';

export async function triggerHaptic(style: HapticStyle = 'light'): Promise<void> {
  try {
    const { Haptics, ImpactStyle } = await import('@capacitor/haptics');

    const styleMap = {
      light: ImpactStyle.Light,
      medium: ImpactStyle.Medium,
      heavy: ImpactStyle.Heavy,
    };

    await Haptics.impact({ style: styleMap[style] });
  } catch {
    // Haptics not available in web environment
  }
}

export async function triggerNotification(): Promise<void> {
  try {
    const { Haptics, NotificationType } = await import('@capacitor/haptics');
    await Haptics.notification({ type: NotificationType.Success });
  } catch {
    // Haptics not available
  }
}
