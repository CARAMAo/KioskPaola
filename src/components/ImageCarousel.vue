<script setup>
import { computed, onBeforeUnmount, onMounted, watch, ref } from 'vue';

const props = defineProps({
  images: {
    type: Array,
    default: () => [],
  },
  interval: {
    type: Number,
    default: 6000,
  },
  autoplay: {
    type: Boolean,
    default: true,
  },
  showIndicators: {
    type: Boolean,
    default: true,
  },
});

const currentIndex = ref(0);
let timerId = null;

const currentImage = computed(() => props.images[currentIndex.value] ?? null);

// Preload & decode images to avoid blank during switch
const preloadCache = new Map();
function preloadImage(url) {
  if (!url) return Promise.resolve();
  if (preloadCache.has(url)) return preloadCache.get(url);
  const img = new Image();
  img.src = url;
  const p = img.decode ? img.decode().catch(() => {}) : Promise.resolve();
  preloadCache.set(url, p);
  return p;
}

function preloadAll(urls) {
  urls.forEach((u) => preloadImage(u));
}

const startAutoplay = () => {
  if (!props.autoplay || props.images.length <= 1) {
    return;
  }

  stopAutoplay();
  timerId = window.setInterval(() => {
    const next = (currentIndex.value + 1) % props.images.length;
    // Fire-and-forget preload of the next image
    preloadImage(props.images[next]);
    currentIndex.value = next;
  }, props.interval);
};

const stopAutoplay = () => {
  if (timerId !== null) {
    window.clearInterval(timerId);
    timerId = null;
  }
};

const goTo = (index) => {
  currentIndex.value = index;
  const next = (index + 1) % props.images.length;
  preloadImage(props.images[next]);
};

onMounted(() => {
  preloadAll(props.images);
  if (props.images.length) preloadImage(props.images[0]);
  startAutoplay();
});

onBeforeUnmount(() => {
  stopAutoplay();
});

watch(
  () => [props.interval, props.autoplay, props.images.length],
  () => {
    preloadAll(props.images);
    startAutoplay();
  }
);

watch(currentIndex, (i) => {
  const next = (i + 1) % props.images.length;
  preloadImage(props.images[next]);
});
</script>

<template>
  <div class="carousel">
    <transition name="carousel-fade">
      <img
        v-if="currentImage"
        :key="currentImage"
        :src="currentImage"
        alt=""
        class="carousel__image"
        decoding="async"
        loading="eager"
        draggable="false"
      />
    </transition>

    <div v-if="showIndicators && images.length > 1" class="carousel__indicators">
      <button
        v-for="(image, index) in images"
        :key="image"
        type="button"
        class="carousel__dot"
        :class="{ 'carousel__dot--active': index === currentIndex }"
        @click="goTo(index)"
      >
        <span class="visually-hidden">Mostra immagine {{ index + 1 }}</span>
      </button>
    </div>
  </div>
</template>

<style>
.carousel {
  border-radius: var(--radius-lg);
  height: 100%;
  overflow: hidden;
  position: relative;
  width: 100%;
}

.carousel__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  backface-visibility: hidden;
  transform: translateZ(0);
  will-change: opacity;
}

.carousel__indicators {
  bottom: 18px;
  display: flex;
  gap: 8px;
  justify-content: center;
  left: 0;
  position: absolute;
  width: 100%;
}

.carousel__dot {
  background: rgba(var(--color-primary-contrast-rgb), 0.55);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  height: 12px;
  padding: 0;
  transition: background 0.25s ease, width 0.25s ease;
  width: 12px;
}

.carousel__dot--active {
  background: var(--color-accent);
  width: 28px;
}

.carousel-fade-enter-active,
.carousel-fade-leave-active {
  transition: opacity 0.4s ease;
}

.carousel-fade-enter-from,
.carousel-fade-leave-to {
  opacity: 0;
}

.visually-hidden {
  border: 0;
  clip: rect(0 0 0 0);
  height: 1px;
  margin: -1px;
  overflow: hidden;
  padding: 0;
  position: absolute;
  width: 1px;
}
</style>
