<script setup>
const contacts = [
  { number: '0982 58001', label: 'Comune di Paola' },
  { number: '0982 582622', label: 'Polizia Municipale' },
  { number: '112', label: 'Carabinieri' },
  { number: '113', label: 'Polizia' },
  { number: '115', label: 'Vigili del Fuoco' },
  { number: '117', label: 'Guardia di Finanza' },
  { number: '118', label: 'Pronto Soccorso' },
  { number: '1530', label: 'Guardia Costiera' },
];
</script>

<template>
  <div class="h-full rounded-[22px] bg-white/75 px-2 ring-1 ring-white/45 font-grenze">
    <div class="grid h-full items-stretch w-full grid-cols-4 grid-rows-2 gap-4 content-center">
      <div
        v-for="(c, i) in contacts"
        :key="i"
        class="group relative h-8 w-full flex flex-col gap-0 rounded-[14px] text-[16px] text-nowrap leading-0 px-0"
      >
        <span class="text-brand text-3xl track z-0 font-semibold tabular-nums ring-1 bg-slate-50 ring-brand/60 rounded-2xl px-2">{{ c.number }}</span>
        <span class="text-text-muted relative z-10 text-[22px] self-center top-2 px-1 font-bold  border-brand/60">{{ c.label }}</span>
      </div>
    </div>
  </div>
</template>

<style></style>
