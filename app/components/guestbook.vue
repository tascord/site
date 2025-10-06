<template>
    <div class="mt-4">
        <form @submit.prevent="submitEntry" class="w-full flex-col space-y-2">
            <input v-model="author" type="text"
                class="w-full h-8 bg-black border-white border p-1 px-2 focus-visible:outline-0 focus-visible:border-pink-400"
                placeholder="[name]" />
            <div class="flex space-x-2">
                <textarea v-model="content"
                    class="w-full h-12 bg-black border-white border p-1 px-2 focus-visible:outline-0 focus-visible:border-pink-400"
                    placeholder="any words are appreciated" :disabled="isSubmitting" />
                <button type="submit" :disabled="isSubmitting || !content || content.length < 2"
                    class="h-12 aspect-square text-l bg-black border-white border focus-visible:outline-0 focus-visible:border-pink-400 hover:border-pink-400 disabled:opacity-50 disabled:cursor-not-allowed">
                    {{ isSubmitting ? '...' : '→' }}
                </button>
            </div>
            <div class="flex justify-between w-full space-x-4 items-center">
                <div class="flex space-x-4 items-center">
                    <div v-if="message" :class="messageClass" class="text-sm">
                        {{ message }}
                    </div>
                    <div v-if="content.length > 0" :class="characterCountClass" class="text-sm">
                        {{ content.length }}/{{ GB_MAX_LEN }}
                    </div>
                </div>
                <a href="/guestbook" class="hover:text-pink-400 group flex flex-nowrap">
                    <span class="text-white opacity-40 group-hover:opacity-60">[</span>
                    <span class="whitespace-nowrap">{{ entryCount }} entries</span>
                    <span class="text-white opacity-40 group-hover:opacity-60">]</span>
                </a>
            </div>
        </form>
    </div>
</template>

<script setup lang="ts">
const GB_MAX_LEN = 300;

type Entry = { author?: string, content: string }
type ApiResponse = { success: boolean, entry?: Entry }

const author = ref('')
const content = ref('')
const isSubmitting = ref(false)
const message = ref('')
const entryCount = ref(0)

const messageClass = computed(() => {
    if (message.value.includes('success')) return 'text-green-400'
    if (message.value.includes('error') || message.value.includes('inappropriate')) return 'text-red-400'
    return 'text-yellow-400'
})

const characterCountClass = computed(() => {
    const length = content.value.length
    if (length > GB_MAX_LEN) return 'text-red-400'
    if (length > GB_MAX_LEN * 0.8) return 'text-yellow-400'
    return 'text-white opacity-60'
})

// Load initial entry count
try {
    const posts = await $fetch('/api/guest', {
        method: 'OPTIONS',
    }) as number;

    entryCount.value = posts
} catch (error) {
    entryCount.value = -1
}

async function submitEntry() {
    if (!content.value || content.value.length < 2) {
        message.value = 'Content must be at least 2 characters'
        return
    }

    if (content.value.length > 800) {
        message.value = 'Content must be 800 characters or less'
        return
    }

    isSubmitting.value = true
    message.value = ''

    try {
        const response = await $fetch('/api/guest', {
            method: 'PUT',
            body: {
                author: author.value || undefined,
                content: content.value
            }
        }) as ApiResponse

        if (response.success) {
            message.value = author.value.length > 0 ? `thank you, ${author.value}.` : 'thank you.';
            author.value = ''
            content.value = ''
            entryCount.value++
        }
    } catch (error: any) {
        if (error.status === 400) {
            if (error.data?.message?.includes('inappropriate')) {
                message.value = 'Content flagged as inappropriate'
            } else {
                message.value = error.data?.message || 'Invalid content'
            }
        } else {
            message.value = String(error)
        }
    } finally {
        isSubmitting.value = false
    }
}
</script>
