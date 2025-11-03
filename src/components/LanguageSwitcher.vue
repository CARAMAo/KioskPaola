<script setup>
import { ref, onMounted, watch } from 'vue';
import flagIt from '@/assets/logos/lang-it.png?w=144&imagetools';
import flagEn from '@/assets/logos/lang-en.png?w=144&imagetools';

const LANG_STORAGE_KEY = 'active-language';

const activeLang = ref('it');

onMounted(() => {
  const stored = localStorage.getItem(LANG_STORAGE_KEY);
  if (stored === 'it' || stored === 'en') {
    activeLang.value = stored;
  }
});

watch(activeLang, (val) => {
  localStorage.setItem(LANG_STORAGE_KEY, val);
});

function setLang(lang) {
  if (lang === 'it' || lang === 'en') {
    activeLang.value = lang;
    // notify listeners (i18n loader)
    try { window.dispatchEvent(new CustomEvent('language-changed', { detail: lang })); } catch {}
  }
}
</script>

<template>
     <div class="topbar__languages" aria-label="Selezione lingua">
      <button
        class="topbar__language"
        type="button"
        :class="{ 'topbar__language--inactive': activeLang !== 'it' }"
        :aria-pressed="activeLang === 'it'"
        @click="setLang('it')"
      >
        <img :src="flagIt" alt="Italiano" />
      </button>
      <button
        class="topbar__language"
        type="button"
        :class="{ 'topbar__language--inactive': activeLang !== 'en' }"
        :aria-pressed="activeLang === 'en'"
        @click="setLang('en')"
      >
        <img :src="flagEn" alt="English" />
      </button>
    </div>
</template>

<style>

.topbar__languages {
  display: flex;
  flex-direction: column;
  gap: 4px;
  align-items: flex-end;
}

.topbar__language {
  background: transparent;
  border: 2px solid rgba(var(--color-primary-contrast-rgb), 0.2);
  border-radius: var(--radius-md);
  cursor: pointer;
  display: grid;
  padding: 2px;
  transition: border-color 0.2s ease;
}

.topbar__language:hover,
.topbar__language:focus-visible {
  border-color: rgba(var(--color-primary-contrast-rgb), 0.7);
}

.topbar__language img {
  display: block;
  height: 48px;
  width: 72px;
  border-radius: 8px;
  object-fit: cover;
}

.topbar__language--inactive img {
  opacity: 0.4;
}

</style>
