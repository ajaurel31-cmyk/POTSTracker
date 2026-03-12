import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: 'class',
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#0D7377',
          50: '#E6F5F5',
          100: '#B3E0E1',
          200: '#80CBCD',
          300: '#4DB6B9',
          400: '#26A5A8',
          500: '#0D7377',
          600: '#0B6163',
          700: '#094E50',
          800: '#073C3D',
          900: '#042A2B',
        },
        accent: {
          DEFAULT: '#F4845F',
          50: '#FEF0EB',
          100: '#FCD5C9',
          200: '#F9BAA7',
          300: '#F7A085',
          400: '#F4845F',
          500: '#F16A3C',
          600: '#E04E1E',
          700: '#B53E18',
          800: '#8A2F12',
          900: '#5F200D',
        },
        success: '#2ECC71',
        warning: '#F39C12',
        danger: '#E74C3C',
        bg: {
          light: '#F8FAFB',
          dark: '#0F1923',
        },
        card: {
          light: '#FFFFFF',
          dark: '#1C2533',
        },
      },
      borderRadius: {
        card: '16px',
      },
      fontSize: {
        'dynamic-xs': ['clamp(0.65rem, 0.6rem + 0.25vw, 0.75rem)', { lineHeight: '1rem' }],
        'dynamic-sm': ['clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem)', { lineHeight: '1.25rem' }],
        'dynamic-base': ['clamp(0.875rem, 0.8rem + 0.35vw, 1rem)', { lineHeight: '1.5rem' }],
        'dynamic-lg': ['clamp(1rem, 0.9rem + 0.5vw, 1.125rem)', { lineHeight: '1.75rem' }],
        'dynamic-xl': ['clamp(1.125rem, 1rem + 0.6vw, 1.25rem)', { lineHeight: '1.75rem' }],
        'dynamic-2xl': ['clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem)', { lineHeight: '2rem' }],
        'dynamic-3xl': ['clamp(1.5rem, 1.3rem + 1vw, 1.875rem)', { lineHeight: '2.25rem' }],
      },
      minHeight: {
        'tap': '44px',
      },
      minWidth: {
        'tap': '44px',
      },
    },
  },
  plugins: [],
};

export default config;
