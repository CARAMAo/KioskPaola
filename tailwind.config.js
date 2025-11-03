/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}',
    './electron.js',
    './preload.js'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        brand: { DEFAULT: 'var(--color-primary)', fg: 'var(--color-primary-contrast)' },
        accent: 'var(--color-accent)',
        bg: { DEFAULT: 'var(--color-background)', surface: 'var(--color-surface)', subtle: 'var(--color-surface-subtle)' },
        text: { DEFAULT: 'var(--color-text)', muted: 'var(--color-text-muted)' },
        border: 'rgba(13,31,68,0.12)'
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
