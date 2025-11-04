<script setup>
import EmergencyNumbers from './EmergencyNumbers.vue';
import Sponsors from './Sponsors.vue';
import qrSito from '@/assets/qrcodes/qrcode-sito-comunale.png?w=160&imagetools';
import qrMappa from '@/assets/qrcodes/qrcode-sito-comunale.png?w=160&imagetools';
import cityCoat from '@/assets/logos/logo-citta-di-paola.png?w=240&imagetools';

import mappaBorgo from '@/assets/maps/mappa-borgo.jpg?w=240&imagetools'
defineProps({
  open: {
    type: Boolean,
    default: false
  }
});
</script>

<template>
  <footer
    :class="[
      'grid h-full grid-rows-[152px_1fr] gap-4 overflow-hidden rounded-t-[28px] bg-gradient-to-tr from-white/85 via-white/78 to-white/65 p-4 shadow-elevated ring-1 ring-white/40 transition-all duration-500 ease-out transform-cpu origin-top',
      open ? 'translate-y-0 opacity-100' : 'translate-y-full opacity-0 pointer-events-none'
    ]"
    :aria-hidden="!open"
  >
    <div class="grid grid-cols-[3fr_1fr] grid-rows-[130px]   gap-y-8 items-stretch">
      <EmergencyNumbers />
        <div class="row-span-2 h-full border-l flex flex-col border-brand/65">
      <div class=" bg-white/78 rounded-[0px] p-3 ring-1 ring-white/45 grid grid-cols-2 grid-rows-[auto_auto] items-center gap-2 ">
        <img :src="cityCoat" alt="Comune di Paola" class="h-[120px] w-auto justify-self-start" draggable="false" />
        <img
          :src="qrSito"
          alt="QR sito comunale"
          class="w-[140px] rounded-[12px] bg-white p-2 ring-1 ring-white/45 justify-self-end"
          draggable="false"
        />
        <div class="col-span-2 text-center">
          <span class="font-grenze text-[23px] uppercase font-bold tracking-[0.02em] leading-none text-brand">{{ $t('home.municipalWebsite') }}</span>
        </div>
      </div>
      <div class=" bg-white/78 rounded-[0px] p-3 ring-1 ring-white/45 grid grid-cols-2 grid-rows-[auto_auto] items-center gap-2">
        <img :src="mappaBorgo" alt="Comune di Paola" class=" w-auto justify-self-start" draggable="false" />
        <img
          :src="qrMappa"
          alt="QR sito comunale"
          class="w-[140px] rounded-[12px] bg-white p-2 ring-1 ring-white/45 justify-self-end"
          draggable="false"
        />

        
        <div class="col-span-2 text-center">
          <span class="font-grenze text-[23px] uppercase font-bold tracking-[0.02em] leading-none text-brand">{{ $t('home.downloadBorgoMap') }}</span>
        </div>
      </div>
      </div>
      <Sponsors />
    
    </div>
    
  </footer>
</template>
