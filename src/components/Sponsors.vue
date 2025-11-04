<script setup>
import { onMounted, onUnmounted, ref } from 'vue';


const sponsors = ref([]);
const activeSponsors = ref([]);

let intervalId = null;
let rotateIndex = 0;
const ROTATE_MS = 2500; // rotation interval

onMounted(() => {
  if (window.api?.getSponsors) {
    try {
      const list = window.api.getSponsors() || [];
      sponsors.value = list.map((src, idx) => ({ id: idx, src }));

      activeSponsors.value = sponsors.value.slice(0, Math.min(4, sponsors.value.length));

      if (sponsors.value.length > activeSponsors.value.length) {
        intervalId = setInterval(() => {
          const activeIds = new Set(activeSponsors.value.map(s => s.id));
          const available = sponsors.value.filter(s => !activeIds.has(s.id));
          if (available.length === 0) return;

          const outIdx = Math.floor(Math.random() * activeSponsors.value.length);

          const incoming = available[Math.floor(Math.random() * available.length)];

          activeSponsors.value.splice(outIdx, 1, incoming);
        }, ROTATE_MS);
      }
    } catch (e) {
      console.error('getSponsors failed', e);
      sponsors.value = [];
      activeSponsors.value = [];
    }
  }
});

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId);
});

</script>
<template>
  <div class="sponsorsRow overflow-hidden ">
    <div class="slot" v-for="(sponsor, i) in activeSponsors" :key="'slot-' + i">
      <Transition name="swap" mode="out-in">
        <img v-if="sponsor" :key="sponsor.id" draggable="false" :src="'data:image/png;base64,' + sponsor.src" />
        <div v-else :key="'placeholder-' + i" class="placeholder"></div>
      </Transition>
    </div>
  </div>
</template>

<style>
.sponsorsRow {
  display: flex;
  gap: 10px;
  justify-content: stretch;

  flex: 1;
  height: 100%;
  background: transparent;

  border-radius: 4px;
  padding: 16px;
}

.slot {
  position: relative;
  flex: 1 1 0;
  min-width: 0;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.slot img {
  max-height: 100%;
  max-width: 100%;
  width: auto;
  height: auto;
  object-fit: contain;
  display: block;
}

.placeholder {
  width: 100%;
  height: 100%;
}

.swap-enter-active,
.swap-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}

.swap-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.swap-enter-to {
  opacity: 1;
  transform: translateY(0);
}

.swap-leave-from {
  opacity: 1;
  transform: translateY(0);
}

.swap-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
