<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue';
import TopBar from '@/components/TopBar.vue';
import EmergencyNumbers from '@/components/EmergencyNumbers.vue';
import Sponsors from '@/components/Sponsors.vue';
import FootBar from './components/FootBar.vue';

const BASE_WIDTH = 1080;
const BASE_HEIGHT = 1920;

const applyScale = () => {
  const appRoot = document.getElementById('app');
  if (!appRoot) {
    return;
  }

  const scale = window.innerHeight / BASE_HEIGHT;
  const scaledWidth = BASE_WIDTH * scale;
  const scaledHeight = BASE_HEIGHT * scale;

  appRoot.style.setProperty('--app-scale', String(scale));
  appRoot.style.setProperty('--app-width', `${scaledWidth}px`);
  appRoot.style.setProperty('--app-height', `${scaledHeight}px`);
};

if (typeof window !== 'undefined') {
  applyScale();
}

onMounted(() => {
  applyScale();
  window.addEventListener('resize', applyScale);
  
});

onBeforeUnmount(() => {
  window.removeEventListener('resize', applyScale);
});



</script>

<template>


  <div class="app-wrapper">
      <div class="absolute top-6 left-6 text-3xl text-red-500">
    {{ timer }}
  </div>
    <TopBar />
    <main class="content">
      <router-view />
      
    </main>
    <FootBar />
  </div>
</template>

<style>
:root {
  --app-scale: 1;
  --app-width: 1080px;
  --app-height: 1920px;
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
  height: 100%;
  background: #fff;
  color: #000;
  font-family: sans-serif;
}

body {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
}

#app {
  /* width: var(--app-width, calc(100vh * 9 / 16)); */
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  flex-shrink: 0;
}

.app-wrapper {
  width: auto;
  height: 1920px;
  aspect-ratio: 9/16;
  padding: 15px;
  gap: 15px;
  display: grid;
  background: #fff;
  color: #000;
  grid-template-rows: 128px 1fr 393px;
  transform-origin: center center;
  transform: scale(var(--app-scale, 1));
}

.content {
  height: 100%;
  width: 100%;
  overflow: hidden;
}
</style>
