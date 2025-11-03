<script setup>
import { onBeforeUnmount, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import TopBar from '@/components/TopBar.vue';
import EmergencyNumbers from '@/components/EmergencyNumbers.vue';
import Sponsors from '@/components/Sponsors.vue';
import FootBar from './components/FootBar.vue';
import BackHomeButton from './components/BackHomeButton.vue';


const router = useRouter();
const IDLE_SECONDS = 60;
let idleTimeout = null; //handlerTimeout
let lastResetAt = 0;

function goHomeIfNeeded() {
  const path = router.currentRoute.value?.path || '';
  if (path !== '/') {
    router.replace('/');
  }
}

function clearIdleTimeout() {
  if (idleTimeout) {
    clearTimeout(idleTimeout);
    idleTimeout = null;
  }
}

function scheduleIdleTimeout() {
  clearIdleTimeout();
  idleTimeout = setTimeout(() => {
    goHomeIfNeeded();
    clearIdleTimeout();
  }, IDLE_SECONDS * 1000);
}

function resetInactivity() {
  const now = Date.now();
  // Throttle resets to avoid excessive work on move events
  if (now - lastResetAt < 200) return;
  lastResetAt = now;
  scheduleIdleTimeout();
}

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
  // Inactivity tracking (touch kiosk)
  scheduleIdleTimeout();
  const opts = { passive: true };
  window.addEventListener('pointerdown', resetInactivity, opts);
  window.addEventListener('pointermove', resetInactivity, opts);
  window.addEventListener('keydown', resetInactivity, opts);
  window.addEventListener('wheel', resetInactivity, opts);
});

onBeforeUnmount(() => {
  window.removeEventListener('resize', applyScale);
  clearIdleTimeout();
  window.removeEventListener('pointerdown', resetInactivity);
  window.removeEventListener('pointermove', resetInactivity);
  window.removeEventListener('keydown', resetInactivity);
  window.removeEventListener('wheel', resetInactivity);
});



</script>

<template>


  <div class="app-wrapper">
    <BackHomeButton v-if="router.currentRoute.value.path !== '/'" class="top-40 left-5 z-10" />
    <TopBar />
    <main class="content">

      <router-view v-slot="{ Component, route }">
        <KeepAlive>
          <Transition name="fade">
            <component :is="Component" :key="route.fullPath" />
          </Transition>
        </KeepAlive>
      </router-view>
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
  position: relative;
}

/* Page slide+fade transition (overlapped) */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 240ms ease, transform 240ms ease;
  position: absolute;
  inset: 0;
}

.fade-enter-from {
  opacity: 0;

}

.fade-enter-to {
  opacity: 1;

}

.fade-leave-from {
  opacity: 1;

}

.fade-leave-to {
  opacity: 0;

}

.fade-enter-to,
.fade-leave-from {
  opacity: 1;
}
</style>
