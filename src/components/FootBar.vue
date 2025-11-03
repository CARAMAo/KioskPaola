<script setup>
import EmergencyNumbers from './EmergencyNumbers.vue';
import Sponsors from './Sponsors.vue';

</script>

<template>
  <footer class="footbar">
    <EmergencyNumbers/>
    <Sponsors/>
  </footer>
</template>

<style>
.footbar{
  display:grid;
  grid-template-rows: 152px 229px;
  gap: 12px;
  height:100%;
}
</style>
