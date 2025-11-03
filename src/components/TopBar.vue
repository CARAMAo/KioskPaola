<script setup>
import cityCoat from '@/assets/logos/logo-citta-di-paola.png';
import LanguageSwitcher from './LanguageSwitcher.vue';
</script>

<template>
  <header class="topbar">
    <div class="topbar__brand">
      <img :src="cityCoat" alt="Stemma della Città di Paola" class="topbar__brand-image" />
    </div>

    <div class="topbar__title">
      <span>CITTÀ DI PAOLA</span>
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
  grid-template-columns: 140px 1fr 180px;
  height: 100%;
  padding-left: 32px;
  padding-right: 8px;
}

.topbar__brand {
  display: flex;
  justify-content: flex-end;
}

.topbar__brand-image {
  height: 96px;
  object-fit: contain;
}

.topbar__title {
  font-family: 'Georgia', 'Times New Roman', serif;
  font-size: 60px;
  letter-spacing: 2px;
  padding-left: 23px;
  text-align: center;
  text-transform: uppercase;
}

</style>
