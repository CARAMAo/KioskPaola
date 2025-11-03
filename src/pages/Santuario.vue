<script setup>
import BackHomeButton from '@/components/BackHomeButton.vue';
import hero from '@/assets/photos/santuario/santuario.jpg?w=1080&format=webp&imagetools';
import logo from '@/assets/logos/logo-santuario.jpg?w=600&imagetools';
import bozza from '@/imgs/santuario.jpg';
import qrCodeSantuario from '@/assets/qrcodes/qrcode-santuario.png?w=260&imagetools'
</script>

<template>
  <section class="h-full">
    <!-- <img :src="bozza" alt="" class="absolute top-0 left-0 w-[1080px] h-[1920px] opacity-30 pointer-events-none select-none z-10" /> -->
    <div class="grid grid-rows-[160px_auto_155px] gap-3 h-full relative">
      <div class="flex items-center justify-center">
        <BackHomeButton />
        <img :src="logo" alt="Basilica Santuario San Francesco di Paola" class="h-full object-contain" draggable="false" />
      </div>

      
        <div class="grid grid-cols-[310px_1fr] grid-rows-[500px_409px_auto] ">
          

          <article class="pr-[1rem]">
            <h2 class="totem-h2 tracking-[0.06rem] leading-[1rem]">{{ $t('santuario.heading') }}</h2>
            <p class="totem-p leading-[16.18px] tracking-[0.0rem]">{{ $t('santuario.text1') }}</p>
          </article>
          <img :src="hero" alt="Santuario di San Francesco di Paola" class="w-[100%] h-[485px] object-cover float-right" draggable="false" />
          
          <article class="col-span-2">
            <h2 class="totem-h2">{{ $t('santuario.heading2') }}</h2>
            <p class="totem-p leading-[1rem]">{{ $t('santuario.text2') }}</p>
          </article>
          
          <article class="col-span-2 flex flex-col gap-1.5">
            <h3 class="totem-h2 text-brand">{{ $t('common.contacts') }}</h3>
            <p class="totem-p">L.go San Francesco di Paola 1 - Paola (CS) 87027</p>
            <p class="totem-p ">Email: info@santuariopaola.it</p>
            <p class="totem-p">{{ $t('common.telephone') }}: +(39) 0982 582518 </p>
          </article>

        </div>
        <div class="border-solid border-t-[2px] border-t-blue-950 grid grid-cols-[34%_1fr]  pt-4 font-serif text-[40px] items-center">
          <div class=" justify-self-end"  ><img :src="qrCodeSantuario" width="130" draggable="false"  /></div>
          <div class="pl-11">www.santuariopaola.it</div>
        </div>
    </div>
  </section>
</template>
