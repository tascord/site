<script setup lang="ts">
const FIGLET = [
    '  ▄████  █    ████▄ █▄▄▄▄ ██     ',
    '  █▀   ▀ █    █   █ █  ▄▀ █ █    ',
    '  █▀▀    █    █   █ █▀▀▌  █▄▄█   ',
    '  █      ███▄ ▀████ █  █  █  █   ',
    '   █         ▀        █      █   ',
    '    ▀                ▀      █    ',
    '                           ▀     ',
];


const QUOTES = [
    'forever in your graces',
    'lalalalalalalala',
    'procedurally macroized',
    'unsafe { }',
    'extern "python" fn main()'
]

</script>

<template>
    <nav class="py-2 px-8 flex items-center justify-between w-full h-[15ch] mb-12">
        <div class="grid place-items-center h-full relative">
            <pre title="flora"
                class="block -ml-[2ch] leading-[1.25rem] text-xl select-none font-bold bg-clip-text text-transparent bg-gradient-to-r from-rose-600 to-pink-800">
                <a href="/" class="block -mt-10">
                    <span v-for="line in FIGLET" class="block">{{ line }}<br/></span>
                </a>
        <span class="absolute text-white -bottom-[2ch] left-[2ch] text-shadow-xl text-lg">{{ QUOTES[Math.floor(Math.random() * QUOTES.length)] }}</span>
      </pre>
        </div>
        <div
            class="hidden sm:grid place-items-center h-full text-xl select-none font-bold bg-clip-text text-transparent bg-gradient-to-r from-rose-600 to-pink-800">
            <a target="_blank" href="https://noe.sh/dollcode/">
                <ttpc text="<3" />
            </a>
        </div>
    </nav>
</template>
