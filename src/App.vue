<script setup>
import { computed, onBeforeUnmount, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import TopBar from '@/components/TopBar.vue';
import FootBar from './components/FootBar.vue';
import BackHomeButton from './components/BackHomeButton.vue';

const router = useRouter();
const IDLE_SECONDS = 90;
let idleTimeout = null;
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
  if (now - lastResetAt < 200) return;
  lastResetAt = now;
  scheduleIdleTimeout();
}

const BASE_WIDTH = 1080;
const BASE_HEIGHT = 1920;

const applyScale = () => {
  const appRoot = document.getElementById('app');
  if (!appRoot) return;

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

const isHome = computed(() => router.currentRoute.value.path === '/');

const sectionStyle = computed(() => ({
  transformOrigin: 'center center',
  transform: 'scale(var(--app-scale, 1))',
  gridTemplateRows: `128px 1fr ${isHome.value ? 393 : 0}px`
}));

onMounted(() => {
  applyScale();
  window.addEventListener('resize', applyScale);
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
  <div class="relative flex w-[1080px] justify-center">
    <section
      class="relative grid h-[1920px] w-[1080px] gap-0 overflow-hidden  bg-white shadow-glow backdrop-blur-(--blur-strong) transition-[grid-template-rows] duration-500 ease-out"
      :style="sectionStyle"
    >
      

      <TopBar />
      <BackHomeButton v-if="!isHome" :class="`absolute top-[${router.currentRoute.value.path==='/santuario' ? '10.5' : '14.5'}%] left-5 z-10`"/>

      <main
        class="relative  bg-linear-to-br "
      >

        <div class="relative  h-full w-full pb-6">
          <router-view v-slot="{ Component, route }">
            <KeepAlive>
              <Transition name="fade">
                <component :is="Component" :key="route.fullPath" />
              </Transition>
            </KeepAlive>
          </router-view>
        </div>
      </main>

      <FootBar :open="isHome" />
      

    </section>
  </div>
</template>

<style>
:root {
  --app-scale: 1;
  --app-width: 1080px;
  --app-height: 1920px;
}

/* Page slide+fade transition (overlapped) */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 240ms ease, transform 240ms ease;
  position: absolute;
  inset: 0;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.fade-enter-to,
.fade-leave-from {
  opacity: 1;
}
</style>
