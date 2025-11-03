<script setup>
import BackHomeButton from '@/components/BackHomeButton.vue';
import hero1 from '@/assets/photos/museo/Museo 1.jpeg';
import img2 from '@/assets/photos/museo/Museo 2.jpg';
import img3 from '@/assets/photos/museo/Museo 3.jpeg';
import img4 from '@/assets/photos/museo/Museo 4.jpg';
import museoLogo from '@/assets/logos/logo-museo-alt.png';
import qrMuseo from '@/assets/qrcodes/qrcode-museo.jpg';
import bozza from '@/imgs/museo.jpg';
</script>

<template>
    <!-- <img :src="bozza" alt="" class="absolute top-0 left-0 w-[1080px] h-[1920px] opacity-20 pointer-events-none select-none z-10" /> -->
  <section class="h-full">
    <div class="grid grid-rows-[169px_1fr] h-full relative">
      <div class="flex w-full relative  justify-center">
        <BackHomeButton />
        <img :src="museoLogo" alt="Museo di San Francesco di Paola" class="w-[400px] h-[100%] relative bottom-[0.3rem] left-0" />
      </div>

      <div class="grid grid-cols-[362px_1fr]  gap-3 mt-[5px] h-full min-h-0">
        <div class="grid grid-rows-[auto_1fr]">
          <p class="totem-p -mt-1 leading-[16.2px]">{{ $t('museo.text') }}</p>

          <div class="flex flex-col  mb-14 items-center gap-12 self-end">
            <div class="text-text text-[16px] uppercase">{{ $t('common.moreInfoSite') }}</div>
            <img :src="qrMuseo" alt="QR Museo" class="w-[180px] h-[180px] object-contain" />
          </div>
        </div>

        <div class="grid grid-rows-[520px_625px] gap-3 h-full min-h-0">
          <div class="overflow-hidden min-h-0">
            <img :src="hero1" alt="Museo - esposizione" class="w-full h-full object-cover object-center" />
          </div>
          <div class="grid grid-cols-[38.8%_1fr] gap-3 h-full min-h-0">
  <div class="grid grid-rows-[3.6fr_2fr] gap-3 h-full min-h-0">
    <div class="overflow-hidden min-h-0">
      <img :src="img2" alt="Museo dettaglio 2" class="w-full h-full object-cover object-center" />
    </div>
    <div class="overflow-hidden min-h-0">
      <img :src="img4" alt="Museo dettaglio 4" class="w-full h-full object-cover object-center" />
    </div>
  </div>

  <div class="overflow-hidden min-h-0">
    <img :src="img3" alt="Museo dettaglio 3" class="w-full h-full object-cover object-center" />
  </div>
</div>
        </div>
      </div>
    </div>
  </section>
</template>
