<script lang="ts" setup>
const { link, img, alt } = defineProps<{ link?: string, alt?: string, img: string }>();
</script>

<template>
    <a v-if="link !== undefined" :href="link">
        <img :src="img" class="p-2" :alt="alt">
    </a>
    <img v-else :src="img" class="p-2" :alt="alt">
</template>
