<script setup>
const contacts = [
  { number: '0982 58001', label: 'Comune di Paola' },
  { number: '0982 582622', label: 'Polizia Municipale' },
  { number: 'xxxxxxxxx', label: 'Assistenza Tecnica' },
  { number: '112', label: 'Carabinieri' },
  { number: '113', label: 'Polizia' },
  { number: '115', label: 'Vigili del Fuoco' },
  { number: '117', label: 'Guardia di Finanza' },
  { number: '118', label: 'Pronto Soccorso' },
  { number: '1530', label: 'Guardia Costiera' },
];

</script>

<template>
  <div
    class="border-solid text-xl py-4 border-t-[7px] border-b-[7px] grid grid-flow-col grid-rows-3 gap-x-6 gap-y-2 justify-around items-stretch border-brand h-full">
    <div v-for="(c, i) in contacts" :key="i" class="flex flex-col items-start justify-center">
      <span><strong class="inline">{{ c.number }}</strong> - {{ c.label }}</span>
    </div>
  </div>
</template>

<style></style>
