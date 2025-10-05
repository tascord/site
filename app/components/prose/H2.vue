<script lang="ts" setup>
const { id: headingId } = defineProps<{ id: string }>();
</script>

<template>
    <h2 :id="headingId" class="group">
        <a v-if="headingId" :href="'#' + headingId" class="mr-2 text-gray-400 hover:text-rose-500 no-underline">::</a>
        <slot />
    </h2>
</template>