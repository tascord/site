<script lang="ts" setup>
const { link, img, alt } = defineProps<{ link?: string, alt?: string, img: string }>();
</script>

<template>
    <a v-if="link !== undefined" :href="link">
        <NuxtImg :height="50" :src="img" class="p-2 h-[50px]" :alt="alt"/>
    </a>
    <NuxtImg :height="50" v-else :src="img" class="p-2 h-[50px]" :alt="alt"/>
</template>
