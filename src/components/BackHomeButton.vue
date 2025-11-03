<script setup>
import { useRouter } from 'vue-router';
const router = useRouter();
function goHome() {
  router.push('/');
}
</script>

<template>
  <button type="button"
    class="inline-flex absolute items-center bg-brand text-brand-fg font-grenze text-[22px] font-semibold uppercase tracking-[0.5px] leading-none px-4 py-2.5 focus:outline-none focus:ring-4 focus:ring-accent"
    @click="goHome">
    ← {{ $t('common.backHome') }}
  </button>

</template>
