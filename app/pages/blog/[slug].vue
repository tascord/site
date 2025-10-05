<script setup lang="ts">
const { params } = useRoute();
const slug = params.slug as string;
const { data: post } = await useAsyncData(`blog-${slug}`, () => {
    return queryCollection('blog').path(`/blog/${slug}`).first()
});

useHead({
    title: post.title,
    meta: [
        { name: 'description', content: post.description || post.excerpt || '' },
        { name: 'author', content: post.author ?? 'Flora' },
        { name: 'date', content: post.date, scheme: 'YYYY-MM-DD' }
    ],
    link: [
        post.cover && { rel: 'image_src', href: post.cover }
    ].filter(Boolean)
})
</script>

<template>
    <div class="text-white">
        <article class="prose lg:prose-xl" v-if="post">
            <ContentRenderer :value="post" />
        </article>
        <div v-else class="w-full h-full flex flex-col items-center justify-center">
            post not found
            <a href="/" class="mt-4 hover:text-pink-400 group block flex flex-nowrap">
                <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                <span class="whitespace-nowrap">home</span>
                <span class="text-white opacity-40 group-hover:opacity-60">]</span>
            </a>
        </div>
    </div>
</template>
