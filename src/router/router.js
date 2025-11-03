import { createRouter, createWebHashHistory } from 'vue-router';
import Home from '@/pages/Home.vue';
import Borgo from '@/pages/Borgo.vue';
import Santuario from '@/pages/Santuario.vue';
import Museo from '@/pages/Museo.vue';
import Cammino from '@/pages/Cammino.vue';
import PDF from '@/pages/PDF.vue';

const routes = [
  { path: '/', component: Home },
  { path: '/borgo', component: Borgo },
  { path: '/santuario', component: Santuario },
  { path: '/museo', component: Museo },
  { path: '/cammino', component: Cammino },
  { path: '/orari-bus/:filename?', component: PDF },
];

export default createRouter({
  history: createWebHashHistory(),
  routes,
});
