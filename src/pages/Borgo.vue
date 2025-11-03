<script setup>
import BackHomeButton from '@/components/BackHomeButton.vue';
import ImageCarousel from '@/components/ImageCarousel.vue';
import logoBorgo from '@/assets/logos/logo-borgo.png?w=500&imagetools'

import b1 from '@/assets/photos/borgo/Borgo 1.JPG?w=1080&format=webp&imagetools';
import b2 from '@/assets/photos/borgo/Borgo 2.JPG?w=1080&format=webp&imagetools';
import b3 from '@/assets/photos/borgo/Borgo 3.JPG?w=1080&format=webp&imagetools';
import b4 from '@/assets/photos/borgo/Borgo 4.JPG?w=1080&format=webp&imagetools';
import b5 from '@/assets/photos/borgo/Borgo 5.JPG?w=1080&format=webp&imagetools';
import b6 from '@/assets/photos/borgo/Borgo 6.JPG?w=1080&format=webp&imagetools';

const images = [b1, b2, b3, b4, b5, b6];

</script>

<template>
  <section class="h-full">
    <!-- <img :src="bozza" alt="" class="absolute top-0 left-0 w-[1080px] h-[1920px] opacity-20 pointer-events-none select-none z-10" /> -->
    <div class="grid grid-rows-[160px_625px_1fr] gap-[16px] h-full relative">
      <div class="flex items-center justify-center">
        <BackHomeButton class="absolute top-5 left-5" />
        <img :src="logoBorgo" class="h-[110%]" draggable="false" />
      </div>

      <div class="border border-[#c9c9c9] -mt-[2px]">
        <ImageCarousel :images="images" :autoplay="true" :showIndicators="false" :interval="5000" />
      </div>

      <div class="grid grid-rows-[143px_1fr] gap-4 mt-[3px]">
        <article class="pt-1">
          <h2 class="text-accent font-[600] tracking-widest uppercase -mb-1">{{ $t('borgo.heading') }}</h2>
          <p class="totem-p ">{{ $t('borgo.text1') }}</p>
        </article>
        <article class="leading-[24px]">
          <h2 class="text-accent font-[600] tracking-wide uppercase">{{ $t('borgo.historyHeading') }}</h2>
          <p class="totem-p leading-[16px]">{{ $t('borgo.text2') }}</p>
        </article>
      </div>
    </div>
  </section>
</template>

<style lang="css">
/* rimuovi qualsiasi raggio nel carosello */
.carousel,
.carousel img {
  border-radius: 0 !important;
}
</style>
