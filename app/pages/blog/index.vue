<script setup lang="ts">
const icon = (s: string) => `https://api.dicebear.com/9.x/icons/svg?seed=${s}&backgroundColor[]&icon=bandaid,brush,bug,cloudDrizzle,cloudMoon,disc,droplet,flower3,magic,moonStars,snow2,star,tree`
const { data: posts } = await useAsyncData(() => {
    return queryCollection('blog').all()
});

</script>

<template>
    <div class="text-white w-full">
        <Hero title="posts" />
    </div>

    <a v-for="post in posts" class="mt-4 block" :href="`/blog/${post.stem}`">
        <div class="flex justify-between w-full items-center text-white">
            <div class="inline-flex items-center">
                <NuxtImg class="w-8 h-8" :src="icon(post.title)" alt="" />
                <h3>{{ post.title }}</h3>
            </div>
            <span class="opacity-40 whitespace-nowrap">{{ post.date }}</span>
        </div>
        <p class="pl-8 ml-[0.1ch] max-w-full whitespace-pre max-h-[10rem] overflow-y-auto text-white"
            style="text-wrap: auto;">
            {{ post.description.slice(0, 80) }}...</p>
    </a>
</template>