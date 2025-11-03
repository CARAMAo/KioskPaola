<script setup>
import { computed, nextTick, onMounted, ref, watch } from 'vue';
import * as pdfjsLib from 'pdfjs-dist/legacy/build/pdf';
import workerSrc from 'pdfjs-dist/legacy/build/pdf.worker?url';
import BackHomeButton from '@/components/BackHomeButton.vue';

pdfjsLib.GlobalWorkerOptions.workerSrc = workerSrc;

const pdfs = ref({});
const filename = ref('');
const available = computed(() => Object.keys(pdfs.value));

const canvasRef = ref(null);
const containerRef = ref(null);
const pageNum = ref(1);
const numPages = ref(1);
let pdfDoc = null;

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
    const bytes = base64ToUint8Array(pdfs.value[filename.value]);
    const loadingTask = pdfjsLib.getDocument({ data: bytes });
    pdfDoc = await loadingTask.promise;
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
  await page.render(renderContext).promise;
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
  if (window.api?.debugBusPdfs) {
    try {
      console.log('debugBusPdfs:', window.api.debugBusPdfs());
    } catch (e) {
      console.warn('debugBusPdfs failed', e);
    }
  }
  // Se esiste almeno un PDF, seleziona il primo
  if (!filename.value && available.value.length) {
    filename.value = available.value[0];
  }
  if (hasPdf.value) loadAndRender();
});

watch([filename, pdfs], () => {
  if (hasPdf.value) loadAndRender();
});
</script>

<template>
  <div class="w-full h-full flex flex-col">
    <div class="mb-2 w-full h-16 relative">
      <BackHomeButton/>
    </div>
    <template v-if="hasPdf">
      <div ref="containerRef" class="relative w-full flex-1 flex items-center justify-center bg-white">
        <canvas ref="canvasRef"></canvas>
        
      </div>
      <div class="flex flex-col flex-wrap justify-center items-center gap-2 -mt-10 z-10">
        <div class="flex gap-3 items-center" v-if="numPages!=1">
            <button @click="prevPage" :disabled="pageNum<=1"
                class="  bg-brand text-white px-3 py-2 rounded disabled:opacity-20">←</button>
                <span class="text-2xl">{{ pageNum }}/{{ numPages }}</span>
        <button @click="nextPage" :disabled="pageNum>=numPages"
                class=" bg-brand text-white px-3 py-2 rounded disabled:opacity-20">→</button>
        </div>
              <div class="pb-1 flex flex-wrap gap-2 justify-center">
        
        <button
          v-for="name in available"
          :key="name"
          @click="selectPdf(name)"
          class="px-3 py-1 rounded border text-xl"
          :class="name === filename ? 'bg-brand text-white border-black' : 'bg-white/20 border-gray-400'"
        >{{ name }}</button>
      </div>
      </div>

    </template>
    <template v-else>
      <div class="text-red-600 mb-2">PDF not found.</div>
      <div class="text-sm">Available:</div>
      <div class="flex flex-wrap gap-2 mt-1">
        <button v-for="name in available" :key="name" class="px-2 py-1 bg-white/20 rounded" @click="selectPdf(name)">{{ name }}</button>
      </div>
    </template>
  </div>
</template>
