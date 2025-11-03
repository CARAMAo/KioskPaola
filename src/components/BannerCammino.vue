<script setup>
import logoCammino from '@/assets/logos/logo-cammino.png?w=280&imagetools';
import mapCammino from '@/assets/maps/mappa-cammino.png?w=376&format=webp&imagetools';
</script>

<template>
  <div class="h-[155px]  corner bg-accent items-center pl-3 flex flex-1 justify-between cursor-pointer">
    <img :src="logoCammino" class="w-[140px]" />
    <span class="text-white font-grenze uppercase text-3xl inline-block relative right-[.7em] top-[0.4rem]">{{
      $t('bannerCammino.title') }}</span>
    <img :src="mapCammino" width="376px" class="h-full" />
  </div>
</template>
