<script setup>
import ImageCarousel from '@/components/ImageCarousel.vue';

import qrCode from '@/assets/qrcodes/qrcode-cammino.png?w=260&imagetools';
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
  <section class="grid h-full grid-rows-[155px_1fr_auto] gap-6 leading-[1]">
    <div class="flex items-center">
      <BannerCammino class="rounded-none" />
    </div>

    <div class="grid grid-cols-[0.95fr_2.05fr] grid-rows-[auto_auto_1fr] gap-6">
      <aside
        class="flex flex-col gap-6 row-span-2 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45"
      >
        <article class="space-y-2">
          <h2 class="font-grenze text-[28px] font-bold uppercase tracking-[0.05em] text-accent">
            {{ $t('cammino.associazioneHeading') }}
          </h2>
          <p class="whitespace-pre-line text-[22px] font-grenze leading-[1] tracking-[0.01em] text-text">
            {{ $t('cammino.text1') }}
          </p>
        </article>
      </aside>

      <div
        class="relative flex h-[500px] items-center overflow-hidden rounded-[28px] bg-white/90 shadow-elevated ring-1 ring-white/45"
      >
        <ImageCarousel :show-indicators="false" :images="images" :autoplay="true" :interval="5000" class="h-full w-full" />
        <div class="pointer-events-none absolute inset-0 bg-gradient-to-t from-brand/20 via-transparent to-transparent"></div>
      </div>
      <article
        class="col-start-2 space-y-6 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45"
      >
        <div class="space-y-2">
          <h2 class="font-grenze text-[28px] font-bold capitalize tracking-[0.05em] text-accent">
            {{ $t('cammino.tappeHeading') }}
          </h2>
          <p class="text-[26px] font-grenze leading-[1] tracking-[0.01em] text-brand">
            {{ $t('cammino.tappeSubheading') }}
          </p>
          <p class="whitespace-pre-line text-[24px] font-grenze leading-[1] tracking-[0.01em] text-text">
            {{ $t('cammino.tappeIntro') }}
          </p>
        </div>

        </article>
        <article
        class="col-span-2 space-y-6 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45"
      >
        <div class="grid gap-6 grid-cols-2">
          <div class="space-y-1">
            <h3 class="font-grenze text-[24px] font-bold capitalize tracking-[0.05em] text-brand">
              {{ $t('cammino.viaGiovaneHeading') }}
            </h3>
            <p class="text-[18px] font-grenze capitalize tracking-[0.08em] font-bold text-accent">
              {{ $t('cammino.viaGiovaneSubheading') }}
            </p>
            <p class="whitespace-pre-line text-[20px] font-grenze leading-[1] tracking-[0.01em] text-text">
              {{ $t('cammino.viaGiovaneText') }}
            </p>
          </div>
          <div class="space-y-1">
            <h3 class="font-grenze text-[24px] font-bold capitalize tracking-[0.05em] text-brand">
              {{ $t('cammino.viaEremitaHeading') }}
            </h3>
            <p class="text-[18px] font-grenze capitalize tracking-[0.08em] font-bold text-accent">
              {{ $t('cammino.viaEremitaSubheading') }}
            </p>
            <p class="whitespace-pre-line text-[20px] font-grenze leading-[1] tracking-[0.01em] text-text">
              {{ $t('cammino.viaEremitaText') }}
            </p>
          </div>
          <div class="space-y-1">
            <h3 class="font-grenze text-[24px] font-bold capitalize tracking-[0.05em] text-brand">
              {{ $t('cammino.viaMonasteriHeading') }}
            </h3>
            <p class="text-[18px] font-grenze capitalize tracking-[0.08em] font-bold text-accent">
              {{ $t('cammino.viaMonasteriSubheading') }}
            </p>
            <p class="whitespace-pre-line text-[20px] font-grenze leading-[1] tracking-[0.01em] text-text">
              {{ $t('cammino.viaMonasteriText') }}
            </p>
          </div>
          <div class="space-y-1">
            <h3 class="font-grenze text-[24px] font-bold capitalize tracking-[0.05em] text-brand">
              {{ $t('cammino.viaFranciaHeading') }}
            </h3>
            <p class="text-[18px] font-grenze capitalize tracking-[0.08em] font-bold text-accent">
              {{ $t('cammino.viaFranciaSubheading') }}
            </p>
            <p class="whitespace-pre-line text-[20px] font-grenze leading-[1] tracking-[0.01em] text-text">
              {{ $t('cammino.viaFranciaText') }}
            </p>
          </div>
        </div>
      </article>
    </div>

    <div
      class="grid grid-cols-[220px_1fr] items-center gap-6 rounded-[28px] bg-gradient-to-r from-brand via-brand/90 to-brand/80 px-8 py-6 text-brand-fg shadow-glow ring-1 ring-white/40"
    >
      <div class="flex justify-center">
        <img :src="qrCode" width="140" draggable="false" class="drop-shadow-[0_12px_25px_rgba(0,0,0,0.35)]" />
      </div>
      <div class="font-grenze text-[42px] tracking-[0.1em]">
        www.ilcamminodisanfrancesco.it
      </div>
    </div>
  </section>
</template>
