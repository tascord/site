<template>
    <li>
        <p class="text-lg opacity-75 inline-block not-prose text-nowrap whitespace-pre-line">
            <span class="text-xl opacity-40 mr-2 inline-block float-start">╰&rsaquo;</span>
        </p>
        <div class="inline-block">
            <slot />
        </div>
    </li>
</template>

<style>
ul li {
    display: inline-flex;
    align-items: center;
    width: 100%;
    margin-left: -0.5rem;
}

ul:has(li) {
    padding-left: 0 !important;
}

ol li p.not-prose {
    display: none;
}

ol li::marker {
    opacity: 40 !important;
}
</style>