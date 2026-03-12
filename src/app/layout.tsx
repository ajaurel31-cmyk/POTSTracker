import type { Metadata, Viewport } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'POTSTracker – Dysautonomia Diary',
  description:
    'Track your POTS and dysautonomia symptoms, vitals, and triggers. Understand patterns and share insights with your care team.',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'default',
    title: 'POTSTracker',
  },
  applicationName: 'POTSTracker',
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  viewportFit: 'cover',
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#F8FAFB' },
    { media: '(prefers-color-scheme: dark)', color: '#0F1923' },
  ],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <link rel="apple-touch-icon" href="/icons/icon-180.png" />
      </head>
      <body className="antialiased">{children}</body>
    </html>
  );
}
