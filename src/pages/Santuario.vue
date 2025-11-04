<script setup>
import hero from '@/assets/photos/santuario/santuario.jpg?w=1080&format=webp&imagetools';
import logo from '@/assets/logos/logo-santuario.jpg?w=600&imagetools';

import qrCodeSantuario from '@/assets/qrcodes/qrcode-santuario.png?w=260&imagetools'
</script>

<template>
  <section class="grid h-full grid-rows-[130px_1fr_auto] gap-0 leading-none">
    <div
      class="flex items-center justify-center rounded-[28px] bg-white/85 px-10 ring-1 ring-white/45"
    >
      <img
        :src="logo"
        alt="Basilica Santuario San Francesco di Paola"
        class="h-[140px] object-contain"
        draggable="false"
      />
    </div>

    <article
      class="space-y-0 rounded-[28px] bg-white/85 p-6 shadow-elevated ring-1 ring-white/45 leading-none after:content-[''] after:block after:clear-both"
    >
      <figure
        class="relative float-right ml-4 mb-2 h-[500px] overflow-hidden rounded-[28px] bg-white/90  ring-1 ring-white/45"
      >
        <img
          :src="hero"
          alt="Santuario di San Francesco di Paola"
          class="h-full w-full object-cover"
          draggable="false"
        />
        <div class="pointer-events-none absolute inset-0 bg-gradient-to-t from-brand/25 via-transparent to-transparent"></div>
      </figure>

      <h2 class="font-grenze text-[28px] font-bold uppercase tracking-[0.05em] text-accent">
        {{ $t('santuario.heading') }}
      </h2>
      <p class="whitespace-pre-line text-[22px] font-grenze tracking-[0.01em] text-text">
        {{ $t('santuario.text1') }}
      </p>
    </article>

    <article
      class="space-y-1 rounded-[28px] bg-white/85 px-6 py-3 shadow-elevated ring-1 ring-white/45"
    >
      <h2 class="font-grenze  text-[28px] font-bold uppercase tracking-[0.05em] text-accent">
        {{ $t('santuario.heading2') }}
      </h2>
      <p class="whitespace-pre-line columns-2 text-[22px] font-grenze leading-none tracking-[0.01em] text-text">
        {{ $t('santuario.text2') }}
      </p>
    </article>

    <div
      class="grid grid-cols-[410px_1fr] gap-6 rounded-[28px] bg-gradient-to-r from-brand via-brand/92 to-blue-900 px-8 py-6 text-brand-fg shadow-glow ring-1 ring-white/40"
    >
      <div class="flex justify-center justify-self-end">
        <img
          :src="qrCodeSantuario"
          width="140"
          draggable="false"
          class="drop-shadow-[0_12px_25px_rgba(0,0,0,0.32)]"
        />
      </div>
      <div class="flex flex-col gap-2">
        <div class="font-grenze text-[36px] tracking-[0.12em]">
        www.santuariopaola.it
        </div>
        <div class="mt-1 flex flex-col gap-2 text-[18px]">
          <div class="flex items-center gap-3">
            <svg viewBox="0 0 24 24" class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M21 10c0 6-9 12-9 12S3 16 3 10a9 9 0 1 1 18 0Z" />
              <circle cx="12" cy="10" r="3" />
            </svg>
            <span>L.go San Francesco di Paola 1 - Paola (CS) 87027</span>
          </div>
          <div class="flex items-center gap-3">
            <svg viewBox="0 0 24 24" class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M4 4h16v16H4z" fill="none" />
              <path d="M22 6l-10 7L2 6" />
            </svg>
            <span>info@santuariopaola.it</span>
          </div>
          <div class="flex items-center gap-3">
            <svg viewBox="0 0 24 24" class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2A19.8 19.8 0 0 1 3.1 5.18 2 2 0 0 1 5 3h3a2 2 0 0 1 2 1.72c.12.9.34 1.77.65 2.6a2 2 0 0 1-.45 2.11L9.1 10.9a16 16 0 0 0 4 4l1.47-1.1a2 2 0 0 1 2.11-.45c.83.31 1.7.53 2.6.65A2 2 0 0 1 22 16.92Z" />
            </svg>
            <span>+39 0982 582518</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
