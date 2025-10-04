<script setup lang="ts">
import { ref, onMounted } from 'vue'

const RESOLUTION = 20;

const albumAscii = ref<string[][]>([]);
const nowPlaying = ref<{
    album: {
        "#text": string
        mbid: string
    }
    artist: {
        "#text": string
        mbid: string
    }
    date: {
        "#text": string
        uts: string
    }
    image: Array<{
        "#text": string
        size: string
    }>
    mbid: string
    name: string
    streamable: string
    url: string
} | null>(null);

onMounted(async () => {
    try {
        const res = await fetch('https://lastfm-last-played.biancarosa.com.br/imflo_pink/latest-song')
        if (!res.ok) throw 'Network !== 2xx';
        const data = await res.json()
        nowPlaying.value = data.track

        const img = new Image();
        img.crossOrigin = 'Anonymous';
        img.src = nowPlaying.value?.image[0]?.['#text'] ?? '';
        img.onload = () => {
            const canvas = document.createElement('canvas');
            canvas.width = RESOLUTION;
            canvas.height = RESOLUTION;
            const ctx = canvas.getContext('2d');
            if (ctx) {
                ctx.drawImage(img, 0, 0, RESOLUTION, RESOLUTION);

                for (let y = 0; y < RESOLUTION; y++) {
                    let row = [];
                    for (let x = 0; x < RESOLUTION; x++) {
                        const imageData = ctx.getImageData(x, y, 1, 1).data;
                        const pixCol: string = `rgb(${imageData[0]},${imageData[1]},${imageData[2]})`;
                        row.push(pixCol)
                    }
                    albumAscii.value.push(row);
                }
            }
        }
    } catch (err) {
        console.error('Failed to fetch now playing:', err)
        nowPlaying.value = null
    }
})
</script>

<template>
    <div class="w-[calc(100%_-_4ch)] inline-flex">
        <span v-if="nowPlaying !== null">
            <div class="flex space-x-4 items-center">
                <div class="grid" :style="{
                    gridTemplateRows: `repeat(${RESOLUTION}, 1fr)`,
                    gridTemplateColumns: `repeat(${RESOLUTION}, 1fr)`,
                    width: `${RESOLUTION}em`,
                    height: `${RESOLUTION}em`,
                    lineHeight: '0.5em',
                    fontSize: '0.5em',
                    gap: '0',
                    fontFamily: 'monospace'
                }">
                    <template v-for="(row, rowIdx) in albumAscii">
                        <span v-for="(col, colIdx) in row" :key="`${rowIdx}-${colIdx}`" class="block" :style="{
                            gridRow: rowIdx + 1,
                            gridColumn: colIdx + 1,
                            color: col,
                            width: '1em',
                            height: '1em',
                            textAlign: 'center',
                            fontFamily: 'monospace',
                            background: col,
                            overflow: 'clip'
                        }">█</span>
                    </template>
                </div>
                <div class="flex flex-col">
                    <span>{{ nowPlaying?.name }} by {{ nowPlaying?.artist['#text'] }}</span>
                    <span>{{ nowPlaying?.album['#text'] }}</span>
                    <a target="_blank" :href="nowPlaying.url" class="hover:text-pink-400 group">
                        <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                        last.fm
                        <span class="text-white opacity-40 group-hover:opacity-60">]</span>
                    </a>
                </div>
            </div>
        </span>
        <span v-else>No player could handle this command</span>
    </div>
</template>