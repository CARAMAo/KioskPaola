<script setup>
import hero1 from '@/assets/photos/museo/Museo 1.jpeg?w=1080&format=webp&imagetools';
import img2 from '@/assets/photos/museo/Museo 2.jpg?w=1000&format=webp&imagetools';
import img3 from '@/assets/photos/museo/Museo 3.jpeg?w=1200&format=webp&imagetools';
import img4 from '@/assets/photos/museo/Museo 4.jpg?w=1000&format=webp&imagetools';
import museoLogo from '@/assets/logos/logo-museo-alt.png?w=400&imagetools';
import qrMuseo from '@/assets/qrcodes/qrcode-museo.png?w=360&imagetools';
import { computed, onMounted, ref, watch } from 'vue';
import { useI18n } from "vue-i18n";
const { t } = useI18n({ useScope: "global" });


const text1 = computed(() => {
  return t('museo.text').split('\n\n').slice(4).join('\n\n')
})

</script>

<template>
  
  <section class="grid h-full grid-rows-[180px_1fr] gap-6 leading-[1]">
    
    <div
      class="flex items-center justify-center rounded-[28px] bg-white/85 px-8 py-6 shadow-elevated ring-1 ring-white/45"
    >
    
      <img
        :src="museoLogo"
        alt="Museo di San Francesco di Paola"
        class="h-full w-[360px] object-contain drop-shadow-[0_18px_32px_rgba(0,0,0,0.25)]"
        draggable="false"
      />
    </div>

    <div class="grid h-full min-h-0 grid-cols-[540px_1fr] gap-6">
      <div class="flex flex-col gap-6 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45">
        <p class="text-[25px] whitespace-pre-line font-grenze leading-[1] tracking-[0.01em] text-text">
          {{ $t('museo.text').split('\n\n').slice(0,4).join('\n\n') }}
        </p>

        <div class="grid grid-cols-[48%_1fr] h-full gap-2">
          <div class="grid grid-rows-[3fr_2fr] gap-2">
            <div class="overflow-hidden rounded-[24px] bg-white/90 shadow-elevated ring-1 ring-white/40">
              <img
                :src="img2"
                alt="Museo dettaglio 2"
                class="h-full w-full object-cover object-center"
                draggable="false"
              />
            </div>
            <div class="overflow-hidden rounded-[24px] bg-white/90 shadow-elevated ring-1 ring-white/40">
              <img
                :src="img4"
                alt="Museo dettaglio 4"
                class="h-full w-full object-cover object-center"
                draggable="false"
              />
            </div>
          </div>
          <div class="overflow-hidden rounded-[24px] bg-white/90 shadow-elevated ring-1 ring-white/40">
            <img
              :src="img3"
              alt="Museo dettaglio 3"
              class="h-full w-full object-cover object-center"
              draggable="false"
            />
          </div>
        </div>
      </div>

      <div class="flex h-full min-h-0 flex-col gap-2">
        <div class="relative h-[660px] overflow-hidden rounded-[28px] bg-white/90 shadow-elevated ring-1 ring-white/45">
          <img
            :src="hero1"
            alt="Museo - esposizione"
            class="h-full w-full object-cover object-center"
            draggable="false"
          />
          <div class="pointer-events-none absolute inset-0 bg-gradient-to-t from-brand/18 via-transparent to-transparent"></div>
        </div>

        <article class="space-y-3 h-[670px] rounded-[28px] bg-white/85 p-5 shadow-elevated ring-1 ring-white/45">
          <p class="text-[23px] whitespace-pre-line font-grenze leading-[1] tracking-[0.01em] text-text">
            {{ text1 }}
          </p>
        </article>

        <article
          class="flex justify-self-end items-center justify-between gap-6 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45"
        >
          <div class="space-y-2">
            <h3 class="font-grenze text-[24px] font-bold uppercase tracking-[0.18em] text-brand">
              {{ $t('common.moreInfoSite') }}
            </h3>
            <p class="text-[18px] font-grenze tracking-[0.06em] text-text">
              Scopri il percorso museale completo scansionando il QR code.
            </p>
          </div>
          <img
            :src="qrMuseo"
            alt="QR Museo"
            class="h-[180px] w-[180px] flex-shrink-0 object-contain drop-shadow-md"
            draggable="false"
          />
        </article>
      </div>
    </div>
  </section>
</template>
