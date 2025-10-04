// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  modules: [
    '@nuxt/content',
    '@nuxt/fonts',
    '@nuxt/icon',
    '@nuxt/image',
    '@nuxtjs/tailwindcss'
  ],

  app: {
    head: {
      title: 'flora\'s site',
      htmlAttrs: { lang: 'en' },
      link: [
        { rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' },
      ]
    }
  },

  nitro: {
    esbuild: {
      options: {
        target: "esnext"
      }
    }
  },

  runtimeConfig: {
    OPENMOD_KEY: `8cbbfe1c-d400-42d5-814d-eb3879a76b68`,
    GUESTBOOK_MOD_SECRET: `!19-030844`,
  }
})