<script setup>
import BannerCammino from '@/components/BannerCammino.vue';
import mapHome from '@/assets/maps/mappa-home.jpg?w=1080&format=webp&imagetools';
import logoCity from '@/assets/logos/logo-citta-di-paola.png?w=240&imagetools';
import qrSito from '@/assets/qrcodes/qrcode-sito-comunale.png?w=160&imagetools';
import logoBorgo from '@/assets/logos/logo-borgo.png?w=500&imagetools';
import logoMuseo from '@/assets/logos/logo-museo.png?w=500&imagetools';
import mapBorgo from '@/assets/maps/mappa-borgo.jpg?w=800&format=webp&imagetools';
import qrCammino from '@/assets/qrcodes/qrcode-cammino.png?w=300&imagetools';
import santuarioSketch from '@/assets/imgs/santuario-sketch.png?w=800&imagetools';
import iconBus from '@/assets/logos/icon-bus.png?w=400&imagetools';
</script>

<template>
  <div class="grid h-full grid-rows-[1fr_170px_500px] gap-6">
    <div class="relative h-fit">
      <img :src="mapHome" class="w-full"/>
      <div class="absolute inset-0 bg-gradient-to-br from-brand/15 via-transparent to-accent/15"></div>
    </div>

    <router-link to="/cammino" class="group px-4  h-full focus:outline-none">
      <BannerCammino class="h-full w-full rounded-[28px] transition duration-200 group-active:scale-[0.99]" />
    </router-link>

  
      <div class="grid px-4 h-full grid-cols-2 grid-flow-row grid-rows-2 gap-6">
        
        <!-- <div
          class="relative h-full items-center justify-between rounded-[28px] bg-white/15 overflow-hidden text-brand ring-1 ring-brand/10"
        >
          <img width="100%" :src="mapBorgo" draggable="false" class=" object-cover h-full w-full drop-shadow-[0_14px_20px_rgba(0,0,0,0.22)]" />
          
          <div class="relative flex flex-col items-center gap-3 text-center">
            <span class="font-grenze text-[20px] uppercase tracking-[0.32em]">
              {{ $t('home.downloadBorgoMap') }}
            </span>
            
          </div>
        </div> 
        
          <div
         class="relative row-span-2 grid h-full grid-cols-[auto_1fr_auto] items-center gap-4 rounded-[28px] bg-white/95 p-6 text-brand  ring-1 ring-brand/10"
       >
         <img
           class=" w-auto drop-shadow-[0_12px_22px_rgba(29,43,78,0.22)]"
           :src="logoCity"
           draggable="false"
           alt="Comune di Paola"
         />
         <div class="flex flex-col items-center gap-2 text-center">
           <span class="font-grenze text-[26px] uppercase tracking-[0.14em]">
             {{ $t('home.municipalWebsite') }}
           </span>
         </div>
         <img width="120" :src="qrSito" draggable="false" class="drop-shadow-[0_10px_18px_rgba(0,0,0,0.25)]" />
       

     </div>
        -->
        <router-link to="/borgo" class="group block h-full focus:outline-none">
          <div
            class="relative flex h-full items-center justify-center overflow-hidden rounded-[28px] bg-gradient-to-br from-accent via-accent/95 to-brand/55 px-8 ring-1 shadow-elevated ring-white/40 transition duration-200 group-active:scale-[0.99]"
          >
            <div class="pointer-events-none absolute inset-0 opacity-70">
              <div class="absolute left-[-20%] top-[-30%] h-[160%] w-2/3 rotate-12 bg-white/12 blur-[110px]"></div>
              <div class="absolute inset-0 ring-1 ring-white/25"></div>
            </div>
            <img
              class="relative w-[75%] brightness-0 invert drop-shadow-[0_16px_8px_rgba(0,0,0,0.38)]"
              :src="logoBorgo"
              draggable="false"
            />
          </div>
        </router-link>

       

        <router-link to="/museo" class="group block h-full focus:outline-none">
          <div
            class="relative flex h-full items-center justify-center overflow-hidden rounded-[28px] bg-gradient-to-br from-brand/95 via-brand/90 to-brand/70 px-6 shadow-glow ring-1 ring-white/40 transition duration-200 group-active:scale-[0.99]"
          >
            <div class="pointer-events-none absolute inset-0 opacity-60">
              <div class="absolute right-[-22%] top-[-25%] h-52 w-52 rounded-full bg-accent/30 blur-[120px]"></div>
              <div class="absolute inset-0 ring-1 ring-white/20"></div>
            </div>
            <img
              class="relative w-[21em] drop-shadow-[0_12px_30px_rgba(0,0,0,0.35)]"
              :src="logoMuseo"
              draggable="false"
            />
          </div>
        </router-link>

        
      
        <router-link to="/santuario" class="group block h-full focus:outline-none">
          <div
            class="relative flex h-full items-center justify-center overflow-hidden rounded-[28px] bg-primary shadow-elevated ring-1 ring-white/15 transition duration-200 group-active:scale-[0.99]"
          >
            <div
              class="pointer-events-none absolute inset-0 bg-accent [mask-image:var(--mask-url)] [-webkit-mask-image:var(--mask-url)] [mask-repeat:no-repeat] [-webkit-mask-repeat:no-repeat] [mask-position:center] [-webkit-mask-position:top] [mask-size:cover] [-webkit-mask-size:cover] drop-shadow-[0_18px_35px_rgba(0,0,0,0.25)]"
              :style="{ '--mask-url': `url(${santuarioSketch})` }"
            ></div>

            <div class="pointer-events-none absolute w-full h-full bg-linear-[5deg] from-black/50  to-transparent top-0 left-0 "/>
            <span
              class="absolute bottom-5 left-8 w-[8em] inline-block font-grenze text-[35px] font-semibold capitalize tracking-[0.12em] text-white"
            >
              {{ $t('home.sanctuaryTile') }}
            </span>
          </div>
        </router-link>

       

        <router-link to="/orari-bus/" class="group block h-full focus:outline-none">
          <div
            class="relative flex h-full flex-col items-start justify-center gap-4 overflow-hidden rounded-[28px] bg-linear-to-tr from-accent/95 via-40% to-accent px-8 py-6 text-center text-white shadow-glow ring-1 ring-white/35 transition duration-200 group-active:scale-[0.99]"
          >
           
            <img
              width="57%"
              class="absolute right-3 drop-shadow-[0_18px_30px_rgba(0,0,0,0.28)]"
              :src="iconBus"
              draggable="false"
            />
            <span class="relative font-grenze text-4xl w-32 text-left font-semibold capitalize tracking-[0.02em] leading-tight">
              {{ $t('home.busTimetables') }}
            </span>
          </div>
        </router-link>

        
    </div>
  </div>
</template>
