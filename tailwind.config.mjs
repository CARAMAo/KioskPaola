const withOpacityValue = (variable, fallbackOpacity = 1) => {
  return ({ opacityValue }) => {
    if (opacityValue !== undefined) {
      return `rgb(var(${variable}) / ${opacityValue})`;
    }
    if (fallbackOpacity !== 1) {
      return `rgb(var(${variable}) / ${fallbackOpacity})`;
    }
    return `rgb(var(${variable}))`;
  };
};

/** @type {import('tailwindcss').Config} */
export default {
  safelist: ['text-text', 'text-text-muted'],
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}',
    './index.js',
    './preload.js'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      backgroundImage: {
        'app-aurora':
          'radial-gradient(circle at 18% 18%, rgba(26,39,73,0.18) 0, transparent 58%), radial-gradient(circle at 82% 8%, rgba(200,146,19,0.22) 0, transparent 60%), linear-gradient(150deg, #f4f7ff 0%, #e5ebff 55%, #dce3ff 100%)',
        'surface-glass': 'linear-gradient(160deg, rgba(255,255,255,0.86) 0%, rgba(255,255,255,0.68) 100%)',
        'surface-highlight': 'linear-gradient(150deg, rgba(26,39,73,0.08), rgba(19,30,60,0.02))'
      },
      boxShadow: {
        elevated: '0 26px 48px -28px rgba(9,15,31,0.65)',
        glow: '0 0 0 1px rgba(255,255,255,0.12), 0 20px 36px -20px rgba(13,31,68,0.45)'
      },
      colors: {
        brand: {
          DEFAULT: withOpacityValue('--color-primary-rgb'),
          fg: withOpacityValue('--color-primary-contrast-rgb')
        },
        accent: withOpacityValue('--color-accent-rgb'),
        bg: {
          DEFAULT: withOpacityValue('--color-background-rgb'),
          surface: withOpacityValue('--color-surface-rgb', 0.94),
          subtle: withOpacityValue('--color-surface-subtle-rgb', 0.68)
        },
        text: {
          DEFAULT: withOpacityValue('--color-text-rgb'),
          muted: withOpacityValue('--color-text-muted-rgb', 0.72)
        },
        border: withOpacityValue('--color-border-soft-rgb', 0.14)
      },
      borderRadius: { md: '12px', lg: '20px' },
      fontFamily: {
        sans: ['Segoe UI','Helvetica Neue','Arial','sans-serif'],
        serif: ['Georgia','Times New Roman','serif'],
        grenze: ['Grenze', 'Georgia', 'Times New Roman', 'serif']
      }
    }
  },
  plugins: []
}
