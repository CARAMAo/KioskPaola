<script setup>
import BackHomeButton from '@/components/BackHomeButton.vue';
import ImageCarousel from '@/components/ImageCarousel.vue';

import qrCode from '@/assets/qrcodes/qrcode-cammino.png?w=260&imagetools'
import c1 from '@/assets/photos/cammino/1.jpg?w=1080&format=webp&imagetools';
import c2 from '@/assets/photos/cammino/2.jpg?w=1080&format=webp&imagetools';
import c3 from '@/assets/photos/cammino/3.jpg?w=1080&format=webp&imagetools';
import c4 from '@/assets/photos/cammino/4.jpg?w=1080&format=webp&imagetools';
import c5 from '@/assets/photos/cammino/5.jpg?w=1080&format=webp&imagetools';
import c6 from '@/assets/photos/cammino/6.jpg?w=1080&format=webp&imagetools';
import c7 from '@/assets/photos/cammino/7.jpg?w=1080&format=webp&imagetools';
import c8 from '@/assets/photos/cammino/8.jpg?w=1080&format=webp&imagetools';
import BannerCammino from '@/components/BannerCammino.vue';

const images = [c1, c2, c3, c4, c5, c6, c7, c8];
</script>

<template>
  <section class="h-full ">

    <div class="grid grid-rows-[auto_auto_1fr] gap-[0.6rem] h-full relative">
      <div class="flex items-center relative h-full ">
        <BackHomeButton />
        <BannerCammino />
      </div>


      <div class="grid grid-cols-[1fr_2.5fr] gap-y-[2.99em] gap-3">
        <aside class="grid  pt-1">
          <article>
            <h2 class="totem-h2 leading-[17px] tracking-wide text-[17px]">{{ $t('cammino.associazioneHeading') }}</h2>
            <p class="totem-p tracking-[0.08px] leading-[16.28px]">{{ $t('cammino.text1') }}</p>
          </article>

        </aside>

        <div class="border h-[490px] flex items-center border-[#c9c9c9] col-start-2">
          <ImageCarousel :show-indicators="false" :images="images" :autoplay="true" :interval="5000" />
        </div>

        <article class=" col-span-2">
          <h2 class="totem-h2">{{ $t('cammino.tappeHeading') }}</h2>
          <p class="totem-p">{{ $t('cammino.tappeSubheading') }}</p>
          <p class="totem-p">{{ $t('cammino.tappeIntro') }}</p>

          <h3 class=" totem-h2 text-brand font-bold">{{ $t('cammino.viaGiovaneHeading') }}</h3>
          <p class="text-text text-sm">{{ $t('cammino.viaGiovaneSubheading') }}</p>
          <p class="totem-p">{{ $t('cammino.viaGiovaneText') }}</p>

          <h3 class=" totem-h2 text-brand font-bold">{{ $t('cammino.viaEremitaHeading') }}</h3>
          <p class="text-text text-sm">{{ $t('cammino.viaEremitaSubheading') }}</p>
          <p class="totem-p">{{ $t('cammino.viaEremitaText') }}</p>

          <h3 class=" totem-h2 text-brand font-bold">{{ $t('cammino.viaMonasteriHeading') }}</h3>
          <p class="text-text text-sm">{{ $t('cammino.viaMonasteriSubheading') }}</p>
          <p class="totem-p">{{ $t('cammino.viaMonasteriText') }}</p>

          <h3 class=" totem-h2 text-brand font-bold">{{ $t('cammino.viaFranciaHeading') }}</h3>
          <p class="text-text text-sm">{{ $t('cammino.viaFranciaSubheading') }}</p>
          <p class="totem-p">{{ $t('cammino.viaFranciaText') }}</p>
        </article>

      </div>
      <div
        class="border-solid border-t-[2px] border-t-blue-950 grid grid-cols-[22%_1fr]  pt-4 font-serif text-[40px] items-center">
        <div class=" justify-self-end"><img :src="qrCode" width="130" draggable="false" /></div>
        <div class="pl-11">www.ilcamminodisanfrancesco.it</div>
      </div>
    </div>
  </section>
</template>

<style lang="css">
.carousel,
.carousel img {
  border-radius: 0 !important;
}
</style>
