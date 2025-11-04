<script setup>
import cityCoat from '@/assets/logos/logo-citta-di-paola.png?w=400&imagetools';
import LanguageSwitcher from './LanguageSwitcher.vue';
</script>

<template>
  <header class="topbar z-10 shadow-black/60 shadow-[0px_8px_16px]">
    <div class="topbar__brand">
      <img :src="cityCoat" alt="Stemma della Città di Paola" class="topbar__brand-image" />
    </div>

    <div class="topbar__title font-semibold font-grenze">
      <span>Città di Paola</span>
    </div>

    <LanguageSwitcher/>
   
  </header>
</template>

<style>
.topbar {
  align-items: center;
  
  background: var(--color-primary);

  color: var(--color-primary-contrast);
  display: grid;
  grid-template-columns: 140px 1fr 140px;
  place-items: center;
  height: 100%;
  
}

.topbar__brand {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  height:100%;
  gap: 10px;
}

.topbar__brand-image {
  height: 96px;
  object-fit: contain;
}

.topbar__title {
  font-size: 68px;
  letter-spacing: 4px;
  padding-left: 23px;
  text-align: center;
  text-transform: capitalize;
}

</style>
