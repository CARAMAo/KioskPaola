<script setup>
import logoCammino from '@/assets/logos/logo-cammino.png?w=280&imagetools';
import mapCammino from '@/assets/maps/mappa-cammino.png?w=376&format=webp&imagetools';
</script>

<template>
  <div
    class="relative flex h-[170px] pl-3 items-center  justify-between overflow-hidden  border border-white/25 bg-gradient-to-r from-accent via-accent/80 to-brand/100 px-0 text-white shadow-elevated ring-2 ring-white/40 transition duration-200"
  >
    <div class="pointer-events-none absolute inset-0 opacity-70">
      <div class="absolute -left-24 top-[-30%] h-[180%] w-2/3 rotate-6 bg-white/12 blur-[120px]"></div>
      <div class="absolute bottom-[-40%] right-[-18%] h-[200%] w-[55%] bg-brand/40 blur-[140px]"></div>
      <div class="absolute inset-0 ring-1 ring-white/25"></div>
    </div>
    <div class="relative flex items-center gap-6">
      <img
        :src="logoCammino"
        class="w-[150px] drop-shadow-[0_16px_32px_rgba(0,0,0,0.35)]"
        draggable="false"
      />
      <div class="flex flex-col gap-1">
        <span class="font-grenze text-[40px] font-[600] capitalize leading-none tracking-[0.1em]">
          {{ $t('bannerCammino.title') }}
        </span>
      </div>
    </div>
    <div class="relative flex w-1/2 h-full items-center ">
      <div class="relative w-full bg-white/12 shadow-inner h-full">
        <img
          :src="mapCammino"

          class=" inset-2 shadow-inner  h-full w-full object-cover"
          draggable="false"
        />
        <div class="absolute inset-0 bg-gradient-to-r from-transparent via-accent/20 to-brand/50"></div>
      </div>
    </div>
  </div>
</template>
