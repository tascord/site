<script setup lang="ts">
import type { Entry } from '~~/server/api/guest';

const page = ref(0);
const count = ref(20);

const avatar = (s: string) => `https://api.dicebear.com/9.x/icons/svg?seed=${s}&backgroundColor[]&icon=bandaid,brush,bug,cloudDrizzle,cloudMoon,disc,droplet,flower3,magic,moonStars,snow2,star,tree`

const posts = ref<Entry[]>([]);

const fetchPosts = async () => {
    posts.value = await $fetch(`/api/guest`, {
        params: { page: page.value, count: count.value }
    });
};

const previousPage = () => {
    page.value = Math.max(page.value - 1, 0);
};

const nextPage = () => {
    page.value = page.value + 1;
};

watch([page, count], fetchPosts, { immediate: true });

const timeStamp = (p: Entry) => {
    const date = new Date(p.timestamp);
    if (date.toDateString() == new Date().toDateString()) {
        return date.toLocaleTimeString('en-US');
    } else {
        return date.toLocaleDateString('en-US');
    }
}
</script>

<template>
    <command command="vim guestbook" no_nl>
        <guestbook />
    </command>

    <command :command="`tail -n +${count * page} guestbook | head -n ${count}`">
        <div class="inline-flex space-x-2">
            <button class="hover:text-pink-400 group flex flex-nowrap" @click="previousPage">
                <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                <span class="whitespace-nowrap">previous</span>
                <span class="text-white opacity-40 group-hover:opacity-60">]</span>
            </button>

            <button class="hover:text-pink-400 group flex flex-nowrap" @click="nextPage">
                <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                <span class="whitespace-nowrap">next</span>
                <span class="text-white opacity-40 group-hover:opacity-60">]</span>
            </button>
        </div>

        <div v-for="post in posts" class="mt-4">
            <div class="flex justify-between w-full items-center">
                <div class="inline-flex items-center" :class="post.author ? '' : 'opacity-40'">
                    <NuxtImg class="w-8 h-8" :src="avatar(post.author ?? 'anonymous')" alt="" />
                    <h3>{{ post.author ?? 'anonymous' }}</h3>
                </div>
                <span class="opacity-40 whitespace-nowrap" :title="new Date(post.timestamp).toLocaleString('en-US')">{{
                    timeStamp(post) }}</span>
            </div>
            <p class="pl-8 ml-[0.1ch] max-w-full whitespace-pre max-h-[10rem] overflow-y-auto" style="text-wrap: auto;">
                {{ post.content }}</p>
        </div>
    </command>
</template>