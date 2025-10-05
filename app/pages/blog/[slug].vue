<script setup lang="ts">
const { params } = useRoute();
const slug = params.slug as string;
const { data: post } = await useAsyncData(`${slug}`, () => {
    return queryCollection('blog').path(`/${slug}`).first()
});

useHead({
    title: post.value?.title,
    meta: [
        { name: 'description', content: post.value?.description.slice(0, 80) + '...' },
        { name: 'author', content: 'flora' },
        { name: 'date', content: post.value?.date },
        { name: 'fediverse:creator', content: '@flora@faggot.sh' }
    ],
})
</script>

<template>
    <div class="text-white w-full">
        <article class="prose lg:prose-xl w-full" v-if="post">
            <Hero :title="post.title" :author="'flora'" :date="post.date" />
            <ContentRenderer :value="post" />
        </article>
        <div v-else class="w-full h-full flex flex-col items-center justify-center">
            post not found
            <a href="/" class="mt-4 hover:text-pink-400 group flex flex-nowrap">
                <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                <span class="whitespace-nowrap">home</span>
                <span class="text-white opacity-40 group-hover:opacity-60">]</span>
            </a>
        </div>
    </div>
</template>

<style>
article.prose {
    --fg: white;
    --bg: black;

    --tw-prose-body: var(--fg) !important;
    --tw-prose-headings: var(--fg) !important;
    --tw-prose-lead: var(--fg) !important;
    --tw-prose-links: var(--fg) !important;
    --tw-prose-bold: var(--fg) !important;
    --tw-prose-counters: var(--fg) !important;
    --tw-prose-bullets: var(--fg) !important;
    --tw-prose-hr: var(--fg) !important;
    --tw-prose-quotes: var(--fg) !important;
    --tw-prose-quote-borders: var(--fg) !important;
    --tw-prose-captions: var(--fg) !important;
    --tw-prose-th-borders: var(--fg) !important;
    --tw-prose-td-borders: var(--fg) !important;
    --tw-prose-invert-body: var(--fg) !important;
    --tw-prose-invert-headings: var(--fg) !important;
    --tw-prose-invert-lead: var(--fg) !important;
    --tw-prose-invert-links: var(--fg) !important;
    --tw-prose-invert-bold: var(--fg) !important;
    --tw-prose-invert-counters: var(--fg) !important;
    --tw-prose-invert-bullets: var(--fg) !important;
    --tw-prose-invert-hr: var(--fg) !important;
    --tw-prose-invert-quotes: var(--fg) !important;
    --tw-prose-invert-quote-borders: var(--fg) !important;
    --tw-prose-invert-captions: var(--fg) !important;
    --tw-prose-invert-code: var(--fg) !important;
    --tw-prose-invert-pre-code: var(--fg) !important;
    --tw-prose-invert-th-borders: var(--fg) !important;
    --tw-prose-invert-td-borders: var(--fg) !important;

    --tw-prose-code: var(--fg) !important;
    --tw-prose-pre-code: var(--fg) !important;
    --tw-prose-pre-bg: var(--bg) !important;
}

del {
    opacity: 40!important;
}

del:hover {
    opacity: 100!important;
}
</style>