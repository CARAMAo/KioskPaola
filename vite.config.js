import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';
import { imagetools } from 'vite-imagetools';

export default defineConfig(({ command }) => ({
  plugins: [vue(),imagetools()],
  root: '.',
  // In dev serve from '/', in build use './' for file-based loading
  base: command === 'serve' ? '/' : './',
  build: {
    outDir: 'dist',
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    host: '127.0.0.1',
    port: 4000,
  },
}));
