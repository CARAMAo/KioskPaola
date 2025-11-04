<script setup>
import ImageCarousel from '@/components/ImageCarousel.vue';
import logoBorgo from '@/assets/logos/logo-borgo.png?w=500&imagetools';

import b1 from '@/assets/photos/borgo/Borgo 1.JPG?w=1080&format=webp&imagetools';
import b2 from '@/assets/photos/borgo/Borgo 2.JPG?w=1080&format=webp&imagetools';
import b3 from '@/assets/photos/borgo/Borgo 3.JPG?w=1080&format=webp&imagetools';
import b4 from '@/assets/photos/borgo/Borgo 4.JPG?w=1080&format=webp&imagetools';
import b5 from '@/assets/photos/borgo/Borgo 5.JPG?w=1080&format=webp&imagetools';
import b6 from '@/assets/photos/borgo/Borgo 6.JPG?w=1080&format=webp&imagetools';

const images = [b1, b2, b3, b4, b5, b6];

</script>

<template>
  <section class="grid h-full min-h-0 grid-rows-[auto_485px_1fr] p-6 gap-3 leading-none">
    <div
      class="relative flex my-0 items-center justify-center  rounded-[28px] bg-gradient-to-br from-white/98 via-white/92 to-white/75   ring-1 ring-white/50"
    >
     
      <img
        :src="logoBorgo"
        class="relative w-96  object-contain drop-shadow-[0_20px_24px_rgba(1,1,1,0.28)]"
        draggable="false"
      />
 
    </div>

    <div class="relative overflow-hidden rounded-[28px] bg-white/90 shadow-elevated ring-1 ring-white/45">
      <ImageCarousel
        :images="images"
        :autoplay="true"
        :showIndicators="false"
        :interval="5000"
        class="h-full w-full"
      />
      <div class="pointer-events-none absolute inset-0 bg-gradient-to-t from-brand/20 via-transparent to-transparent"></div>
    </div>

    <div class="grid grid-cols-[1fr_1fr] gap-3 min-h-0 overflow-auto">
      <article class="space-y-2 col-span-2 rounded-[24px] bg-white/88 p-6 shadow-elevated ring-1 ring-white/45">
        <div class="h-1 w-16 rounded-full bg-accent/70"></div>
        <h2 class="font-grenze text-[28px] font-bold uppercase tracking-[0.05em] text-accent">
          {{ $t('borgo.heading') }}
        </h2>
        <p class="whitespace-pre-line text-[22px] font-grenze leading-none tracking-[0.01em] text-text">
          {{ $t('borgo.text1') }}
        </p>

        
      </article>
      <article class="space-y-2 columns-2 col-span-2 rounded-[24px] bg-white/88 p-6 shadow-elevated ring-1 ring-white/45">
     
      <div class="h-1 w-16 rounded-full bg-brand/60"></div>
        <h2 class="font-grenze text-[28px] font-bold uppercase tracking-[0.05em] text-accent">
          {{ $t('borgo.historyHeading') }}
        </h2>
        <p class="whitespace-pre-line text-[22px] font-grenze leading-none tracking-[0.01em] text-text">
          {{ $t('borgo.text2') }}
        </p>
        </article>
    </div>
  </section>
</template>
