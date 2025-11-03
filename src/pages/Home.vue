<script setup>
import BannerCammino from '@/components/BannerCammino.vue';

</script>
<template>
    <!-- <img class="bozza" src="../imgs/home.jpg" width="1080" height="1920"/> -->
    <div class="homeContent">
        <div class="map"></div>

        <router-link to="/cammino" class="contents">
            <BannerCammino/>
        </router-link>
        <div class="grid grid-cols-[31.5%_31%_1fr] gap-2">
            <div class="boxComune bg-brand flex relative p-2"><img class="object-contain relative left-5 top-5 self-start " width="120px" src="@/assets/logos/logo-citta-di-paola.png"/>
            <div class="flex self-end gap-2 mb-3 relative top-2"><span class="text-2xl text-white font-grenze uppercase inline-block w-[5em] text-center">{{ $t('home.municipalWebsite') }}</span><img width="80px" src="@/assets/qrcodes/qrcode-sito-comunale.png"/></div></div>
            <router-link to="/borgo" class="contents">
            <div class="boxBorgo  bg-accent flex justify-center align-middle" ><img class="object-contain ml-2  brightness-0 invert text-clip  w-[18em]" src="@/assets/logos/logo-borgo.png"/></div>
            </router-link>
            <router-link to="/museo" class="contents">
            <div class="boxMuseo  bg-brand flex justify-center"><img class="object-contain w-[18em]" src="@/assets/logos/logo-museo.png"/>
            
            </div>
            </router-link>
        </div>
        <div class="grid grid-cols-[22.5%_1fr_22.5%] gap-2">
            <div class="bg-accent flex flex-col items-center pt-4">
                <img width="79%" class="relative right-2" src="@/assets/maps/mappa-borgo.jpg"/>
                <div class="flex items-center mt-3 gap-1"><div class="font-grenze uppercase text-white text-xl pr-5 leading-[1.15] text-right w-[6.5em] tracking-tight">{{ $t('home.downloadBorgoMap') }}</div><img width="40%" src="@/assets/qrcodes/qrcode-cammino.png"/></div>
            </div>
            <router-link to="/santuario" class="contents">
                <div class=" flex relative overflow-hidden justify-center border-solid cursor-pointer">
                    <img width="70%" class="relative left-2 top-[-5px]" src="@/assets/imgs/santuario-sketch.png"/>
                    <span class="font-grenze absolute bottom-5 left-10 text-xl w-[6.6em] leading-[1.15] text-center uppercase">{{ $t('home.sanctuaryTile') }}</span>
                </div>
            </router-link>
            <router-link to="/orari-bus/aut_preite_07" class="contents">
            <div class="bg-accent flex flex-col items-center justify-center text-center">
                <img width="60%" class="mt-1 ml-4" src="@/assets/logos/icon-bus.png"/>
                <span class="inline-block  w-[10em] mt-8 relative  font-grenze text-xl text-white uppercase">{{ $t('home.busTimetables') }}</span>
            </div>
            </router-link>
        </div>
    </div>
</template>

<style lang="css">
.bozza{
    position:absolute;
    top:0;
    left:0;
    opacity:.4;
}

.homeContent{
    display:grid;
    height:100%;
    gap:8px;
    
    grid-template-rows:1fr 155px 261px 262px;
    

}

.map{
    background: url('/TOTEM/MAppa\ Totem.jpg');
    background-size: cover;
}

/* .camminoBanner{
    background-color: var(--color-accent);
} */




</style>
