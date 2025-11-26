<script setup>
import { onMounted, onUnmounted, ref } from 'vue';


const sponsors = ref([]);
const activeSponsor = ref(0);



let intervalId = null;
const ROTATE_MS = 7500; // rotation interval

onMounted(() => {
  if (window.api?.getSponsors) {
    try {
      const list = window.api.getSponsors() || [];
      sponsors.value = list.map((src, idx) => ({ id: idx, src }));

      if (sponsors.value.length > 1) {
        intervalId = setInterval(() => {
          activeSponsor.value = (activeSponsor.value + 1) % sponsors.value.length;
        }, ROTATE_MS);
      }
    } catch (e) {
      console.error('getSponsors failed', e);
      sponsors.value = [];
      activeSponsors.value = 0;
    }
  }
});

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId);
});

</script>
<template>
  <div class="sponsorsRow overflow-hidden ">
    <div class="slot">
      <Transition name="swap" mode="out-in">
        <img v-if="sponsors[activeSponsor]" :key="sponsors[activeSponsor].id" draggable="false"
          :src="'data:image/png;base64,' + sponsors[activeSponsor].src" />
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
  transform: translateX(10px);
}

.swap-enter-to {
  opacity: 1;
  transform: translateX(0);
}

.swap-leave-from {
  opacity: 1;
  transform: translateX(0);
}

.swap-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}
</style>
