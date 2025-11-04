<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import * as pdfjsLib from 'pdfjs-dist/legacy/build/pdf';
import workerSrc from 'pdfjs-dist/legacy/build/pdf.worker?url';
import BackHomeButton from '@/components/BackHomeButton.vue';

pdfjsLib.GlobalWorkerOptions.workerSrc = workerSrc;

const pdfs = ref({});
const filename = ref('');
// Keep available list deterministic to avoid random default picks
const available = computed(() =>
  Object.keys(pdfs.value).sort((a, b) => a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' }))
);

const canvasRef = ref(null);
const containerRef = ref(null);
const pageNum = ref(1);
const numPages = ref(1);
let pdfDoc = null;
const route = useRoute();
let loadingTask = null; // pdf.js loading task
let renderTask = null;  // current page render task
let loadSeq = 0;        // sequence to ignore stale loads

const hasPdf = computed(() => !!filename.value && !!pdfs.value[filename.value]);
function base64ToUint8Array(b64) {
  const byteChars = atob(b64);
  const bytes = new Uint8Array(byteChars.length);
  for (let i = 0; i < byteChars.length; i++) bytes[i] = byteChars.charCodeAt(i);
  return bytes;
}

async function loadAndRender() {
  if (!hasPdf.value) return;
  try {
    // Cancel any ongoing render and document load
    try { renderTask?.cancel(); } catch (_) { }
    if (loadingTask && typeof loadingTask.destroy === 'function') {
      try { await loadingTask.destroy(); } catch (_) { }
    }

    const seq = ++loadSeq;
    const bytes = base64ToUint8Array(pdfs.value[filename.value]);
    loadingTask = pdfjsLib.getDocument({ data: bytes });
    pdfDoc = await loadingTask.promise;
    if (seq !== loadSeq) return; // stale
    numPages.value = pdfDoc.numPages;
    pageNum.value = 1;
    await nextTick();
    await renderPage();
  } catch (e) {
    console.error('PDF load error', e);
  }
}

async function renderPage() {
  if (!pdfDoc || !canvasRef.value || !containerRef.value) return;
  const page = await pdfDoc.getPage(pageNum.value);
  const rotation = (page.rotate || 0) % 360;
  // Fit into container
  const containerWidth = containerRef.value.clientWidth || 800;
  const containerHeight = containerRef.value.clientHeight || 600;
  const unscaledViewport = page.getViewport({ scale: 1 });
  const scale = Math.min(
    containerWidth / unscaledViewport.width,
    containerHeight / unscaledViewport.height
  );
  const viewport = page.getViewport({ scale });

  const canvas = canvasRef.value;
  const ctx = canvas.getContext('2d');
  const dpr = window.devicePixelRatio || 1;
  canvas.width = Math.floor(viewport.width * dpr);
  canvas.height = Math.floor(viewport.height * dpr);
  canvas.style.width = `${Math.floor(viewport.width)}px`;
  canvas.style.height = `${Math.floor(viewport.height)}px`;
  const renderContext = {
    canvasContext: ctx,
    viewport,
    transform: dpr !== 1 ? [dpr, 0, 0, dpr, 0, 0] : undefined,
  };
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  try { renderTask?.cancel(); } catch (_) { }
  renderTask = page.render(renderContext);
  try {
    await renderTask.promise;
  } catch (e) {
    // Ignore cancellations; rethrow others
    if (!(e && (e.name === 'RenderingCancelledException' || e.message?.includes('Rendering cancelled')))) {
      throw e;
    }
    return;
  } finally {
    renderTask = null;
  }
}

function nextPage() {
  if (pageNum.value < numPages.value) {
    pageNum.value += 1;
    renderPage();
  }
}
function prevPage() {
  if (pageNum.value > 1) {
    pageNum.value -= 1;
    renderPage();
  }
}

function selectPdf(name) {
  if (name && pdfs.value[name]) {
    filename.value = name;
    try { localStorage.setItem('selectedPdf', name); } catch (_) { }
  }
}

onMounted(() => {
  if (window.api?.getBusPdfs) {
    try {
      pdfs.value = window.api.getBusPdfs() || {};
    } catch (e) {
      console.error('getBusPdfs failed', e);
      pdfs.value = {};
    }
  }
  // Scegli in modo stabile: query ?f=..., poi ultimo scelto, poi primo ordinato
  if (!filename.value && available.value.length) {
    const q = route?.query?.f || route?.query?.file;
    const qName = typeof q === 'string' ? q : Array.isArray(q) ? q[0] : null;
    if (qName && pdfs.value[qName]) {
      filename.value = qName;
    } else {
      let last = null;
      try { last = localStorage.getItem('selectedPdf') || null; } catch (_) { }
      if (last && pdfs.value[last]) {
        filename.value = last;
      } else {
        filename.value = available.value[0];
      }
    }
  }
  if (hasPdf.value) loadAndRender();
});

watch([filename, pdfs], () => {
  if (hasPdf.value) loadAndRender();
});

onBeforeUnmount(async () => {
  try { renderTask?.cancel(); } catch (_) { }
  if (loadingTask && typeof loadingTask.destroy === 'function') {
    try { await loadingTask.destroy(); } catch (_) { }
  }
  pdfDoc = null;
});
</script>

<template>
  <div class="w-full h-full flex flex-col">
    <div class="mb-2 w-full h-16 relative">
    </div>
    <template v-if="hasPdf">
      <div ref="containerRef" class="relative w-full flex-1 flex items-center justify-center bg-white">
        <canvas ref="canvasRef"></canvas>

      </div>
      <div class="relative bottom-16 flex flex-col flex-wrap justify-center items-center gap-6 z-10">
        <div class="flex gap-4 items-center" v-if="numPages != 1">
          <button @click="prevPage" :disabled="pageNum <= 1"
            class=" w-16 h-16 bg-brand text-white text-3xl  px-3 py-2 rounded disabled:opacity-20">←</button>
          <span class="text-3xl text-brand">{{ pageNum }}/{{ numPages }}</span>
          <button @click="nextPage" :disabled="pageNum >= numPages"
            class="w-16 h-16 bg-brand text-white text-3xl px-3 py-2 rounded disabled:opacity-20">→</button>
        </div>
        <div class="pb-1 flex flex-wrap gap-2 justify-center">

          <button v-for="name in available" :key="name" @click="selectPdf(name)"
            class="px-3  h-16 py-1 rounded border text-2xl"
            :class="name === filename ? 'bg-brand text-white border-black' : 'bg-white/20 text-brand border-gray-400'">{{ name
            }}</button>
        </div>
      </div>

    </template>
    <template v-else>
      <div class="text-red-600 mb-2">PDF not found.</div>
      <div class="text-sm">Available:</div>
      <div class="flex flex-wrap gap-2 mt-1">
        <button v-for="name in available" :key="name" class="px-2 py-1 bg-white/20 rounded" @click="selectPdf(name)">{{
          name }}</button>
      </div>
    </template>
  </div>
</template>
