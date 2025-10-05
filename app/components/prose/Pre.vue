<script setup lang="ts">
// @ts-ignore
import Prism from 'prismjs'
import 'prismjs/components/prism-javascript'
import 'prismjs/components/prism-typescript'
import 'prismjs/components/prism-css'
import 'prismjs/components/prism-markup'
import 'prismjs/components/prism-json'
import 'prismjs/components/prism-bash'
import 'prismjs/components/prism-python'
import 'prismjs/components/prism-java'

let { code, class: lang } = (useSlots().default!() as any[])[0]!.ctx.attrs;
lang = lang.replace('language-', '');

const highlightedLines = computed(() => {
    const lines = code.split('\n')
    if (Prism.languages[lang]) {
        const fullHighlighted = Prism.highlight(code, Prism.languages[lang], lang)
        return fullHighlighted.split('\n')
    }

    return lines
})

const copyText = () => {
    navigator.clipboard.writeText(code);
}

const deIndent = (text: string) => {
    const lines = text.split('\n');
    // Find minimum indent (ignore empty lines)
    const indents = lines
        .filter(line => line.trim())
        .map(line => ((line.match(/^(\s*)/) ?? [])[1] ?? '').length);
    const minIndent = indents.length ? Math.min(...indents) : 0;
    return lines.map(line => line.slice(minIndent)).join('\n');
}
</script>

<template>
    <div class="relative not-prose codeblock w-full" v-if="lang">
        <header class="no-prose flex justify-between py-2 -mb-2 border border-b-0 px-4">
            <span>.{{ lang }}</span>
            <button class="w-8 text-right" @click="copyText">📋</button>
        </header>
        <pre class="not-prose flex flex-col border py-4 overflow-x-auto w-full">
            <code v-for="(line, index) in highlightedLines" :key="index" v-html="line || '&nbsp;'"></code>
        </pre>
    </div>
    <pre v-else><slot/></pre>
</template>

<style>
pre:has(code) {
    counter-reset: line;
    background: black;
}

pre code {
    counter-increment: line;
    position: relative;
    padding-left: 2.5rem;
}

code:before {
    content: counter(line);
    position: sticky;
    left: 0;
    color: #666;
    text-align: right;
    width: 5rem;
    display: inline-block;
    background: linear-gradient(to right, black 60%, transparent);
    padding-right: 2.5rem;
    margin-left: -3rem;
}

.codeblock, .codeblock * {
    background: black!important;
}
</style>