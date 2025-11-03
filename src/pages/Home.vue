<script setup>
import BannerCammino from '@/components/BannerCammino.vue';
import mapHome from '@/assets/maps/mappa-home.jpg?w=1080&format=webp&imagetools';
import logoCity from '@/assets/logos/logo-citta-di-paola.png?w=240&imagetools';
import qrSito from '@/assets/qrcodes/qrcode-sito-comunale.png?w=160&imagetools';
import logoBorgo from '@/assets/logos/logo-borgo.png?w=500&imagetools';
import logoMuseo from '@/assets/logos/logo-museo.png?w=500&imagetools';
import mapBorgo from '@/assets/maps/mappa-borgo.jpg?w=800&format=webp&imagetools';
import qrCammino from '@/assets/qrcodes/qrcode-cammino.png?w=300&imagetools';
import santuarioSketch from '@/assets/imgs/santuario-sketch.png?w=800&imagetools';
import iconBus from '@/assets/logos/icon-bus.png?w=400&imagetools';

</script>
<template>
    <!-- <img class="bozza" src="../imgs/home.jpg" width="1080" height="1920"/> -->
    <div class="homeContent">
        <div class="map" :style="{ backgroundImage: `url(${mapHome})` }"></div>

        <router-link to="/cammino" class="contents">
            <BannerCammino class="transition duration-150 ease-out active:brightness-90 active:translate-y-[1px]" />
        </router-link>
        <div class="grid grid-cols-[31.5%_31%_1fr] gap-2">
            <div class="boxComune bg-brand flex relative p-2"><img
                    class="object-contain relative left-5 top-5 self-start " width="120" :src="logoCity"
                    draggable="false" />
                <div class="flex self-end gap-2 mb-3 relative top-2"><span
                        class="text-2xl text-white font-grenze uppercase inline-block w-[5em] text-center">{{
                            $t('home.municipalWebsite') }}</span><img width="80" :src="qrSito" draggable="false" /></div>
            </div>
            <router-link to="/borgo" class="contents">
                <div
                    class="boxBorgo bg-accent flex justify-center align-middle transition duration-150 ease-out active:brightness-90 active:translate-y-[1px]">
                    <img class="object-contain ml-2  brightness-0 invert text-clip  w-[18em]" :src="logoBorgo"
                        draggable="false" />
                </div>
            </router-link>
            <router-link to="/museo" class="contents">
                <div
                    class="boxMuseo bg-brand flex justify-center transition duration-150 ease-out active:brightness-90 active:translate-y-[1px]">
                    <img class="object-contain w-[18em]" :src="logoMuseo" draggable="false" />

                </div>
            </router-link>
        </div>
        <div class="grid grid-cols-[22.5%_1fr_22.5%] gap-2">
            <div class="bg-accent flex flex-col items-center pt-4">
                <img width="79%" class="relative right-2" :src="mapBorgo" draggable="false" />
                <div class="flex items-center mt-3 gap-1">
                    <div
                        class="font-grenze uppercase text-white text-xl pr-5 leading-[1.15] text-right w-[6.5em] tracking-tight">
                        {{ $t('home.downloadBorgoMap') }}</div><img width="40%" :src="qrCammino" draggable="false" />
                </div>
            </div>
            <router-link to="/santuario" class="contents">
                <div
                    class="flex relative overflow-hidden justify-center border-2 border-gray-200 cursor-pointer transition duration-150 ease-out active:brightness-90 active:translate-y-[1px]">
                    <img width="70%" class="relative left-2 top-[-5px]" :src="santuarioSketch" draggable="false" />
                    <span
                        class="font-grenze absolute bottom-5 left-10 text-xl w-[6.6em] leading-[1.15] text-center uppercase">{{
                            $t('home.sanctuaryTile') }}</span>
                </div>
            </router-link>
            <router-link to="/orari-bus/" class="contents">
                <div
                    class="bg-accent flex flex-col items-center justify-center text-center transition duration-150 ease-out active:brightness-90 active:translate-y-[1px]">
                    <img width="60%" class="mt-1 ml-4" :src="iconBus" draggable="false" />
                    <span class="inline-block  w-[10em] mt-8 relative  font-grenze text-xl text-white uppercase">{{
                        $t('home.busTimetables') }}</span>
                </div>
            </router-link>
        </div>
    </div>
</template>

<style lang="css">
.bozza {
    position: absolute;
    top: 0;
    left: 0;
    opacity: .4;
}

.homeContent {
    display: grid;
    height: 100%;
    gap: 8px;

    grid-template-rows: 1fr 155px 261px 262px;


}

.map {
    background-size: cover;
    background-position: center;
}

/* .camminoBanner{
    background-color: var(--color-accent);
} */
</style>
