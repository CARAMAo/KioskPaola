import { createRouter, createWebHashHistory } from 'vue-router';
import Home from '@/pages/Home.vue';


const routes = [
  { path: '/', component: Home },
  { path: '/borgo',  component: () => import("@/pages/Borgo.vue")},
  { path: '/santuario',  component: () => import("@/pages/Santuario.vue")},
  { path: '/museo',  component: () => import("@/pages/Museo.vue")},
  { path: '/cammino',  component: () => import("@/pages/Cammino.vue")},
  { path: '/orari-bus/',  component: () => import("@/pages/PDF.vue")},
];

export default createRouter({
  history: createWebHashHistory(),
  routes,
});
