<script setup lang="ts">
const props = defineProps<{
    title: string,
    author?: string,
    date?: string,
}>();
</script>

<template>
    <div class="w-full">
        <header class="w-full h-[10rem] grid place-items-center mb-12"
            style="background-image: repeating-linear-gradient(135deg, rgba(244, 63, 94, 0.2) 0px, rgba(244, 63, 94, 0.2) 8px, transparent 8px, transparent 16px);">
            <div class="w-[90ch] max-w-[calc(100%_-_2rem)]">
                <h1 :class="`text-6xl font-black leading-[1.25] ${(props.author || props.date) ? '-mb-4' : ''}`">
                    <span class="text-rose-500">::</span>
                    <span>{{ props.title }}</span>
                </h1>
                <p class="text-xl ml-4 font-semibold">{{ props.author }}{{ (props.author || props.date) ? ', ' : '' }}{{
                    props.date }}</p>
            </div>
        </header>
    </div>
</template>