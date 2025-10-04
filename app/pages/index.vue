<script setup lang="ts">

const GROUPS = {
    'transgender': ['#7DDCFF', '#FF7DE9', '#FFFFFF', '#FF7DE9', '#7DDCFF'],
    'lesbian-adjacent': ['#FF714D', '#FFC5AB', '#FFFFFF', '#FFABE7', '#FF4DBE'],
    'deeply unserious': ['#833AB4'],
    'split into parts': ['#57C785'],
}

const lg_stops = (stops: string[]): String => {
    let step = 100 / stops.length;
    let output = [];

    for (let i = 0; i < stops.length; i++) {
        output.push(`${stops[i]} ${i * step}%`)
        output.push(`${stops[i]} ${(i + 1) * step}%`)
    }

    return output.join(', ');
}

const buttons: ([string, string, string] | [string, string])[] = [
    ['lesbian flag', 'https://caitsith.neocities.org/lesbians.jpg'],
    ['transgender flag', 'https://caitsith.neocities.org/nicer.jpg'],
    ['best viewed on any browser', 'https://caitsith.neocities.org/buttons/newbuttons/any_browser_computer.gif'],
    ['no nazi, no faschism, no racism', 'https://caitsith.neocities.org/buttons/newbuttons/antinazi.gif'],
    ['dog house', 'https://caitsith.neocities.org/buttons/newbuttons/doghouse1.gif'],
    ['yuri!!!! (links to caitsith)', 'https://caitsith.neocities.org/buttons/yuriiibutton.png', 'https://caitsith.neocities.org/']
]

</script>


<template>
    <command command="whoami">
        i am 20 <sub class="opacity-40 -ml-2">(twenty)</sub> year-old software developer primarily fiddling with all
        sorts of rust nonsense. I am a big procedural-macro enjoyer and i specialize in building new systems to improve
        productivity
        in my teams.
    </command>

    <command command="groups">
        <span v-for="([key, value]) in Object.entries(GROUPS)" class="font-bold bg-clip-text text-transparent mr-2"
            :style="`background-image: linear-gradient(90deg, ${lg_stops(value)});`">{{ key }}</span>
    </command>

    <command command="cat buttons">
        <div class="inline-flex w-[calc(100%_-_4ch)] flex-wrap">
            <gcb v-for="button in buttons" :alt="button[0]" :img="button[1]" :link="button[2]" />
        </div>
    </command>

    <command command="ls -l">
        204 repositories
        <pre class="ml-[3ch] text-lg">// TODO: Add examples</pre>
    </command>

    <command command="playerctl metadata">
        <nowplaying />
    </command>

    <command command="vim guestbook" no_nl>
        <guestbook />
    </command>
</template>