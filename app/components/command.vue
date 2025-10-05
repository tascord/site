<script setup lang="ts">
const { command, no_nl } = defineProps<{ command: string, no_nl?: boolean }>();
</script>

<template>
    <section class="text-white text-xl font-semibold p-8">
        <div class="flex w-full justify-between">
            <div class="flex flex-row">
                <div class="flex flex-row">
                    <span class="opacity-40 block mr-2">λ</span>
                </div>
                <span>{{ command }}</span>
            </div>
            <span class="opacity-40 whitespace-nowrap">{{ new Date().toLocaleTimeString('en-US') }}</span>
        </div>
        <p class="text-lg opacity-75"><span v-if="no_nl === false"
                class="text-xl opacity-40 mr-1 inline-block float-start">╰&rsaquo;</span>
            <slot />
        </p>
    </section>
</template>