<script setup lang="ts">
import { computed } from 'vue';
const DOLLCODE_DIGITS: [string, string, string] = ['▌', '▖', '▘'];
const props = defineProps<{ text: string }>();

const text = computed(() => textToDollcode(props.text));

function bytesToBigIntBE(bytes: Uint8Array): bigint {
    let result = BigInt(0);
    for (const byte of bytes) {
        result = (result * BigInt(256)) + BigInt(byte);
    }
    return result;
}

function textToDollcode(src: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(src);
    let int = bytesToBigIntBE(bytes);

    if (int === BigInt(0)) {
        return "";
    }

    const output: string[] = [];
    const three = BigInt(3);

    while (int > BigInt(0)) {
        let modulo = int % three;
        const moduloNum = Number(modulo);
        output.push(DOLLCODE_DIGITS[moduloNum]!);
        if (modulo === BigInt(0)) {
            int = (int - three) / three;
        } else {
            int = (int - modulo) / three;
        }
    }

    return output.reverse().join('');
}

</script>


<template>
    <span :title="props.text">{{ text }}</span>
</template>