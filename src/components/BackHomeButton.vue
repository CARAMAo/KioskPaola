<script setup>
import { useRouter } from 'vue-router';
const router = useRouter();
function goHome() {
  router.push('/');
}
</script>

<template>
  <button
    type="button"
    class="group inline-flex items-center gap-3 rounded-2xl bg-brand/75 px-4 py-2 ring-1 ring-white/45 text-white backdrop-blur-lg transition duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent/60"
    @click="goHome"
  >
    <span class="grid h-8 w-8 place-items-center rounded-full bg-brand/10 ring-1 ring-white/50 text-white">
      <svg viewBox="0 0 24 24" class="h-6 w-8" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M15 6l-6 6 6 6" />
        <path d="M9 12h10" />
      </svg>
    </span>
    <span class="font-grenze text-[20px] uppercase tracking-[0.04em] font-bold leading-none">{{ $t('common.backHome') }}</span>
  </button>

</template>
