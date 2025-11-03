import { createI18n } from 'vue-i18n';

const STORAGE_KEY = 'active-language';
const initial = (typeof localStorage !== 'undefined' && localStorage.getItem(STORAGE_KEY)) || 'it';

export const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: initial,
  fallbackLocale: 'it',
  messages: {},
});

function installAllLocales(all) {
  if (!all || typeof all !== 'object') return;
  for (const [lang, data] of Object.entries(all)) {
    try { i18n.global.setLocaleMessage(lang, data || {}); } catch {}
  }
}

export function setLang(next) {
  try { localStorage.setItem(STORAGE_KEY, next); } catch {}
  try { i18n.global.locale.value = next; } catch {}
}

export const t = (key) => {
  try { return i18n.global.t(key); } catch { return key; }
};

// Eventuale integrazione con uno switcher esterno
try {
  window.addEventListener('language-changed', (e) => {
    const next = (e && e.detail) || initial;
    setLang(next);
  });
} catch {}

// Bootstrap: carica tutto dai locali esposti da Electron
(function bootstrapI18n() {
  try {
    const api = typeof window !== 'undefined' && window.api;
    if (api && typeof api.getAllLocales === 'function') {
      const all = api.getAllLocales();
      installAllLocales(all);
      // imposta lingua iniziale se disponibile, altrimenti prima disponibile
      if (all && all[initial]) {
        i18n.global.locale.value = initial;
      } else {
        const langs = Object.keys(all || {});
        if (langs.length) i18n.global.locale.value = langs[0];
      }
    }
  } catch {}
})();

export function useI18n() { return { t, setLang }; }
